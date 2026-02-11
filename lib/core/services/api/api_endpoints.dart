import 'package:fitflow/core/constants/app_constants.dart';

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
  static String getUserById(String userId) => '$AppConstants.baseUser/$userId';
  static String updateUser(String userId) => '$AppConstants.baseUser/$userId';
  static String deleteUser(String userId) => '$AppConstants.baseUser/$userId';
  // Wishlist (user sub route) endpoints
  static String addToWishlist(String userId) =>
      '$AppConstants.baseUser/$userId/wishlist';
  static String getWishlist(String userId) =>
      '$AppConstants.baseUser/$userId/wishlist';
  static String removeFromWishlist(String userId, String productId) =>
      '$AppConstants.baseUser/$userId/wishlist/productId';
  // Cart (user sub route) endpoints
  static String addToCart(String userId) =>
      '$AppConstants.baseUser/$userId/cart';
  static String getCart(String userId) => '$AppConstants.baseUser/$userId/cart';
  static String getCartCount(String userId) =>
      '$AppConstants.baseUser/$userId/cart/count';
  static String getCartItemById(String userId, String cartItemId) =>
      '$AppConstants.baseUser/$userId/cart/$cartItemId';
  static String clearCart(String userId) =>
      '$AppConstants.baseUser/$userId/cart';
  static String removeCartItem(String userId, String cartItemId) =>
      '$AppConstants.baseUser/$userId/cart/$cartItemId';
  static String updateCartItem(String userId, String cartItemId) =>
      '$AppConstants.baseUser/$userId/cart/$cartItemId';
  static String updateCartItemQuantity(String userId, String cartItemId) =>
      '$AppConstants.baseUser/$userId/cart/$cartItemId/quantity';
  static String setCartQuantity(String userId, String cartItemId) =>
      '$AppConstants.baseUser/$userId/cart/$cartItemId/quantity/set';

  // Product endpoints
  static const String getProducts = '/products';
  static const String getProductById = '/products/:id';
  static const String searchProducts = '/products/search';
  static const String postReview = '/products/:id/review';
  static const String getReviews = '/products/:id/reviews';
}
