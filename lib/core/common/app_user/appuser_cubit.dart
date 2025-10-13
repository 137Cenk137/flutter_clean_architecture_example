import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_state.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());
  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
      return;
    }
    emit(IsUserLoggedIn(user: user));
  }
}
