import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            BlocConsumer<AuthBlocBloc, AuthBlocState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is AuthBlocLoading) {
                  return const Loader();
                }
                if (state is AuthBlocFailure) {
                  showSnackBar(context, state.error);
                  return const SizedBox.shrink();
                }

                if (state is AuthBlocSuccess) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login Page',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthField(
                          hintText: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        AuthField(
                          hintText: 'Password',
                          controller: _passwordController,
                          isObscureText: true,
                          isPassordField: true,
                        ),
                        const SizedBox(height: 20),
                        AuthGradientButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBlocBloc>().add(
                                AuthBlocLoginEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          text: 'Login',
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account?  ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppPallete.gradient1,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
