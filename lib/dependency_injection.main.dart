part of 'dependency_injection.dart';

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
