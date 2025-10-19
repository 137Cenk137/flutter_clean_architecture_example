import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_date_source.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final response = await authRemoteDataSource.getCurrentUser();
      return response != null
          ? Right(response)
          : Left(Failure('User not logged in'));
    } on ServerExcepiton catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() getUser,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure('No internet connection'));
      }
      final response = await getUser();
      return Right(response);
    } on ServerExcepiton catch (e) {
      return Left(Failure(e.message.toString()));
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
