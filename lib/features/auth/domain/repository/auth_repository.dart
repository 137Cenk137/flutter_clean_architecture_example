import 'package:fpdart/fpdart.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}
