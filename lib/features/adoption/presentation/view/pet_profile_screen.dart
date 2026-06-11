import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/report_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_body.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class PetProfileScreen extends StatelessWidget {
  final PetEntity pet;

  const PetProfileScreen({super.key, required this.pet});

  void _showReportSheet(BuildContext context) {
    final bloc = context.read<AdoptionBrowseBloc>();
    bloc.add(const FetchPetReportReasonsEvent());

    showModalBottomSheet(
      backgroundColor: AppColors.current.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _ReportPetSheet(pet: pet, bloc: bloc),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdoptionBrowseBloc, AdoptionBrowseState>(
      listenWhen: (p, c) =>
          (!p.reportSuccess && c.reportSuccess) ||
          (p.isReportLoading && !c.isReportLoading && c.errorMessage != null),
      listener: (context, state) {
        if (state.reportSuccess) {
          PetToast.showSuccess(context, AppText.reportSentSuccessfully);
        } else if (state.errorMessage != null) {
          final msg = state.errorMessage!.toLowerCase();
          if (msg.contains('already') || msg.contains('reported before')) {
            PetToast.showInfo(
              context,
              state.errorMessage!,
              title: 'Already Reported',
            );
          } else {
            PetToast.showError(context, state.errorMessage!);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        appBar: AppTopBar.back(
          title: pet.name,
          backgroundColor: AppColors.current.white,
          onBack: () => context.pop(),
          trailing: IconButton(
            tooltip: AppText.reportPet,
            icon: AppIcon.raw(
              Icons.flag_outlined,
              color: AppColors.current.red,
            ),
            onPressed: () => _showReportSheet(context),
          ),
        ),
        body: PetBody(pet: pet),
      ),
    );
  }
}

class _ReportPetSheet extends StatelessWidget {
  final PetEntity pet;
  final AdoptionBrowseBloc bloc;

  const _ReportPetSheet({required this.pet, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen:
          (p, c) =>
              p.reportReasons != c.reportReasons ||
              p.isReportLoading != c.isReportLoading,
      builder: (context, state) {
        if (state.isReportLoading) {
          return SizedBox(height: 500.h, child: const ReportShimmer());
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 16.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Title and Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Text(
                      AppText.reportPet,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.current.text,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      AppText.reportPetDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.current.lightText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Reasons List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: state.reportReasons.length,
                  itemBuilder: (context, index) {
                    final reason = state.reportReasons[index];
                    final isOther = reason.name.toLowerCase().contains('other');

                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.current.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.current.lightGray.withValues(
                            alpha: 0.4,
                          ),
                          width: 1.r,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.015),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 2.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        leading: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.current.red.withValues(
                            alpha: 0.08,
                          ),
                          child: AppIcon.raw(
                            isOther
                                ? Icons.edit_note_rounded
                                : Icons.report_gmailerrorred_rounded,
                            color: AppColors.current.red.withValues(alpha: 0.8),
                            size: 20.r,
                          ),
                        ),
                        title: Text(
                          reason.name.tr(),
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.current.text,
                          ),
                        ),
                        trailing: AppIcon.raw(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.r,
                          color: AppColors.current.lightText.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        onTap: () {
                          if (isOther) {
                            Navigator.pop(context); // Close sheet
                            _showCustomReasonDialog(context, bloc, pet, reason);
                          } else {
                            bloc.add(
                              ReportPetEvent(
                                petId: pet.id,
                                reasonId: reason.id,
                                customReason: reason.name,
                              ),
                            );
                            Navigator.pop(context); // Close sheet
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomReasonDialog(
    BuildContext context,
    AdoptionBrowseBloc bloc,
    PetEntity pet,
    dynamic reason,
  ) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: AppColors.current.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppText.specifyReason,
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.current.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppText.specifyReasonPetDescription,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.current.lightText,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: textController,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.current.text,
                  ),
                  decoration: InputDecoration(
                    hintText: AppText.typeReasonHere,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.current.lightText.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    fillColor: AppColors.current.lightBlue.withValues(
                      alpha: 0.3,
                    ),
                    contentPadding: EdgeInsets.all(12.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.current.lightGray,
                        width: 1.r,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.current.lightGray.withValues(
                          alpha: 0.5,
                        ),
                        width: 1.r,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.current.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogCtx),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.current.lightGray),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          AppText.cancel,
                          style: TextStyle(
                            color: AppColors.current.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final custom = textController.text.trim();
                          if (custom.isNotEmpty) {
                            bloc.add(
                              ReportPetEvent(
                                petId: pet.id,
                                reasonId: reason.id,
                                customReason: custom,
                              ),
                            );
                            Navigator.pop(dialogCtx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.current.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          AppText.submit,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
