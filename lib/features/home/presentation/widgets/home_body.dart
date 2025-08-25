import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/presentation/widgets/home_appbar.dart';
import 'package:pettix/features/home/presentation/widgets/post_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        HomeAppBar(),
        SizedBox(height: 10.h),
        Expanded(
          child: Stack(
            children: [ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: PaddingConstants.verticalSmall,
                  child: PostCard(),
                );
              },
            ),
            Positioned(
                bottom: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () {
                    context.push('/add_post');
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.current.primary,
                      shape: BoxShape.circle,

                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/add_circle.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(AppColors.current.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
        )
      ],
    );
  }
}
