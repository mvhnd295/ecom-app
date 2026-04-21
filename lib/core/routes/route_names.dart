class RouteNames {
  RouteNames._();

  // Auth Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Dashboard Shell Routes
  static const String home = '/home';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  // Feature Routes
  static const String productDetail = '/product/:id';

  static String productDetailPath(String id) => '/product/$id';
}
