import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/shimmers/home_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/features/home/presentation/widgets/post_card.dart';

import '../blocs/home_event.dart';
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          Widget content;

          if (state.isPostsLoading) {
            content = const Center(child: HomeShimmer());
          } else if (state.error != null) {
            content = Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state.posts.isEmpty) {
            content = Center(
              child: SvgPicture.asset(
                'assets/images/no_content_photo.svg',
                fit: BoxFit.cover,
              ),
            );
          } else {
            content = RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchPostsEvent());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // لازم للـ RefreshIndicator
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: PaddingConstants.verticalSmall,
                    child: PostCard(post: state.posts[index]),
                  );
                },
              ),
            );
          }

          return Stack(
            children: [
              content,
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
                        colorFilter: ColorFilter.mode(
                          AppColors.current.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

