import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_cubit.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_state.dart';
import 'package:flutter_clean_architecture/core/theme/theme.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_clean_architecture/dependency_injection.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_page.dart';

void main() async {
  await initDependency();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedInEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clean Architecture',
      theme: AppTheme.darkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return const BlogPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
