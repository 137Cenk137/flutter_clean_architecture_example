import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthRepository _authRepository;
  AuthBlocBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthBlocInitial()) {
    on<AuthBlocSignUpEvent>((event, emit) async {
      emit(AuthBlocLoading());
      final response = await _authRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      response.fold(
        (l) => emit(AuthBlocFailure(l.toString())),
        (user) => emit(AuthBlocSuccess(user)),
      );
    });
    on<AuthBlocLoginEvent>((event, emit) async {
      emit(AuthBlocLoading());
      final response = await _authRepository.loginWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      response.fold(
        (l) => emit(AuthBlocFailure(l.toString())),
        (user) => emit(AuthBlocSuccess(user)),
      );
    });
  }
}
