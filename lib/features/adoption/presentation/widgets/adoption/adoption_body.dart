import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/category_filter.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/pet_grid.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/results_count.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/search_filter_bar.dart';

class AdoptionBody extends StatelessWidget {
  const AdoptionBody({super.key});

  void _onScrollNotification(
    BuildContext context,
    ScrollNotification notification,
  ) {
    if (notification is! ScrollUpdateNotification) return;
    final metrics = notification.metrics;
    if (metrics.pixels < metrics.maxScrollExtent - 300) return;
    final bloc = context.read<AdoptionBrowseBloc>();
    if (bloc.state.hasMore &&
        bloc.state.status == AdoptionBrowseStatus.loaded) {
      bloc.add(const LoadMorePetsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBrowseBloc>();
    return Column(
      children: [
        AdoptionHeader(searchController: bloc.searchController),
        Expanded(
          child: RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              bloc.add(const RefreshPetsEvent());
              await bloc.stream.firstWhere(
                (s) =>
                    s.status == AdoptionBrowseStatus.loaded ||
                    s.status == AdoptionBrowseStatus.error,
              );
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                _onScrollNotification(context, n);
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: const [
                  CategoryFilterSliver(),
                  ResultsCountSliver(),
                  PetGridSliver(),
                  LoadMoreSliver(),
                  SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
