import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/auth/domain/entities/user_entity.dart';
import 'package:fitflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final LoginUsecase _loginUsecase;
  late final RegisterUsecase _registerUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final ForgotPasswordUsecase _forgotPasswordUsecase;
  late final VerifyOtpUsecase _verifyOtpUsecase;
  late final ResetPasswordUsecase _resetPasswordUsecase;

  @override
  AuthState build() {
    _loginUsecase = sl<LoginUsecase>();
    _registerUsecase = sl<RegisterUsecase>();
    _logoutUsecase = sl<LogoutUsecase>();
    _getCurrentUserUsecase = sl<GetCurrentUserUsecase>();
    _forgotPasswordUsecase = sl<ForgotPasswordUsecase>();
    _verifyOtpUsecase = sl<VerifyOtpUsecase>();
    _resetPasswordUsecase = sl<ResetPasswordUsecase>();
    return const AuthInitial();
  }

  // ── Check for an existing session ──────────────────────────────────────────
  Future<void> checkCurrentUser() async {
    state = const AuthLoading();
    final result = await _getCurrentUserUsecase();
    result.fold(
      (_) => state = const AuthUnauthenticated(),
      (user) => state = AuthAuthenticated(user),
    );
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await _loginUsecase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  // ── Register ───────────────────────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AuthLoading();
    final result = await _registerUsecase(
      RegisterParams(name: name, email: email, password: password, phone: phone),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = const AuthLoading();
    final result = await _logoutUsecase();
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(),
    );
  }

  // ── Update in-memory user (called after a successful profile update) ──────
  void updateUser(UserEntity user) {
    state = AuthAuthenticated(user);
  }

  // ── Forgot Password ────────────────────────────────────────────────────────
  Future<void> forgotPassword({required String email}) async {
    state = const AuthLoading();
    final result = await _forgotPasswordUsecase(ForgotPasswordParams(email: email));
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthForgotPasswordSuccess(),
    );
  }

  // ── Verify OTP ─────────────────────────────────────────────────────────────
  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const AuthLoading();
    final result = await _verifyOtpUsecase(VerifyOtpParams(email: email, otp: otp));
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthOtpVerified(),
    );
  }

  // ── Reset Password ─────────────────────────────────────────────────────────
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = const AuthLoading();
    final result = await _resetPasswordUsecase(
      ResetPasswordParams(email: email, newPassword: newPassword),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthPasswordResetSuccess(),
    );
  }
}

// ── Global provider ───────────────────────────────────────────────────────────
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
