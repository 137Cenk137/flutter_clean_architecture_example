import 'package:flutter_clean_architecture/core/common/app_user/appuser_cubit.dart';
import 'package:flutter_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_date_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await _addSupabaseDependency();
  _addCoreDependency();
  _addAuthDependency();
}

Future<void> _addSupabaseDependency() async {
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  //serviceLocator.registerFactory(); dotnet scope version of it
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);
}

void _addCoreDependency() {
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
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
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: serviceLocator<AuthRepository>(),
      appUserCubit: serviceLocator<AppUserCubit>(),
    ),
  );
}
