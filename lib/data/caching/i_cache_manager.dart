import 'package:injectable/injectable.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';


abstract class ICacheManager {
  Future<void> init();
  Future<void> setUserData(UserModel data);
  bool? logout();
  Future<void> setCrossOnBoardingPage();
  bool isCrossedOnBoardingPage();
  UserModel? getUserData();
  saveLogin(bool rememberMe);
  isRemembered();
  getSavedLogin();
  clearLogin();
  Future<void> setThemeDark(bool isDark);
  Future<bool> isThemeDark();
}
