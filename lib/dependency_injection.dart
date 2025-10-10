import 'package:flutter_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_date_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  //serviceLocator.registerFactory(); dotnet scope version of it
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);
  _addAuthDependency();
}

void _addAuthDependency() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: serviceLocator<SupabaseClient>()),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthBlocBloc>(
    () => AuthBlocBloc(authRepository: serviceLocator<AuthRepository>()),
  );
}
