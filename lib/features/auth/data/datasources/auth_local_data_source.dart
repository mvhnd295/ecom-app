import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Cache the authenticated user profile and tokens.
  Future<void> cacheUser({
    required UserModel user,
    required String token,
    String? refreshToken,
  });

  /// Return the last cached user or throw [CacheException].
  Future<UserModel> getCachedUser();

  /// Clear all auth-related data from local storage.
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheHelper cacheHelper;
  AuthLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<void> cacheUser({
    required UserModel user,
    required String token,
    String? refreshToken,
  }) async {
    await Future.wait([
      cacheHelper.setSessionToken(token),
      if (refreshToken != null) cacheHelper.setRefreshToken(refreshToken),
      cacheHelper.setUserId(user.id),
      cacheHelper.setUserProfile(user.toJson()),
    ]);
  }

  @override
  Future<UserModel> getCachedUser() async {
    final profile = cacheHelper.getUserProfile();
    if (profile == null) {
      throw CacheException(message: 'No cached user found.');
    }
    try {
      return UserModel.fromJson(profile);
    } catch (_) {
      throw CacheException(message: 'Failed to parse cached user.');
    }
  }

  @override
  Future<void> clearSession() async {
    await cacheHelper.clearUserData();
  }
}
