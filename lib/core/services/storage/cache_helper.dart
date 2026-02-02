import 'package:fitflow/core/extensions/string_extension.dart';
import 'package:fitflow/core/services/storage/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  late final SharedPreferences _prefs;
  late final Box _userBox;
  late final Box _cacheBox;
  final _secureStorage = const FlutterSecureStorage();

  CacheHelper._();
  static final CacheHelper _instance = CacheHelper._();
  factory CacheHelper() => _instance;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    _userBox = await Hive.openBox(StorageKeys.userBox);
    _cacheBox = await Hive.openBox(StorageKeys.cacheBox);
    _isInitialized = true;
  }

  // Shared Preferences Methods
  ThemeMode getThemeMode() {
    final mode = _prefs.getString(StorageKeys.themeMode);
    return mode != null ? mode.toThemeMode() : ThemeMode.system;
  }

  Future<bool> setThemeMode(ThemeMode mode) async {
    return _prefs.setString(StorageKeys.themeMode, mode.name);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
  }

  Future<bool> setFirstLaunch(bool isFirst) {
    return _prefs.setBool(StorageKeys.isFirstLaunch, isFirst);
  }

  // Secure Storage Methods
  Future<String?> getSessionToken() {
    return _secureStorage.read(key: StorageKeys.sessionToken);
  }

  Future<void> setSessionToken(String token) async {
    await _secureStorage.write(key: StorageKeys.sessionToken, value: token);
  }

  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: StorageKeys.refreshToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }

  // Hive Methods
  String? getUserId() {
    return _userBox.get(StorageKeys.userId);
  }

  Future<void> setUserId(String userId) async {
    await _userBox.put(StorageKeys.userId, userId);
  }

  Map<String, dynamic>? getUserProfile() {
    return _userBox.get(StorageKeys.userProfile);
  }

  Future<void> setUserProfile(Map<String, dynamic> profile) async {
    await _userBox.put(StorageKeys.userProfile, profile);
  }

  List<String> getFavorites() {
    final favorites = _userBox.get(StorageKeys.favorites);
    if (favorites is List) {
      return List<String>.from(favorites);
    }
    return [];
  }

  Future<void> setFavorites(List<String> favorites) async {
    await _userBox.put(StorageKeys.favorites, favorites);
  }

  // Cache API Responses
  Future<void> cacheResponse(String endpoint, dynamic data) async {
    final key = '${StorageKeys.apiCachePrefix}$endpoint';
    await _cacheBox.put(key, {
      'data': data,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  Map<String, dynamic>? getCachedResponse(String endpoint) {
    final key = '${StorageKeys.apiCachePrefix}$endpoint';
    final cachedData = _cacheBox.get(key);
    if (cachedData == null) return null;
    final cachedAt = DateTime.parse(cachedData['cachedAt']);
    final age = DateTime.now().difference(cachedAt);

    if (age.inMinutes > 10) {
      // Invalidate cache after 10 minutes
      _cacheBox.delete(key);
      return null;
    }
    return Map<String, dynamic>.from(cachedData['data']);
  }

  Future<void> clearUserData() async {
    await _userBox.clear();
    await _secureStorage.deleteAll();
  }
}
