import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_event.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_state.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_card.dart';
import 'package:shimmer/shimmer.dart';

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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 15.h),
              child: SizedBox(
                height: 30.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.current.text,
                          size: 20.w,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80.w),
                        child: Text(
                          'Adoption History',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.current.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                      title: 'My Applications',
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
                      title: 'On My Pets',
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
                color: AppColors.current.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
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
          _filterChip(label: 'All', value: null, icon: Icons.grid_view_rounded),
          SizedBox(width: 10.w),
          _filterChip(
            label: 'Pending',
            value: 1,
            icon: Icons.hourglass_empty_rounded,
          ),
          SizedBox(width: 10.w),
          _filterChip(
            label: 'Approved',
            value: 2,
            icon: Icons.check_circle_outline_rounded,
          ),
          SizedBox(width: 10.w),
          _filterChip(label: 'Rejected', value: 3, icon: Icons.cancel_outlined),
          SizedBox(width: 10.w),
          _filterChip(label: 'Cancelled', value: 4, icon: Icons.block_flipped),
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
                color: AppColors.current.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
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
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: BlocBuilder<AdoptionHistoryBloc, AdoptionHistoryState>(
            buildWhen:
                (prev, curr) =>
                    widget.isOwnerView
                        ? prev.ownerStatus != curr.ownerStatus ||
                            prev.ownerForms != curr.ownerForms
                        : prev.clientStatus != curr.clientStatus ||
                            prev.clientForms != curr.clientForms,
            builder: (context, state) {
              final status =
                  widget.isOwnerView ? state.ownerStatus : state.clientStatus;
              final forms =
                  widget.isOwnerView ? state.ownerForms : state.clientForms;
              final error =
                  widget.isOwnerView ? state.ownerError : state.clientError;

              if (status == AdoptionHistoryStatus.loading) {
                return _LoadingList();
              }

              if (status == AdoptionHistoryStatus.error) {
                return _ErrorView(
                  message: error,
                  onRetry:
                      () => context.read<AdoptionHistoryBloc>().add(
                        widget.isOwnerView
                            ? const FetchOwnerFormsEvent()
                            : const FetchClientFormsEvent(),
                      ),
                );
              }

              List<AdoptionFormEntity> filteredForms = forms;
              if (_selectedStatusFilter != null) {
                filteredForms =
                    forms
                        .where(
                          (element) => element.status == _selectedStatusFilter,
                        )
                        .toList();
              }

              if (filteredForms.isEmpty) {
                return _EmptyView(isOwnerView: widget.isOwnerView);
              }

              return _FormsList(
                forms: filteredForms,
                isOwnerView: widget.isOwnerView,
              );
            },
          ),
        ),
      ],
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  // Avatar placeholder
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Pet Name Title
                            Container(
                              width: 120.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            // Status Badge
                            Container(
                              width: 55.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Subtitle / Email
                        Container(
                          width: 160.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Tags Row
                        Row(
                          children: [
                            Container(
                              width: 65.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 85.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Trailing Chevron Placeholder
                  SizedBox(width: 8.w),
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
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
          Icon(
            Icons.pets_rounded,
            size: 64.w,
            color: AppColors.current.blueGray,
          ),
          SizedBox(height: 16.h),
          Text(
            isOwnerView
                ? 'No one has applied to\nyour pets yet'
                : 'You haven\'t applied\nfor any pets yet',
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
          Icon(
            Icons.error_outline_rounded,
            size: 48.w,
            color: AppColors.current.red,
          ),
          SizedBox(height: 12.h),
          Text(
            message ?? 'Something went wrong',
            style: TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
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
