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
  setUserData(UserModel value) async {
    String jsonString = json.encode(value.toJson());
    await _prefs?.setString('user', jsonString);
  }

  @override
  bool? logout() {
    _prefs?.remove('user');
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
    String? jsonString = _prefs?.getString('user');

    if (jsonString != null) {
      final userJson = json.decode(jsonString);
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<void> saveLogin(bool rememberMe) async {
    if (rememberMe) {
      await _prefs?.setBool('remember_me', rememberMe);
    } else {
      await clearLogin();
    }
  }

  @override
  Future<bool> isRemembered() async {
    return _prefs?.getBool('remember_me') ?? false;
  }

  Future<String?> getRememberMe() async {
    return _prefs?.getString('remember_me');
  }

  @override
  Future<void> clearLogin() async {
    await _prefs?.remove('remember_me');
  }

  @override
  getSavedLogin() async {
    final rememberMe = await getRememberMe();
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
}
