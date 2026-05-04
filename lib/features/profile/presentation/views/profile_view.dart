import 'package:fitflow/core/common/widgets/app_section_header.dart';
import 'package:fitflow/core/common/widgets/app_settings_card.dart';
import 'package:fitflow/core/common/widgets/app_settings_tile.dart';
import 'package:fitflow/core/common/widgets/user_avatar.dart';
import 'package:fitflow/core/providers/theme_provider.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/core/util/dialog_utils.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthUnauthenticated) {
        context.go(RouteNames.login);
      }
    });

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.p16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    AppSpacing.gapV8,
                    UserAvatar(name: user.name, avatarUrl: user.avatarUrl),
                    AppSpacing.gapV12,
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.gapV4,
                    Text(user.email, style: theme.textTheme.bodyMedium),
                    if (user.phone.isNotEmpty) ...[
                      AppSpacing.gapV4,
                      Text(
                        user.phone,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.blackColor40,
                        ),
                      ),
                    ],
                    AppSpacing.gapV20,
                  ],
                ),
              ),

              // ── Account Section ──────────────────────────────────────────
              const AppSectionHeader(label: 'Account'),
              AppSpacing.gapV8,
              AppSettingsCard(
                children: [
                  AppSettingsTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    onTap: () => context.push(RouteNames.editProfile),
                  ),
                  const AppSettingsDivider(),
                  AppSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    onTap: () => context.push(RouteNames.forgotPassword),
                  ),
                ],
              ),
              AppSpacing.gapV16,

              // ── Address Info ─────────────────────────────────────────────
              if (user.hasAddress) ...[
                const AppSectionHeader(label: 'Shipping Address'),
                AppSpacing.gapV8,
                AppSettingsCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 20, color: theme.primaryColor),
                          AppSpacing.gapH12,
                          Expanded(
                            child: Text(
                              user.address!.fullAddress,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(height: 1.5),
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () =>
                                context.push(RouteNames.editProfile),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV16,
              ],

              // ── Preferences Section ──────────────────────────────────────
              const AppSectionHeader(label: 'Preferences'),
              AppSpacing.gapV8,
              AppSettingsCard(children: [_ThemeTile()]),
              AppSpacing.gapV16,

              // ── About Section ────────────────────────────────────────────
              const AppSectionHeader(label: 'About'),
              AppSpacing.gapV8,
              AppSettingsCard(
                children: [
                  AppSettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'App Version',
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.blackColor40),
                    ),
                    onTap: null,
                  ),
                  const AppSettingsDivider(),
                  AppSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const AppSettingsDivider(),
                  AppSettingsTile(
                    icon: Icons.description_outlined,
                    label: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
              AppSpacing.gapV16,

              // ── Logout ───────────────────────────────────────────────────
              AppSettingsCard(
                children: [
                  AppSettingsTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    iconColor: AppColors.errorColor,
                    labelColor: AppColors.errorColor,
                    showChevron: false,
                    onTap: () => DialogUtils.confirmAction(
                      context,
                      title: 'Logout',
                      content: 'Are you sure you want to logout?',
                      confirmLabel: 'Logout',
                      onConfirm: () =>
                          ref.read(authProvider.notifier).logout(),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV24,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Theme Tile ─────────────────────────────────────────────────────────────────
// Kept private here because it is tightly coupled to themeProvider and has no
// use outside the profile screen.
class _ThemeTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            _themeIcon(themeMode),
            size: 20,
            color: theme.textTheme.bodyLarge?.color,
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Text(
              'Theme',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined, size: 16),
                tooltip: 'Light',
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined, size: 16),
                tooltip: 'System',
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined, size: 16),
                tooltip: 'Dark',
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (modes) {
              if (modes.isNotEmpty) {
                ref.read(themeProvider.notifier).setTheme(modes.first);
              }
            },
            showSelectedIcon: false,
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }

  IconData _themeIcon(ThemeMode mode) => switch (mode) {
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
        ThemeMode.system => Icons.brightness_auto_outlined,
      };
}
