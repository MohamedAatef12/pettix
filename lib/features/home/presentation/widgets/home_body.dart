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
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.9) {
        context.read<HomeBloc>().add(LoadMorePostsEvent());
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          Widget content;

          if (state.isPostsLoading) {
            content = const Center(child: HomeShimmer());
          } else if (state.error != null && state.posts.isEmpty) {
            content = Center(
              child: CircleAvatar(
                backgroundColor: AppColors.current.lightGray,
                radius: 100.r,
                child: Icon(
                  Icons.cloud_off_outlined,
                  color: AppColors.current.primary,
                  size: 50.w,
                ),
              ),
            );
          } else {
            content = RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchPostsEvent());
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScrollNotification,
                child: ListView.builder(
                  key: const PageStorageKey('posts_list'),
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.isMorePostsLoading
                      ? state.posts.length + 1
                      : state.posts.length,
                  itemBuilder: (context, index) {
                    if (index >= state.posts.length) {
                      return HomeShimmer();
                    }
                    return Padding(
                      padding: PaddingConstants.verticalSmall,
                      child: PostCard(post: state.posts[index]),
                    );
                  },
                ),
              ),
            );
          }
          return content;

        },
      ),
    );
  }
}

