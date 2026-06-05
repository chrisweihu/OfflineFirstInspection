import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/current_user.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_login.dart';
import 'package:offline_first_inspection/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _appUserCubit = appUserCubit,
       _currentUser = currentUser,
       _userLogin = userLogin,
       _userSignUp = userSignUp,
       super(AuthInitialState()) {
    //This base event handler will tiggered before each of the derrived event handler to display loading indicator ui
    // how do we know this is triggered before other on<> handlers? Does the code declaration order decide it?
    on<AuthEvent>((event, emit) => emit(AuthLoadingState()));
    on<AuthSignUpEvent>(_onAuthSignUp);
    on<AuthLoginEvent>(_onAuthLogin);
    on<IsAuthUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    //emit(AuthLoadingState());

    final Either<Failure, User> res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    //fpddart::Either<L,R>.fold(): Execute onLeft when value is [Left], otherwise execute onRight. Same as match.
    res.fold(
      (Failure l) => emit(AuthFailureState(l.message)),
      (User r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    //emit(AuthLoadingState());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailureState(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  FutureOr<void> _isUserLoggedIn(
    IsAuthUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailureState(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccessState(user));
  }
}
