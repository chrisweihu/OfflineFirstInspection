import 'package:offline_first_inspection/core/constants/constants.dart';
import 'package:offline_first_inspection/core/error/exceptions.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/network/connection_checker.dart';
import 'package:offline_first_inspection/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';
import 'package:offline_first_inspection/features/auth/data/models/user_model.dart';
import 'package:offline_first_inspection/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  final IAuthRemoteDataSource remoteDataSource;
  final IConnectionChecker connectionChecker;

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!(await connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure(Constants.noConnectionErrorMessage));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }

      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
    // try {
    //   final user = await remoteDataSource.loginWithEmailPassword(
    //     email: email,
    //     password: password,
    //   );
    //   return right(user);
    // } on ServerException catch (e) {
    //   return left(Failure(e.message));
    // }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
    // try {
    //   final user = await remoteDataSource.signUpWithEmailPassword(
    //     name: name,
    //     email: email,
    //     password: password,
    //   );
    //   return right(user);
    // } on ServerException catch (e) {
    //   return left(Failure(e.message));
    // }
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!(await connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
