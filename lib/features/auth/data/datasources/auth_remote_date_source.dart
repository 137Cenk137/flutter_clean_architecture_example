import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel?> getCurrentUser();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;
  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Session? get currentUserSession => supabase.auth.currentSession;
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final response = await supabase
            .from('profiles')
            .select('*')
            .eq('id', currentUserSession!.user.id)
            .single();
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw ServerExcepiton(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw ServerExcepiton('User not created');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExcepiton(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerExcepiton('User not found');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExcepiton(e.toString());
    }
  }
}
