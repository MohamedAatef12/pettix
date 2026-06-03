import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/bloc/theme/theme_option.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';

class ThemeCubit extends Cubit<AppThemeOption> {
  static const _key = 'themeOption';

  ThemeCubit() : super(_loadInitial());

  static AppThemeOption _loadInitial() {
    final index = SharedPrefsHelper.getInt(_key) ?? 0;
    return AppThemeOption.values[index.clamp(0, AppThemeOption.values.length - 1)];
  }

  Future<void> setTheme(AppThemeOption option) async {
    await SharedPrefsHelper.setInt(_key, option.index);
    emit(option);
  }

  bool get isDark => state.isDark;
}
