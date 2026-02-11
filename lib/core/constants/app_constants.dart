class AppConstants {
  AppConstants._();
  static const String baseUrl = 'http://localhost:3000/api/v1';
  static const String baseUser = '/users';
  static const String baseAdmin = '/admin';
  static const String baseCategory = '/categories';
  static const String baseCheckout = '/checkout';
  static const String baseProduct = '/products';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheDuration = Duration(minutes: 10);
  static const String appName = 'E-Buy';
  static const String appVersion = '1.0.0';
}
