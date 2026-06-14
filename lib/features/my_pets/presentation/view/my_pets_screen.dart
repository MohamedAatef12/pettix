import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/core/widgets/app_dropdown.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/core/widgets/pet_dialog.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_gender_selector.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_passport.dart';
import 'package:pettix/features/my_pets/presentation/widgets/vaccination_builder.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _MyPetsHeader(),
          Expanded(
            child: BlocConsumer<MyPetsBloc, MyPetsState>(
              listener: (context, state) {
                if (state.status == MyPetsStatus.success) {
                  PetToast.showSuccess(context, AppText.doneBang);
                }
                if (state.status == MyPetsStatus.error) {
                  PetToast.showError(
                    context,
                    state.errorMessage ?? AppText.anErrorOccurred,
                  );
                }
              },
              builder: (context, state) {
                if (state.status == MyPetsStatus.loading &&
                    state.pets.isEmpty) {
                  return const _LoadingList();
                }
                if (state.pets.isEmpty) return const _EmptyView();
                return _PetList(pets: state.pets, state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAB ───────────────────────────────────────────────────────────────────────

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isLoading;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 40.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              color: AppColors.current.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child:
                isLoading
                    ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.current.primary,
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon.raw(
                          icon,
                          color: AppColors.current.primary,
                          size: 14.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          label,
                          style: TextStyle(
                            color: AppColors.current.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _MyPetsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            children: [
              AppTopBar.back(
                title: AppText.myPets,
                trailing: _HeaderActionButton(
                  icon: Icons.add_rounded,
                  label: AppText.new_,
                  tooltip: AppText.addNewPet,
                  onTap:
                      () => context.push(
                        AppRoutes.addPet,
                        extra: context.read<MyPetsBloc>(),
                      ),
                ),
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(AppRouteNames.bottomNav);
                  }
                },
              ),
              BlocBuilder<MyPetsBloc, MyPetsState>(
                buildWhen: (prev, curr) => prev.pets.length != curr.pets.length,
                builder: (context, state) {
                  if (state.pets.isEmpty) return const SizedBox.shrink();
                  final count = state.pets.length;
                  return Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      '$count ${count == 1 ? 'pet' : 'pets'} registered',
                      style: TextStyle(
                        color: AppColors.current.midGray,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pet list ──────────────────────────────────────────────────────────────────

class _PetList extends StatelessWidget {
  final List<PetEntity> pets;
  final MyPetsState state;

  const _PetList({required this.pets, required this.state});

  Future<void> _showDeleteDialog(BuildContext context, PetEntity pet) async {
    final confirmed = await PetDialog.show(
      context,
      title: AppText.deletePetQuestion,
      message: AppText.deletePetConfirmation(pet.name),
      confirmLabel: AppText.delete,
      confirmColor: AppColors.current.red,
      iconColor: AppColors.current.red,
      icon: Icons.delete_rounded,
    );
    if (confirmed == true && context.mounted) {
      HapticFeedback.mediumImpact();
      context.read<MyPetsBloc>().add(DeletePetEvent(pet.id));
    }
  }

  void _showEditSheet(BuildContext context, PetEntity pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => BlocProvider.value(
            value: context.read<MyPetsBloc>(),
            child: _EditPetSheet(
              pet: pet,
              categories: state.categories,
              colors: state.colors,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 280 + (index * 55).clamp(0, 220)),
          curve: Curves.easeOutCubic,
          builder:
              (_, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
                  child: child,
                ),
              ),
          child: _PetManageCard(
            pet: pet,
            isStatusUpdating: state.statusUpdatingPetIds.contains(pet.id),
            onEdit: () => _showEditSheet(context, pet),
            onDelete: () => _showDeleteDialog(context, pet),
            onToggleStatus: (v) {
              context.read<MyPetsBloc>().add(
                UpdatePetStatusEvent(petId: pet.id, status: v),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Pet manage card ───────────────────────────────────────────────────────────

class _PetManageCard extends StatelessWidget {
  final PetEntity pet;
  final bool isStatusUpdating;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<int> onToggleStatus;

  const _PetManageCard({
    required this.pet,
    required this.isStatusUpdating,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tappable body (PetIdCard style) ─────────────────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => showPetPassport(
                context,
                pet,
                onToggleStatus: onToggleStatus,
                onEditPet: onEdit,
                onDeletePet: onDelete,
              ),
              child: SizedBox(
                height: 118.h,
                child: Stack(
                  children: [
                    _CardAccentBar(),
                    PositionedDirectional(
                      end: -16.w,
                      bottom: -16.w,
                      child: AppIcon.raw(
                        Icons.pets_rounded,
                        size: 80.w,
                        color: AppColors.current.primary.withValues(alpha: 0.05),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.w,
                        10.h,
                        14.w,
                        10.h,
                      ),
                      child: Row(
                        children: [
                          _CardPhoto(imageUrl: pet.imageUrls.firstOrNull),
                          SizedBox(width: 12.w),
                          Expanded(child: _ManageCardInfo(pet: pet)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Actions footer ────────────────────────────────────────────────
          Container(
            color: AppColors.current.lightBlue.withValues(alpha: 0.55),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                _StatusTogglePill(
                  isAvailable: pet.adoptionStatus == 1,
                  isLoading: isStatusUpdating,
                  onToggle: onToggleStatus,
                ),
                const Spacer(),
                _FooterIconBtn(
                  icon: Icons.edit_rounded,
                  color: AppColors.current.primary,
                  onTap: onEdit,
                ),
                SizedBox(width: 8.w),
                _FooterIconBtn(
                  icon: Icons.delete_rounded,
                  color: AppColors.current.red,
                  onTap: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAccentBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 6.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.current.primary, AppColors.current.teal],
          ),
        ),
      ),
    );
  }
}

class _CardPhoto extends StatelessWidget {
  final String? imageUrl;

  const _CardPhoto({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.current.lightGray.withValues(alpha: 0.8),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.r),
        child: AppCachedImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          errorWidget: Center(
            child: AppIcon.raw(
              Icons.pets_rounded,
              color: AppColors.current.primary.withValues(alpha: 0.35),
              size: 28.w,
            ),
          ),
          backgroundColor: AppColors.current.lightBlue,
        ),
      ),
    );
  }
}

class _ManageCardInfo extends StatelessWidget {
  final PetEntity pet;

  const _ManageCardInfo({required this.pet});

  @override
  Widget build(BuildContext context) {
    final hasVax = pet.vaccinations.isNotEmpty;
    final details = [
      if (pet.categoryName?.isNotEmpty ?? false) pet.categoryName!,
      if (pet.genderName?.isNotEmpty ?? false) pet.genderName!,
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppText.pettixPetId,
          style: TextStyle(
            color: AppColors.current.primary,
            fontSize: 8.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Text(
          pet.name.toUpperCase(),
          style: TextStyle(
            color: AppColors.current.text,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        _ManageCodeStrip(code: pet.code),
        SizedBox(height: 5.h),
        if (details.isNotEmpty)
          Text(
            details,
            style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 9.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        SizedBox(height: 6.h),
        Row(
          children: [
            if (pet.age != null)
              _ManageMiniBadge(
                icon: Icons.cake_rounded,
                label: '${pet.age} ${AppText.yearsShort}',
              ),
            if (pet.age != null && hasVax) SizedBox(width: 5.w),
            if (hasVax)
              _ManageMiniBadge(
                icon: Icons.verified_rounded,
                label: '${pet.vaccinations.length}',
                color: AppColors.current.teal,
              ),
          ],
        ),
      ],
    );
  }
}

class _ManageCodeStrip extends StatelessWidget {
  final String code;

  const _ManageCodeStrip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: AppColors.current.text,
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ManageMiniBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _ManageMiniBadge({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.current.primary;
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.raw(icon, color: badgeColor, size: 11.w),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              color: badgeColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTogglePill extends StatelessWidget {
  final bool isAvailable;
  final bool isLoading;
  final ValueChanged<int> onToggle;

  const _StatusTogglePill({
    required this.isAvailable,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isAvailable ? AppColors.current.teal : AppColors.current.midGray;
    final icon =
        isAvailable ? Icons.visibility_rounded : Icons.visibility_off_rounded;
    final label = isAvailable ? AppText.available : AppText.private;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap:
            isLoading
                ? null
                : () {
                  HapticFeedback.lightImpact();
                  onToggle(isAvailable ? 0 : 1);
                },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: color,
                  ),
                )
              else
                AppIcon.raw(icon, color: color, size: 12.w),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FooterIconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: AppIcon.raw(icon, color: color, size: 17.w),
        ),
      ),
    );
  }
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.current.lightGray,
                      AppColors.current.lightGray.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 14.h, 14.w, 14.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer(
                        width: 84.w,
                        height: 84.w,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppShimmer(
                              width: 130.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            SizedBox(height: 8.h),
                            AppShimmer(
                              width: 80.w,
                              height: 10.h,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                AppShimmer(
                                  width: 58.w,
                                  height: 20.h,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                SizedBox(width: 6.w),
                                AppShimmer(
                                  width: 46.w,
                                  height: 20.h,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    color: AppColors.current.primary.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.current.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: AppIcon.raw(
                    Icons.pets_rounded,
                    size: 38.w,
                    color: AppColors.current.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 22.h),
            Text(
              AppText.noPetsRegisteredYet,
              style: AppTextStyles.bold.copyWith(
                color: AppColors.current.text,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              AppText.myPetsEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon.raw(
                  Icons.arrow_downward_rounded,
                  size: 13.w,
                  color: AppColors.current.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Tap + to add your first pet',
                  style: TextStyle(
                    color: AppColors.current.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Edit bottom sheet ─────────────────────────────────────────────────────────

class _EditPetSheet extends StatefulWidget {
  final PetEntity pet;
  final List<LookupEntity> categories;
  final List<LookupEntity> colors;

  const _EditPetSheet({
    required this.pet,
    required this.categories,
    required this.colors,
  });

  @override
  State<_EditPetSheet> createState() => _EditPetSheetState();
}

class _EditPetSheetState extends State<_EditPetSheet> {
  late final TextEditingController _name;
  late final TextEditingController _desc;
  late final TextEditingController _details;
  late final TextEditingController _age;
  int? _catId, _colorId, _genderId;
  late List<VaccinationEntity> _vaccinations;

  LookupEntity? _findById(List<LookupEntity> list, String? name) {
    if (name == null) return null;
    try {
      return list.firstWhere((e) => e.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.pet.name);
    _desc = TextEditingController(text: widget.pet.description);
    _details = TextEditingController(text: widget.pet.details);
    _age = TextEditingController(text: widget.pet.age?.toString() ?? '');
    _catId = _findById(widget.categories, widget.pet.categoryName)?.id;
    _colorId = _findById(widget.colors, widget.pet.colorName)?.id;
    _vaccinations = List.from(widget.pet.vaccinations);
    final g = widget.pet.genderName?.toLowerCase();
    _genderId =
        g == 'male'
            ? Gender.male.value
            : (g == 'female' ? Gender.female.value : null);
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _details.dispose();
    _age.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    HapticFeedback.lightImpact();
    context.read<MyPetsBloc>().add(
      UpdatePetEvent(
        widget.pet.id,
        PetRequestEntity(
          id: widget.pet.id,
          name: name,
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          details: _details.text.trim().isEmpty ? null : _details.text.trim(),
          age: int.tryParse(_age.text.trim()),
          categoryId: _catId,
          genderId: _genderId,
          colorId: _colorId,
          vaccinations: _vaccinations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status &&
              current.status == MyPetsStatus.success,
      listener: (context, _) => Navigator.of(context).pop(),
      builder: (context, state) {
        final isSubmitting = state.status == MyPetsStatus.submitting;

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.current.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(
              20.w,
              16.h,
              20.w,
              MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.current.lightGray,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    AppTopBarBackButton(
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        AppText.editPetInfo,
                        style: AppTextStyles.bold.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.current.text,
                        ),
                      ),
                    ),
                    _HeaderActionButton(
                      icon: Icons.check_rounded,
                      label: AppText.save,
                      tooltip: AppText.save,
                      onTap: isSubmitting ? null : _submit,
                      isLoading: isSubmitting,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _field(
                  _name,
                  AppText.petName,
                  Icons.pets_rounded,
                  AppColors.current.primary,
                ),
                SizedBox(height: 12.h),
                _field(
                  _desc,
                  AppText.description,
                  Icons.notes_rounded,
                  const Color(0xFF7A6FD8),
                  maxLines: 3,
                ),
                SizedBox(height: 12.h),
                _field(
                  _details,
                  AppText.healthDetails,
                  Icons.health_and_safety_outlined,
                  AppColors.current.teal,
                  maxLines: 2,
                ),
                SizedBox(height: 12.h),
                _field(
                  _age,
                  AppText.ageYears,
                  Icons.cake_outlined,
                  const Color(0xFFE8A838),
                  type: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                AppDropdown<int>(
                  hint: AppText.category,
                  prefixIcon: Icons.category_outlined,
                  prefixIconColor: const Color(0xFF5EA8DF),
                  value: _catId,
                  items:
                      widget.categories
                          .map(
                            (category) => AppDropdownItem<int>(
                              value: category.id,
                              label: category.name,
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _catId = v),
                ),
                SizedBox(height: 12.h),
                PetGenderSelector(
                  selected: _genderId,
                  onSelected: (v) => setState(() => _genderId = v),
                ),
                SizedBox(height: 12.h),
                AppDropdown<int>(
                  hint: AppText.color,
                  prefixIcon: Icons.palette_outlined,
                  prefixIconColor: AppColors.current.brown,
                  value: _colorId,
                  items:
                      widget.colors
                          .map(
                            (color) => AppDropdownItem<int>(
                              value: color.id,
                              label: color.name,
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _colorId = v),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: AppColors.current.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: AppIcon.raw(
                        Icons.vaccines_rounded,
                        color: AppColors.current.teal,
                        size: 14.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppText.medicalRecords,
                      style: TextStyle(
                        color: AppColors.current.text,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ..._vaccinations.asMap().entries.map(
                  (e) => VaccinationChip(
                    vaccination: e.value,
                    onRemove:
                        () => setState(() => _vaccinations.removeAt(e.key)),
                  ),
                ),
                if (_vaccinations.isNotEmpty) SizedBox(height: 4.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showVaccinationSheet(
                      context,
                      medicals: state.medicals,
                      onAdd:
                          (list) =>
                              setState(() => _vaccinations.addAll(list)),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Ink(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      decoration: BoxDecoration(
                        color: AppColors.current.primary.withValues(
                          alpha: 0.05,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.current.primary.withValues(
                            alpha: 0.25,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              color: AppColors.current.primary.withValues(
                                alpha: 0.12,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: AppIcon.raw(
                              Icons.add_rounded,
                              color: AppColors.current.primary,
                              size: 14.w,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppText.addVaccination,
                            style: TextStyle(
                              color: AppColors.current.primary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon,
    Color iconColor, {
    int maxLines = 1,
    TextInputType? type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        style: TextStyle(
          color: AppColors.current.text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.current.midGray,
            fontSize: 13.sp,
          ),
          prefixIcon: AppIcon.raw(icon, color: iconColor, size: 20.w),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
