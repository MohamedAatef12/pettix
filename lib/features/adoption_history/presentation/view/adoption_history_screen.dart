import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/core/widgets/pet_refresh_indicator.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_event.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_state.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_card.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class AdoptionHistoryScreen extends StatefulWidget {
  const AdoptionHistoryScreen({super.key});

  @override
  State<AdoptionHistoryScreen> createState() => _AdoptionHistoryScreenState();
}

class _AdoptionHistoryScreenState extends State<AdoptionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _HistoryHeader(
            tabController: _tabController,
            currentIndex: _tabController.index,
          ),
          Expanded(child: _HistoryTabContent(tabController: _tabController)),
        ],
      ),
    );
  }
}

// ─── Gradient header + tab bar ────────────────────────────────────────────────

class _HistoryHeader extends StatelessWidget {
  final TabController tabController;
  final int currentIndex;

  const _HistoryHeader({
    required this.tabController,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppTopBar.back(
              title: AppText.adoptionHistory,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(AppRouteNames.bottomNav);
                }
              },
            ),
            // Custom Horizontal Tab bar
            Container(
              padding: EdgeInsets.only(bottom: 15.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    _TabButton(
                      title: AppText.myApplications,
                      icon: Icons.assignment_ind_rounded,
                      index: 0,
                      currentIndex: currentIndex,
                      onTap: () {
                        tabController.animateTo(0);
                        final bloc = context.read<AdoptionHistoryBloc>();
                        if (bloc.state.clientStatus ==
                            AdoptionHistoryStatus.initial) {
                          bloc.add(const FetchClientFormsEvent());
                        }
                      },
                    ),
                    SizedBox(width: 12.w),
                    _TabButton(
                      title: AppText.onMyPets,
                      icon: Icons.pets_rounded,
                      index: 1,
                      currentIndex: currentIndex,
                      onTap: () {
                        tabController.animateTo(1);
                        final bloc = context.read<AdoptionHistoryBloc>();
                        if (bloc.state.ownerStatus ==
                            AdoptionHistoryStatus.initial) {
                          bloc.add(const FetchOwnerFormsEvent());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.current.primary : AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.current.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.raw(
              icon,
              size: 18.sp,
              color:
                  isActive
                      ? AppColors.current.white
                      : AppColors.current.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTextStyles.bold.copyWith(
                fontSize: 14.sp,
                color:
                    isActive ? AppColors.current.white : AppColors.current.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab content ──────────────────────────────────────────────────────────────

class _HistoryTabContent extends StatelessWidget {
  final TabController tabController;
  const _HistoryTabContent({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [_FormsTab(isOwnerView: false), _FormsTab(isOwnerView: true)],
    );
  }
}

class _FormsTab extends StatefulWidget {
  final bool isOwnerView;
  const _FormsTab({required this.isOwnerView});

  @override
  State<_FormsTab> createState() => _FormsTabState();
}

class _FormsTabState extends State<_FormsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? _selectedStatusFilter;
  Completer<void>? _refreshCompleter;

  @override
  void dispose() {
    _refreshCompleter?.complete();
    super.dispose();
  }

  Future<void> _onRefresh() {
    _refreshCompleter = Completer<void>();
    context.read<AdoptionHistoryBloc>().add(
      widget.isOwnerView
          ? const FetchOwnerFormsEvent()
          : const FetchClientFormsEvent(),
    );
    return _refreshCompleter!.future;
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AdoptionHistoryBloc>();
    if (widget.isOwnerView) {
      if (bloc.state.ownerStatus == AdoptionHistoryStatus.initial) {
        bloc.add(const FetchOwnerFormsEvent());
      }
    } else {
      if (bloc.state.clientStatus == AdoptionHistoryStatus.initial) {
        bloc.add(const FetchClientFormsEvent());
      }
    }
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          _filterChip(
            label: AppText.all,
            value: null,
            icon: Icons.grid_view_rounded,
          ),
          SizedBox(width: 10.w),
          _filterChip(
            label: AppText.pending,
            value: 1,
            icon: Icons.hourglass_empty_rounded,
          ),
          SizedBox(width: 10.w),
          _filterChip(
            label: AppText.approved,
            value: 2,
            icon: Icons.check_circle_outline_rounded,
          ),
          SizedBox(width: 10.w),
          _filterChip(
            label: AppText.rejected,
            value: 3,
            icon: Icons.cancel_outlined,
          ),
          SizedBox(width: 10.w),
          _filterChip(
            label: AppText.cancelled,
            value: 4,
            icon: Icons.block_flipped,
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required int? value,
    required IconData icon,
  }) {
    final isSelected = _selectedStatusFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.current.primary : AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.current.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.raw(
              icon,
              size: 16.sp,
              color:
                  isSelected
                      ? AppColors.current.white
                      : AppColors.current.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.bold.copyWith(
                fontSize: 12.sp,
                color:
                    isSelected
                        ? AppColors.current.white
                        : AppColors.current.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PetRefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<AdoptionHistoryBloc, AdoptionHistoryState>(
              listenWhen:
                  (prev, curr) =>
                      widget.isOwnerView
                          ? prev.ownerStatus != curr.ownerStatus
                          : prev.clientStatus != curr.clientStatus,
              listener: (context, state) {
                final status =
                    widget.isOwnerView
                        ? state.ownerStatus
                        : state.clientStatus;
                if ((status == AdoptionHistoryStatus.loaded ||
                        status == AdoptionHistoryStatus.error) &&
                    _refreshCompleter != null &&
                    !_refreshCompleter!.isCompleted) {
                  _refreshCompleter!.complete();
                }
              },
              buildWhen:
                  (prev, curr) =>
                      widget.isOwnerView
                          ? prev.ownerStatus != curr.ownerStatus ||
                              prev.ownerForms != curr.ownerForms
                          : prev.clientStatus != curr.clientStatus ||
                              prev.clientForms != curr.clientForms,
              builder: (context, state) {
                final status =
                    widget.isOwnerView
                        ? state.ownerStatus
                        : state.clientStatus;
                final forms =
                    widget.isOwnerView ? state.ownerForms : state.clientForms;
                final error =
                    widget.isOwnerView ? state.ownerError : state.clientError;

                if (status == AdoptionHistoryStatus.loading) {
                  return _LoadingList();
                }

                if (status == AdoptionHistoryStatus.error) {
                  return LayoutBuilder(
                    builder:
                        (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: _ErrorView(
                              message: error,
                              onRetry:
                                  () =>
                                      context
                                          .read<AdoptionHistoryBloc>()
                                          .add(
                                            widget.isOwnerView
                                                ? const FetchOwnerFormsEvent()
                                                : const FetchClientFormsEvent(),
                                          ),
                            ),
                          ),
                        ),
                  );
                }

                List<AdoptionFormEntity> filteredForms = forms;
                if (_selectedStatusFilter != null) {
                  filteredForms =
                      forms
                          .where(
                            (element) =>
                                element.status == _selectedStatusFilter,
                          )
                          .toList();
                }

                if (filteredForms.isEmpty) {
                  return LayoutBuilder(
                    builder:
                        (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: _EmptyView(isOwnerView: widget.isOwnerView),
                          ),
                        ),
                  );
                }

                return _FormsList(
                  forms: filteredForms,
                  isOwnerView: widget.isOwnerView,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── List ─────────────────────────────────────────────────────────────────────

class _FormsList extends StatelessWidget {
  final List<AdoptionFormEntity> forms;
  final bool isOwnerView;

  const _FormsList({required this.forms, required this.isOwnerView});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: forms.length,
      itemBuilder: (_, i) {
        final form = forms[i];
        return AdoptionFormCard(
          form: form,
          isOwnerView: isOwnerView,
          onTap:
              () => context.push(
                AppRoutes.adoptionFormDetail,
                extra: {
                  'form': form,
                  'isOwnerView': isOwnerView,
                  'bloc': context.read<AdoptionHistoryBloc>(),
                },
              ),
        );
      },
    );
  }
}

// ─── States ───────────────────────────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      itemCount: 8,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder:
          (_, __) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.current.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.current.text.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                AppShimmer(
                  width: 64.w,
                  height: 64.w,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppShimmer(
                            width: 120.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          AppShimmer(
                            width: 55.w,
                            height: 18.h,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      AppShimmer(
                        width: 160.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          AppShimmer(
                            width: 65.w,
                            height: 18.h,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          SizedBox(width: 8.w),
                          AppShimmer(
                            width: 85.w,
                            height: 18.h,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                AppShimmer.circular(radius: 6.w),
              ],
            ),
          ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool isOwnerView;
  const _EmptyView({required this.isOwnerView});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.raw(
            Icons.pets_rounded,
            size: 64.w,
            color: AppColors.current.blueGray,
          ),
          SizedBox(height: 16.h),
          Text(
            isOwnerView
                ? AppText.noOwnerApplications
                : AppText.noClientApplications,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.raw(
            Icons.error_outline_rounded,
            size: 48.w,
            color: AppColors.current.red,
          ),
          SizedBox(height: 12.h),
          Text(
            message ?? AppText.error,
            style: TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppText.retry,
              style: TextStyle(
                color: AppColors.current.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
