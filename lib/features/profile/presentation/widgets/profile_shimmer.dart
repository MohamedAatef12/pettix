import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.current.lightBlue,
      child: Column(
        children: [
          const _ProfileHeaderShimmer(),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabelShimmer(width: 92),
                  const _ProfileTileShimmer(),
                  const _ProfileTileShimmer(),
                  const _ProfileTileShimmer(),
                  SizedBox(height: 8.h),
                  const _SectionLabelShimmer(width: 58),
                  const _ProfileTileShimmer(),
                  const _ProfileTileShimmer(),
                  const _ProfileTileShimmer(),
                  SizedBox(height: 10.h),
                  const _SectionLabelShimmer(width: 62),
                  SizedBox(height: 8.h),
                  AppShimmer(
                    width: double.infinity,
                    height: 94.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderShimmer extends StatelessWidget {
  const _ProfileHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final user = DI.find<ICacheManager>().getUserData();
    final heroTag = user?.id == null ? null : 'user_avatar_${user!.id}';
    return Container(
      height: topInset + 232.h,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, topInset + 4.h, 14.w, 0),
      decoration: BoxDecoration(
        color: AppColors.current.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          _ShimmerAvatar(heroTag: heroTag),
          SizedBox(height: 14.h),
          AppShimmer(
            width: 142.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(10.r),
          ),
          SizedBox(height: 6.h),
          AppShimmer(
            width: 176.w,
            height: 11.h,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ],
      ),
    );
  }
}

class _ShimmerAvatar extends StatelessWidget {
  final String? heroTag;

  const _ShimmerAvatar({required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 104.w,
      height: 104.w,
      padding: EdgeInsets.all(4.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: AppShimmer.circular(radius: 48.r),
    );

    if (heroTag == null) return avatar;
    return Hero(
      tag: heroTag!,
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      flightShuttleBuilder: (
        _,
        __,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        final hero =
            (flightDirection == HeroFlightDirection.push
                    ? toHeroContext.widget
                    : fromHeroContext.widget)
                as Hero;

        return Material(
          color: Colors.transparent,
          child: ClipOval(child: hero.child),
        );
      },
      child: avatar,
    );
  }
}

class _SectionLabelShimmer extends StatelessWidget {
  final double width;

  const _SectionLabelShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppShimmer(
        width: width.w,
        height: 12.h,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}

class _ProfileTileShimmer extends StatelessWidget {
  const _ProfileTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 96.h),
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AppShimmer(
            width: 40.w,
            height: 40.w,
            borderRadius: BorderRadius.circular(8.r),
          ),
          SizedBox(width: 18.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimmer(
                width: 58.w,
                height: 10.h,
                borderRadius: BorderRadius.circular(5.r),
              ),
              SizedBox(height: 8.h),
              AppShimmer(
                width: 150.w,
                height: 15.h,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
