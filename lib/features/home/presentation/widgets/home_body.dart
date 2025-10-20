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

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
   return Expanded(
     child: BlocBuilder<HomeBloc,HomeState>(
          builder: (context,state) {
            if (state.isPostsLoading) {
              return Center(child: HomeShimmer());
            }
            if (state.error != null) {
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state.posts.isEmpty) {
              return Center(
                child: SvgPicture.asset(
                  'assets/images/no_content_photo.svg',
                  fit: BoxFit.cover,
                ),
              );
            }

            return Stack(
              children: [ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: PaddingConstants.verticalSmall,
                    child: PostCard(
                      post: state.posts[index],
                    ),
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
                );
        }
      ),
   );
  }
}
