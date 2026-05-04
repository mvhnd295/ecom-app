import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_text_field.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).resetPassword(
            email: widget.email,
            newPassword: _passwordCtrl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
      if (next is AuthPasswordResetSuccess) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Password Reset'),
            content: const Text(
              'Your password has been reset successfully. Please log in with your new password.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(authProvider.notifier).logout();
                  context.go(RouteNames.login);
                },
                child: const Text('Log In'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'New Password',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a strong password for ${widget.email}.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  label: 'New Password',
                  hint: '••••••••',
                  controller: _passwordCtrl,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required.';
                    if (v.length < 8) return 'Password must be at least 8 characters.';
                    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include at least one uppercase letter.';
                    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Include at least one lowercase letter.';
                    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number.';
                    if (!RegExp(r'[!@#\$&*~^%]').hasMatch(v)) return 'Include at least one symbol.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: _confirmCtrl,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm your password.';
                    if (v != _passwordCtrl.text) return 'Passwords do not match.';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AuthButton(
                  label: 'Reset Password',
                  isLoading: isLoading,
                  onPressed: _onReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
