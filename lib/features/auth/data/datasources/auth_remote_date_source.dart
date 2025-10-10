import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:supabase/supabase.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;
  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<String> signUp({
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

      return response.user!.id;
    } catch (e) {
      throw ServerExcepiton(e.toString());
    }
  }

  @override
  Future<String> loginWithEmailAndPassword({
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
      return response.user!.id;
    } catch (e) {
      throw ServerExcepiton(e.toString());
    }
  }
}
