import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final LoginUsecase _loginUsecase;
  late final RegisterUsecase _registerUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final ForgotPasswordUsecase _forgotPasswordUsecase;

  @override
  AuthState build() {
    _loginUsecase = sl<LoginUsecase>();
    _registerUsecase = sl<RegisterUsecase>();
    _logoutUsecase = sl<LogoutUsecase>();
    _getCurrentUserUsecase = sl<GetCurrentUserUsecase>();
    _forgotPasswordUsecase = sl<ForgotPasswordUsecase>();
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

  // ── Forgot Password ────────────────────────────────────────────────────────
  Future<void> forgotPassword({required String email}) async {
    state = const AuthLoading();
    final result = await _forgotPasswordUsecase(ForgotPasswordParams(email: email));
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthForgotPasswordSuccess(),
    );
  }
}

// ── Global provider ───────────────────────────────────────────────────────────
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
