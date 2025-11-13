import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  ///------------------------app_version--------------------------
  static const String appVersion = '';
  static const String googleAddressKey = 'AIzaSyDGAXXijQTnnzJX2eDbn4M5Dj-aGRT7Bmg';
  
  static String? _cachedVersion;
  
  /// Get current app version from package info
  static Future<String> getCurrentVersion() async {
    if (_cachedVersion != null) {
      return _cachedVersion!;
    }
    
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _cachedVersion = packageInfo.version;
      return _cachedVersion!;
    } catch (e) {
      print('Error getting app version: $e');
      return appVersion; // Return fallback version
    }
  }
  
  /// Get current app version (synchronous fallback)
  static String get currentVersion => _cachedVersion ?? appVersion;

  ///------------------------Splash_screen_logo-------------------
  static const String splashLogo = 'images/app_logo.png';

  ///------------------------logo-------------------
  static const String logo = 'images/logo2.png';

  ///------------------------Onboard_Images-----------------------
  static const String onBoard1 = 'images/onboard1.png';
  static const String onBoard2 = 'images/onboard2.png';
  static const String onBoard3 = 'images/onboard3.png';
}

String purchaseCode = 'fba8d4a5-c71b-476d-99c4-3b2e7f4b61';
