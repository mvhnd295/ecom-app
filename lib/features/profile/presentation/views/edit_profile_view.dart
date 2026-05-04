import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/features/auth/domain/entities/address.dart';
import 'package:fitflow/features/auth/domain/entities/user_entity.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:fitflow/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fitflow/features/profile/presentation/providers/profile_notifier.dart';
import 'package:fitflow/features/profile/presentation/providers/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _postalCtrl;
  late final TextEditingController _houseCtrl;
  late final TextEditingController _aptCtrl;

  bool _addressExpanded = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _countryCtrl = TextEditingController(text: user?.address?.country ?? '');
    _cityCtrl = TextEditingController(text: user?.address?.city ?? '');
    _streetCtrl = TextEditingController(text: user?.address?.street ?? '');
    _postalCtrl = TextEditingController(text: user?.address?.postalCode ?? '');
    _houseCtrl = TextEditingController(text: user?.address?.houseNumber ?? '');
    _aptCtrl =
        TextEditingController(text: user?.address?.apartmentNumber ?? '');

    // If user already has an address, expand the section by default.
    if (user?.hasAddress == true) {
      _addressExpanded = true;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    _postalCtrl.dispose();
    _houseCtrl.dispose();
    _aptCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    final UserEntity user = authState.user;

    Address? address;
    if (_addressExpanded) {
      final hasAnyAddressField = [
        _countryCtrl.text,
        _cityCtrl.text,
        _streetCtrl.text,
        _postalCtrl.text,
        _houseCtrl.text,
        _aptCtrl.text,
      ].any((v) => v.trim().isNotEmpty);

      if (hasAnyAddressField) {
        address = Address(
          country: _countryCtrl.text.trim().isEmpty
              ? null
              : _countryCtrl.text.trim(),
          city:
              _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
          street: _streetCtrl.text.trim().isEmpty
              ? null
              : _streetCtrl.text.trim(),
          postalCode: _postalCtrl.text.trim().isEmpty
              ? null
              : _postalCtrl.text.trim(),
          houseNumber: _houseCtrl.text.trim().isEmpty
              ? null
              : _houseCtrl.text.trim(),
          apartmentNumber:
              _aptCtrl.text.trim().isEmpty ? null : _aptCtrl.text.trim(),
        );
      }
    }

    ref.read(profileProvider.notifier).updateProfile(
          userId: user.id,
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: address,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<ProfileState>(profileProvider, (_, state) {
      switch (state) {
        case ProfileSuccess():
          context.showSuccessSnackBar('Profile updated successfully!');
          ref.read(profileProvider.notifier).reset();
          Navigator.of(context).pop();
        case ProfileError(:final message):
          context.showErrorSnackBar(message);
          ref.read(profileProvider.notifier).reset();
        default:
          break;
      }
    });

    final isLoading = ref.watch(profileProvider) is ProfileLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.p16,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Personal Info ─────────────────────────────────────────────
                Text(
                  'Personal Info',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapV16,
                AuthTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameCtrl,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name is required';
                    }
                    if (v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                AppSpacing.gapV16,
                AuthTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                AppSpacing.gapV24,

                // ── Address ───────────────────────────────────────────────────
                InkWell(
                  onTap: () =>
                      setState(() => _addressExpanded = !_addressExpanded),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          'Address',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: _addressExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      AppSpacing.gapV16,
                      AuthTextField(
                        label: 'Country',
                        hint: 'e.g. United States',
                        controller: _countryCtrl,
                        prefixIcon: const Icon(Icons.flag_outlined),
                      ),
                      AppSpacing.gapV16,
                      AuthTextField(
                        label: 'City',
                        hint: 'e.g. New York',
                        controller: _cityCtrl,
                        prefixIcon: const Icon(Icons.location_city_outlined),
                      ),
                      AppSpacing.gapV16,
                      AuthTextField(
                        label: 'Street',
                        hint: 'e.g. Main Street',
                        controller: _streetCtrl,
                        prefixIcon: const Icon(Icons.signpost_outlined),
                      ),
                      AppSpacing.gapV16,
                      Row(
                        children: [
                          Expanded(
                            child: AuthTextField(
                              label: 'House No.',
                              hint: 'e.g. 42',
                              controller: _houseCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          AppSpacing.gapH12,
                          Expanded(
                            child: AuthTextField(
                              label: 'Apt No.',
                              hint: 'e.g. 3B',
                              controller: _aptCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapV16,
                      AuthTextField(
                        label: 'Postal Code',
                        hint: 'e.g. 10001',
                        controller: _postalCtrl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                  crossFadeState: _addressExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
                AppSpacing.gapV32,

                AuthButton(
                  label: 'Save Changes',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
                AppSpacing.gapV16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
