import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  final String email;
  final String otp;
  const VerifyOtpParams({required this.email, required this.otp});
}

class VerifyOtpUsecase {
  final AuthRepository repository;
  const VerifyOtpUsecase(this.repository);

  Future<Either<Failure, void>> call(VerifyOtpParams params) {
    return repository.verifyOtp(email: params.email, otp: params.otp);
  }
}
