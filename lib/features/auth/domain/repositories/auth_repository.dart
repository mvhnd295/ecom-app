import 'package:fpdart/fpdart.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Login with email and password.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register a new account.
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  /// Logout the current user and clear local session.
  Future<Either<Failure, void>> logout();

  /// Get the locally cached current user.
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Send a forgot-password email.
  Future<Either<Failure, void>> forgotPassword({required String email});
}
