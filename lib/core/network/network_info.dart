import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
        final connectivityResult = await InternetAddress.lookup('google.com');
        return connectivityResult.isNotEmpty && connectivityResult.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}