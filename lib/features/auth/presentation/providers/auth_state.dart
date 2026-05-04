import 'package:fitflow/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Emitted after forgotPassword succeeds so the UI can navigate to verify OTP.
class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess();
}

/// Emitted after OTP verification succeeds so the UI can navigate to reset password.
class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

/// Emitted after password reset succeeds.
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}
