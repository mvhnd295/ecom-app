import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;
  const LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
