import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/theme/theme.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_clean_architecture/dependency_injection.dart';

void main() async {
  await initDependency();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<AuthBlocBloc>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clean Architecture',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
