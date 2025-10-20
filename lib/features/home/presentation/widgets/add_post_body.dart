import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

class AddPostBody extends StatelessWidget {
  const AddPostBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final userData = DI.find<ICacheManager>().getUserData();
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: PaddingConstants.medium,
          child: Column(
            children: [
              // 🔹 Header Row (Close + Share)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushReplacement('/bottom_nav');
                    },
                    child: Image.asset(
                      'assets/icons/close.png',
                      width: 35.w,
                      height: 35.h,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: state.isAddPostLoading
                        ? null
                        : ()=> {bloc.add(SubmitPostEvent()),
                      state.isPostAdded?
                    context.pushReplacement('/bottom_nav'):null
                    },

                    child: Container(
                      width: 80.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.current.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: state.isAddPostLoading
                            ? SizedBox(
                          height: 18.h,
                          width: 18.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          'Share',
                          style: TextStyle(
                            color: AppColors.current.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // 🔹 User Info Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage:
                    NetworkImage(userData!.image),
                  ),
                  SizedBox(width: 10.w),
                  Text(userData.userName, style: AppTextStyles.bold),
                ],
              ),

              SizedBox(height: 20.h),

              // 🔹 Caption Input
              CustomTextFormField(
                controller: bloc.postTextController,
                hintText: 'Write a caption...',
                maxLines: 5,
                contentPadding: EdgeInsets.all(12.w),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),

              // 🔹 Image Preview (if selected)
              if (state.selectedImage != null) ...[
                SizedBox(height: 12.h),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(state.selectedImage!.path),
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () =>
                            bloc.add(RemoveSelectedImageEvent()), // 🧠 BLoC
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          padding: const EdgeInsets.all(4),
                          child:
                          const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const Spacer(),

              // 🔹 Bottom Row (Gallery + Camera)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => bloc.add(PickImageFromGalleryEvent()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.current.lightGray,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/add_photo.svg'),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.h),
                  GestureDetector(
                    onTap: () => bloc.add(PickImageFromCameraEvent()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.current.lightGray,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/camera.svg'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
