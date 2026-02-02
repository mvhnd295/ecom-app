class StorageKeys {
  StorageKeys._();

  // Shared Preferences Keys
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String isFirstLaunch = 'is_first_launch';
  static const String appVersion = 'app_version';

  // Secure Storage Keys
  static const String sessionToken = 'session_token';
  static const String refreshToken = 'refresh_token';
  static const String apiKey = 'api_key';

  // Hive Box Names
  static const String userBox = 'user_box';
  // static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String favoritesBox = 'favorites_box';

  // Hive Keys
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String settings = 'settings';
  static const String apiCachePrefix = 'api_cache_';
  static const String favorites = 'favorites';
}
