import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/bloc/theme/theme_option.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';

class ThemeCubit extends Cubit<AppThemeOption> {
  static const _key = 'themeOption';

  ThemeCubit() : super(_loadInitial());

  static AppThemeOption _loadInitial() {
    final savedName = _loadSavedName();
    if (savedName != null) {
      for (final option in AppThemeOption.values) {
        if (option.name == savedName) return option;
      }
    }

    final index = SharedPrefsHelper.getInt(_key) ?? 0;
    return AppThemeOption.values[index.clamp(
      0,
      AppThemeOption.values.length - 1,
    )];
  }

  static String? _loadSavedName() {
    try {
      return SharedPrefsHelper.getString(_key);
    } catch (_) {
      return null;
    }
  }

  Future<void> setTheme(AppThemeOption option) async {
    await SharedPrefsHelper.setString(_key, option.name);
    emit(option);
  }

  bool get isDark => state.isDark;
}
