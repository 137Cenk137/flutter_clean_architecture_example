import 'package:flutter_clean_architecture/core/common/app_user/appuser_cubit.dart';
import 'package:flutter_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_date_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:flutter_clean_architecture/features/blog/data/data_sources/blog_remote_datasources.dart';
import 'package:flutter_clean_architecture/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:flutter_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  await dotenv.load(fileName: '.env');
  await _addSupabaseDependency();
  _addCoreDependency();
  _addAuthDependency();
  _addBlogDependency();
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
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(internetConnection: InternetConnection()),
  );

  //data sources
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () =>
          AuthRemoteDataSourceImpl(supabase: serviceLocator<SupabaseClient>()),
    )
    //repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        connectionChecker: serviceLocator<ConnectionChecker>(),
        authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
      ),
    )
    //blocs
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        authRepository: serviceLocator<AuthRepository>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}

void _addBlogDependency() {
  //data sources
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () =>
          BlogRemoteDataSourceImpl(supabase: serviceLocator<SupabaseClient>()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator<Box>()),
    )
    //repositories
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator<BlogRemoteDataSource>(),
        blogLocalDataSource: serviceLocator<BlogLocalDataSource>(),
        connectionChecker: serviceLocator<ConnectionChecker>(),
      ),
    )
    //blocs
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(blogRepository: serviceLocator<BlogRepository>()),
    );
}
