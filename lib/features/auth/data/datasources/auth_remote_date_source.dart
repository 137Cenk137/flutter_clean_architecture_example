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
  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return 'success';
  }

  @override
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return 'success';
  }
}
