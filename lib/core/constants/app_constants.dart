import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  /// - Web (Chrome): uses localhost directly since the browser and server share the host.
  /// - Android emulator: 10.0.2.2 maps to the host machine.
  /// - Physical device: replace with your machine's LAN IP (e.g. 192.168.1.x).
  static final String baseUrl = kIsWeb
      ? 'http://localhost:3000/api/v1'
      : defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3000/api/v1'
          : 'http://localhost:3000/api/v1';

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
