import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';

abstract class ICacheManager {
  Future<void> init();
  Future<void> setUserData(UserModel data);
  bool? logout();

  Future<void> setCrossOnBoardingPage();
  bool isCrossedOnBoardingPage();

  UserModel? getUserData();
  Future<void> setToken(String token);

  Future<String?> getToken();
  Future<void> saveLogin(bool rememberMe);
  Future<void> setRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<bool> isRemembered();
  Future<Map<String, dynamic>?> getSavedLogin();
  Future<void> clearLogin();

  Future<void> setThemeDark(bool isDark);
  Future<bool> isThemeDark();
  Future<bool> isLoggedIn();
}
