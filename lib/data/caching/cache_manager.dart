import 'dart:convert';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'i_cache_manager.dart';

class CacheManager implements ICacheManager {
  SharedPreferences? _prefs;

  CacheManager();

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setUserData(UserModel value) async {
    final jsonString = json.encode(value.toJson());
    await _prefs?.setString('user', jsonString);
    await _prefs?.setBool('logged_in', true); // ✅ mark user as logged in
  }

  @override
  bool logout() {
    _prefs?.remove('user');
    _prefs?.remove('token');
    _prefs?.remove('remember_me');
    _prefs?.setBool('logged_in', false);

    return true;
  }


  @override
  bool isCrossedOnBoardingPage() {
    return _prefs?.containsKey("OnBoardingPage") ?? false;
  }

  @override
  Future<void> setCrossOnBoardingPage() async {
    await _prefs?.setString('OnBoardingPage', "true");
  }

  @override
  UserModel? getUserData() {
    final jsonString = _prefs?.getString('user');
    if (jsonString != null) {
      final userJson = json.decode(jsonString);
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<void> saveLogin(bool rememberMe) async {
    await _prefs?.setBool('remember_me', rememberMe);
  }

  @override
  Future<bool> isRemembered() async {
    return _prefs?.getBool('remember_me') ?? false;
  }

  @override
  Future<void> clearLogin() async {
    await _prefs?.remove('remember_me');
  }

  @override
  getSavedLogin() async {
    final rememberMe = await _prefs?.getBool('remember_me');
    if (rememberMe != null) {
      return {'remember_me': rememberMe};
    }
    return null;
  }

  @override
  Future<void> setThemeDark(bool isDark) async {
    await _prefs?.setBool('is_dark_theme', isDark);
  }

  @override
  Future<bool> isThemeDark() async {
    return _prefs?.getBool('is_dark_theme') ?? false;
  }

  @override
  Future<bool> isLoggedIn() async {
    final loggedIn = _prefs?.getBool('logged_in') ?? false;
    final userJson = _prefs?.getString('user');
    return loggedIn && userJson != null;
  }

  @override
  Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs?.getString('token');
  }
  @override
  Future<void> setRefreshToken(String refreshToken) async {
     await _prefs?.setString('refresh_token', refreshToken);
  }
  @override
  Future<String?> getRefreshToken() async {
    return _prefs?.getString('refresh_token');
  }

}
