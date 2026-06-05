import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/core/common/entities/user.dart';
import 'package:offline_first_inspection/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements IUseCase<User, NoParams> {
  final IAuthRepository authRepository;
  const CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return authRepository.currentUser();
  }
}
