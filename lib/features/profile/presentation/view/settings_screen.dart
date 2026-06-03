import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/bloc/theme/theme_cubit.dart';
import 'package:pettix/core/bloc/theme/theme_option.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.current.text,
            size: 20.sp,
          ),
        ),
        title: Text(
          AppText.settings,
          style: AppTextStyles.title.copyWith(
            color: AppColors.current.text,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(AppText.accountSettings),
              SizedBox(height: 12.h),
              _SettingsGroup(
                tiles: [
                  _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF5EA8DF),
                    title: AppText.notificationSettings,
                    onTap: () {
                      // Navigate to notification settings
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildSectionHeader(AppText.appSettings),
              SizedBox(height: 12.h),
              _SettingsGroup(
                tiles: [
                  BlocBuilder<ThemeCubit, AppThemeOption>(
                    builder: (context, themeOption) {
                      return _SettingsTile(
                        icon: Icons.color_lens_outlined,
                        iconColor: themeOption.previewColor,
                        title: AppText.themes,
                        trailing: Text(
                          themeOption.label,
                          style: AppTextStyles.smallDescription.copyWith(
                            color: AppColors.current.midGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => _showThemePicker(context),
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF3AAFA9),
                    title: AppText.language,
                    trailing: Text(
                      _languageLabel(context, context.locale),
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.midGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => _showLanguagePicker(context),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.midGray,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ThemePickerSheet(),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LanguagePickerSheet(),
    );
  }
}

String _languageLabel(BuildContext context, Locale locale) {
  return switch (locale.languageCode) {
    'ar' => AppText.arabic,
    'en' => AppText.english,
    _ => locale.languageCode.toUpperCase(),
  };
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final options = context.supportedLocales;

    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                AppText.language,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.current.text,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final locale = options[index];
                    final isSelected =
                        locale.languageCode == currentLocale.languageCode;

                    return _LanguageOptionCard(
                      locale: locale,
                      isSelected: isSelected,
                      onTap: () async {
                        await context.setLocale(locale);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _languageAccent(locale);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color:
              isSelected ? accent.withAlpha(26) : AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accent : AppColors.current.lightGray,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: accent.withAlpha(35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: accent.withAlpha(26),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                locale.languageCode.toUpperCase(),
                style: AppTextStyles.description.copyWith(
                  color: accent,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _languageLabel(context, locale),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: isSelected ? 1 : 0,
              child: Icon(Icons.check_rounded, color: accent, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}

Color _languageAccent(Locale locale) {
  return switch (locale.languageCode) {
    'ar' => const Color(0xFF3AAFA9),
    'en' => const Color(0xFF5EA8DF),
    _ => AppColors.current.primary,
  };
}

class _ThemePickerSheet extends StatelessWidget {
  const _ThemePickerSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeOption>(
      builder: (context, current) {
        return FractionallySizedBox(
          heightFactor: 0.82,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: AppColors.current.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.current.lightGray,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    AppText.themes,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.current.text,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 6.h),
                      itemCount: AppThemeOption.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 2.15,
                      ),
                      itemBuilder: (context, index) {
                        final option = AppThemeOption.values[index];
                        return _ThemeOptionCard(
                          option: option,
                          isSelected: option == current,
                          onTap: () {
                            context.read<ThemeCubit>().setTheme(option);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final AppThemeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      option.previewColor.withAlpha(42),
                      option.previewAccent.withAlpha(30),
                    ],
                  )
                  : null,
          color: isSelected ? null : AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                isSelected ? option.previewColor : AppColors.current.lightGray,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: option.previewColor.withAlpha(35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [option.previewColor, option.previewAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: option.previewColor.withAlpha(45),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  isSelected
                      ? Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      )
                      : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.current.text,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    option.brightnessLabel,
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.lightText,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> tiles;
  const _SettingsGroup({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.text.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: tiles.length,
        separatorBuilder:
            (_, __) => Divider(
              height: 1,
              indent: 52.w,
              endIndent: 16.w,
              color: AppColors.current.lightGray,
            ),
        itemBuilder: (_, i) => tiles[i],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    required this.onTap,
    // ignore: unused_element_parameter
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null) ...[trailing!, SizedBox(width: 8.w)],
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.current.midGray.withAlpha(100),
                size: 14.sp,
              ),
          ],
        ),
      ),
    );
  }
}
