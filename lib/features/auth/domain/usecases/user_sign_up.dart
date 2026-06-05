import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';
import 'package:offline_first_inspection/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements IUseCase<User, UserSignUpParams> {
  final IAuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
