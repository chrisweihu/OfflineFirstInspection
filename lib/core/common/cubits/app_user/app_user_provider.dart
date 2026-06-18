import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitialState extends AppUserState {}

final class AppUserLoggedInState extends AppUserState {
  final User user;
  const AppUserLoggedInState(this.user);
}

class AppUserNotifier extends Notifier<AppUserState> {
  @override
  AppUserState build() => AppUserInitialState();

  void updateUser(User? user) {
    if (user == null) {
      state = AppUserInitialState();
    } else {
      state = AppUserLoggedInState(user);
    }
  }
}

final appUserProvider = NotifierProvider<AppUserNotifier, AppUserState>(AppUserNotifier.new);
