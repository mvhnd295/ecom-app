import 'package:fitflow/core/routes/route_names.dart';
import 'package:flutter/material.dart';

abstract class DashboardUtils {
  const DashboardUtils();

  static final scaffoldKey = GlobalKey<ScaffoldState>();

  static const String cartRoute = RouteNames.cart;

  static const List<NavItem> navItems = [
    NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: RouteNames.home,
    ),
    NavItem(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search_rounded,
      route: RouteNames.search,
    ),
    NavItem(
      label: 'Cart',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      route: RouteNames.cart,
    ),
    NavItem(
      label: 'Wishlist',
      icon: Icons.favorite_outline_rounded,
      activeIcon: Icons.favorite_rounded,
      route: RouteNames.wishlist,
    ),
    NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: RouteNames.profile,
    ),
  ];

  static int locationToIndex(String location) {
    if (location.startsWith(RouteNames.search)) return 1;
    if (location.startsWith(RouteNames.cart)) return 2;
    if (location.startsWith(RouteNames.wishlist)) return 3;
    if (location.startsWith(RouteNames.profile)) return 4;
    return 0; // default to Home
  }
}

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
