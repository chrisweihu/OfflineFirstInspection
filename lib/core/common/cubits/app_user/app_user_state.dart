part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitialState extends AppUserState {}

final class AppUserLoggedInState extends AppUserState {
  final User user;
  const AppUserLoggedInState(this.user);
}
