import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_provider.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/current_user.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_login.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_sign_up.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final User user;
  const AuthSuccessState(this.user);
}

final class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);
}

class AuthNotifier extends Notifier<AuthState> {
  late final UserSignUp _userSignUp;
  late final UserLogin _userLogin;
  late final CurrentUser _currentUser;

  @override
  AuthState build() {
    _userSignUp = getIt<UserSignUp>();
    _userLogin = getIt<UserLogin>();
    _currentUser = getIt<CurrentUser>();
    return AuthInitialState();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = AuthLoadingState();

    final Either<Failure, User> res = await _userSignUp(
      UserSignUpParams(
        email: email,
        password: password,
        name: name,
      ),
    );

    res.fold(
      (Failure l) => state = AuthFailureState(l.message),
      (User r) => _emitAuthSuccess(r),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthLoadingState();
    
    final Either<Failure, User> res = await _userLogin(
      UserLoginParams(email: email, password: password),
    );

    res.fold(
      (Failure l) => state = AuthFailureState(l.message),
      (User r) => _emitAuthSuccess(r),
    );
  }

  Future<void> isUserLoggedIn() async {
    state = AuthLoadingState();

    final Either<Failure, User> res = await _currentUser(NoParams());

    res.fold(
      (Failure l) => state = AuthFailureState(l.message),
      (User r) => _emitAuthSuccess(r),
    );
  }

  void _emitAuthSuccess(User user) {
    ref.read(appUserProvider.notifier).updateUser(user);
    state = AuthSuccessState(user);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
