import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn({required this.user});
}
