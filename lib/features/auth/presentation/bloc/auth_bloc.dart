import 'package:bloc/bloc.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_cubit.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required AuthRepository authRepository,
    required AppUserCubit appUserCubit,
  }) : _authRepository = authRepository,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUpEvent>(_onAuthSignUpEvent);
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthIsUserLoggedInEvent>(_onAuthIsUserLoggedInEvent);
  }

  void _onAuthSignUpEvent(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _authRepository.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    response.fold(
      (l) => emit(AuthFailure(error: l.message.toString())),
      (r) => _emitUser(r, emit),
    );
  }

  void _onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    final response = await _authRepository.loginWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );
    response.fold(
      (l) => emit(AuthFailure(error: l.message.toString())),
      (r) => _emitUser(r, emit),
    );
  }

  void _onAuthIsUserLoggedInEvent(
    AuthIsUserLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _authRepository.getCurrentUser();
    response.fold(
      (l) => emit(AuthFailure(error: l.message.toString())),
      (r) => _emitUser(r, emit),
    );
  }

  void _emitUser(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
