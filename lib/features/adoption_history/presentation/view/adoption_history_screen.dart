import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_event.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_state.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_card.dart';

class AdoptionHistoryScreen extends StatelessWidget {
  const AdoptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body: Column(
          children: [
            _HistoryHeader(),
            Expanded(
              child: _HistoryTabContent(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gradient header + tab bar ────────────────────────────────────────────────

class _HistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 8.h, 20.w, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20.w),
                ),
                Expanded(
                  child: Text(
                    'Adoption History',
                    style: AppTextStyles.appbar.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.pets_rounded,
                    color: AppColors.current.gold, size: 22.w),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Tab bar
          TabBar(
            indicatorColor: AppColors.current.gold,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withAlpha(140),
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'My Applications'),
              Tab(text: 'On My Pets'),
            ],
            onTap: (index) {
              final bloc = context.read<AdoptionHistoryBloc>();
              if (index == 0 &&
                  bloc.state.clientStatus ==
                      AdoptionHistoryStatus.initial) {
                bloc.add(const FetchClientFormsEvent());
              } else if (index == 1 &&
                  bloc.state.ownerStatus ==
                      AdoptionHistoryStatus.initial) {
                bloc.add(const FetchOwnerFormsEvent());
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─── Tab content ──────────────────────────────────────────────────────────────

class _HistoryTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        _FormsTab(isOwnerView: false),
        _FormsTab(isOwnerView: true),
      ],
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AdoptionHistoryBloc, AdoptionHistoryState>(
      buildWhen: (prev, curr) => widget.isOwnerView
          ? prev.ownerStatus != curr.ownerStatus ||
              prev.ownerForms != curr.ownerForms
          : prev.clientStatus != curr.clientStatus ||
              prev.clientForms != curr.clientForms,
      builder: (context, state) {
        final status = widget.isOwnerView
            ? state.ownerStatus
            : state.clientStatus;
        final forms = widget.isOwnerView
            ? state.ownerForms
            : state.clientForms;
        final error = widget.isOwnerView
            ? state.ownerError
            : state.clientError;

        if (status == AdoptionHistoryStatus.loading) {
          return _LoadingList();
        }

        if (status == AdoptionHistoryStatus.error) {
          return _ErrorView(
            message: error,
            onRetry: () => context.read<AdoptionHistoryBloc>().add(
                  widget.isOwnerView
                      ? const FetchOwnerFormsEvent()
                      : const FetchClientFormsEvent(),
                ),
          );
        }

        if (forms.isEmpty) {
          return _EmptyView(isOwnerView: widget.isOwnerView);
        }

        return _FormsList(
          forms: forms,
          isOwnerView: widget.isOwnerView,
        );
      },
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
          onTap: () => context.push(
            AppRoutes.adoptionFormDetail,
            extra: {'form': form, 'isOwnerView': isOwnerView},
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
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
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
          Icon(Icons.pets_rounded,
              size: 64.w, color: AppColors.current.blueGray),
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
          Icon(Icons.error_outline_rounded,
              size: 48.w, color: AppColors.current.red),
          SizedBox(height: 12.h),
          Text(
            message ?? 'Something went wrong',
            style: TextStyle(
                color: AppColors.current.midGray, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(
                  color: AppColors.current.primary,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
