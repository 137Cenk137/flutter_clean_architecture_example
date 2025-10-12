part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

final class AuthBlocSignUpEvent extends AuthBlocEvent {
  final String name;
  final String email;
  final String password;
  AuthBlocSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthBlocLoginEvent extends AuthBlocEvent {
  final String email;
  final String password;
  AuthBlocLoginEvent({required this.email, required this.password});
}

final class AuthBlocIsUserLoggedInEvent extends AuthBlocEvent {}
