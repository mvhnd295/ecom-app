import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams {
  final String email;
  final String newPassword;
  const ResetPasswordParams({required this.email, required this.newPassword});
}

class ResetPasswordUsecase {
  final AuthRepository repository;
  const ResetPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return repository.resetPassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}
