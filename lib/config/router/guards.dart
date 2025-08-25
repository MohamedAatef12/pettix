import 'package:pettix/core/utils/logger.dart';
import 'package:pettix/data/caching/secure_storage_helper.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';

class AuthService {
  static Future<bool> checkAuth() async {
    await SharedPrefsHelper.init();

    final isSignedUp = SharedPrefsHelper.getBool('isSignedUp') ?? false;
    final isLoggedIn = SharedPrefsHelper.getBool('isLoggedIn') ?? false;

    return isSignedUp && isLoggedIn;
  }

  static Future<bool> hasSignedUp() async {
    await SharedPrefsHelper.init();
    return SharedPrefsHelper.getBool('isSignedUp') ?? false;
  }

  static Future<bool> login(String email, String password) async {
    final storedEmail = await SecureStorageHelper.read('email');
    final storedPassword = await SecureStorageHelper.read('password');

    final match = email == storedEmail && password == storedPassword;
    if (match) {
      await SharedPrefsHelper.setBool('isLoggedIn', true);
    }
    return match;
  }

  static Future<void> logout() async {
    // Clear secure storage
    await SecureStorageHelper.delete('email');
    await SecureStorageHelper.delete('password');

    // Clear shared preferences
    await SharedPrefsHelper.setBool('isSignedUp', false);
    await SharedPrefsHelper.setBool('isLoggedIn', false);

    AppLogger.error('User logged out successfully');
  }
}
