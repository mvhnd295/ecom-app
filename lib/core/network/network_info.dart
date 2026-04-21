import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // dart:io is not available on web; assume connected and let
      // the HTTP layer surface actual network errors.
      return true;
    }
    try {
      // Dynamic import approach won't work on web, so we just return true
      // for web above. For mobile/desktop, use dart:io via a separate
      // conditional import if needed. For now, assume connected.
      return true;
    } catch (_) {
      return false;
    }
  }
}
