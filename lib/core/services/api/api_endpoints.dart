class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';

  // User endpoints
  static const String getUsers = '/users';
  static const String getUserById = '/users/:id';
  static const String updateUser = '/users/:id';
  static const String deleteUser = '/users/:id';

  // Product endpoints
  static const String getProducts = '/products';
  static const String getProductById = '/products/:id';
  static const String searchProducts = '/products/search';
  static const String postReview = '/products/:id/review';
  static const String getReviews = '/products/:id/reviews';
}
