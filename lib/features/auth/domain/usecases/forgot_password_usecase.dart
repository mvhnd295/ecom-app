import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams {
  final String email;
  const ForgotPasswordParams({required this.email});
}

class ForgotPasswordUsecase {
  final AuthRepository repository;
  const ForgotPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(email: params.email);
  }
}
