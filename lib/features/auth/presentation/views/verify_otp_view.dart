import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_text_field.dart';

class VerifyOtpView extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends ConsumerState<VerifyOtpView> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).verifyOtp(
            email: widget.email,
            otp: _otpCtrl.text.trim(),
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
      if (next is AuthOtpVerified) {
        context.push(RouteNames.resetPassword, extra: widget.email);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
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
                  'Enter OTP',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent a code to ${widget.email}. It expires in 10 minutes.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  label: 'OTP Code',
                  hint: '123456',
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_clock_outlined),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'OTP is required.';
                    if (v.length < 4) return 'Enter the full OTP code.';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AuthButton(
                  label: 'Verify OTP',
                  isLoading: isLoading,
                  onPressed: _onVerify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
