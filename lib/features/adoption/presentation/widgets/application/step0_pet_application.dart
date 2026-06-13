import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class PetApplication extends StatelessWidget {
  final VoidCallback onStart;
  final bool isStarting;

  const PetApplication({
    super.key,
    required this.onStart,
    this.isStarting = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const _HeroSection(),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppText.readyToWelcomePet,
            style: AppTextStyles.title.copyWith(
              fontSize: 22.sp,
              color: AppColors.current.text,
            ),
          ),
        ),
        SizedBoxConstants.verticalSmall,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppText.adoptionIntro,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.current.lightText,
              height: 1.6,
            ),
          ),
        ),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppText.whatToExpect,
            style: AppTextStyles.bodyTitle.copyWith(
              fontSize: 16.sp,
              color: AppColors.current.text,
            ),
          ),
        ),
        SizedBoxConstants.verticalSmall,
        _ExpectationItem(
          icon: Icons.person_outline_rounded,
          text: AppText.fillPersonalInformation,
        ),
        _ExpectationItem(
          icon: Icons.home_outlined,
          text: AppText.describeLivingSituation,
        ),
        _ExpectationItem(
          icon: Icons.pets_outlined,
          text: AppText.sharePetExperience,
        ),
        _ExpectationItem(
          icon: Icons.fact_check_outlined,
          text: AppText.reviewAndSubmitApplication,
        ),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomFilledButton(
            text: AppText.startApplication,
            onPressed: onStart,
            isLoading: isStarting,
            heightFactor: 0.06,
            backgroundColor: AppColors.current.primary,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.current.white,
            ),
          ),
        ),
        SizedBoxConstants.verticalLarge,
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final theme = Theme.of(context);
    final colors = AppColors.current;
    final ovalColor = Color.alphaBlend(
      colors.primary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.12 : 0.07,
      ),
      theme.colorScheme.surface,
    );

    return SizedBox(
      height: topPadding + 300.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: _OvalBottomHeroBackground(
              height: topPadding + 300.h,
              backgroundColor: ovalColor,
              borderColor: colors.primary.withValues(alpha: 0.10),
            ),
          ),
          Positioned.fill(
            top: topPadding - 85.h,
            child: Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/images/adopt_animal.svg',
                width: 400.w,
                height: 420.h,
                fit: BoxFit.contain,
                colorMapper: _AdoptionHeroBackgroundMapper(ovalColor),
              ),
            ),
          ),
          PositionedDirectional(
            top: topPadding,
            start: 10.w,
            child: InkWell(
              onTap: () => context.pop(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: AppTopBarBackButton(onPressed: () => context.pop()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OvalBottomHeroBackground extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final Color borderColor;

  const _OvalBottomHeroBackground({
    required this.height,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        foregroundPainter: _OvalBottomHeroBorderPainter(borderColor),
        child: ClipPath(
          clipper: const _OvalBottomHeroClipper(),
          child: ColoredBox(
            color: backgroundColor,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _OvalBottomHeroClipper extends CustomClipper<Path> {
  const _OvalBottomHeroClipper();

  @override
  Path getClip(Size size) => _ovalBottomHeroPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _OvalBottomHeroBorderPainter extends CustomPainter {
  final Color color;

  const _OvalBottomHeroBorderPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawPath(_ovalBottomHeroPath(size), paint);
  }

  @override
  bool shouldRepaint(covariant _OvalBottomHeroBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

Path _ovalBottomHeroPath(Size size) {
  final arcTop = size.height - size.width / 2;

  return Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, arcTop)
    ..arcToPoint(
      Offset(0, arcTop),
      radius: Radius.elliptical(size.width / 2, size.width / 2),
      clockwise: true,
    )
    ..close();
}

class _AdoptionHeroBackgroundMapper extends ColorMapper {
  final Color backgroundColor;

  const _AdoptionHeroBackgroundMapper(this.backgroundColor);

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (attributeName == 'fill' && color.toARGB32() == 0xFFF7F3ED) {
      return Colors.transparent;
    }

    return color;
  }

  @override
  bool operator ==(Object other) {
    return other is _AdoptionHeroBackgroundMapper &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode;
}

class _ExpectationItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ExpectationItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.current.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AppIcon.raw(
              icon,
              size: 18.w,
              color: AppColors.current.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.current.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
