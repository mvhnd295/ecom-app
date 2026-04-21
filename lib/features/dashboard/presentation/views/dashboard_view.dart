import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_count_notifier.dart';
import 'package:fitflow/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = DashboardUtils.locationToIndex(state.matchedLocation);
    final theme = context.theme;
    final inactiveColor = theme.textTheme.bodyMedium?.color;
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      key: DashboardUtils.scaffoldKey,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(DashboardUtils.navItems.length, (index) {
                final NavItem item = DashboardUtils.navItems[index];
                final isActive = selectedIndex == index;
                final isCart = item.route == DashboardUtils.cartRoute;

                Widget icon = Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 24,
                  color: isActive ? theme.primaryColor : inactiveColor,
                );
                if (isCart && cartCount > 0) {
                  icon = Badge.count(
                    count: cartCount,
                    child: icon,
                  );
                }

                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(item.route),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon,
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive
                                ? theme.primaryColor
                                : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
