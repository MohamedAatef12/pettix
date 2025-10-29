import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
                        : ()=> {
                      bloc.add(SubmitPostEvent()),
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
                    NetworkImage(userData!.avatar.toString()),
                  ),
                  SizedBox(width: 10.w),
                  Text(userData.userName, style: AppTextStyles.bold),
                ],
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                controller: bloc.postTextController,
                hintText: 'Write a caption...',
                maxLines: 5,

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              if (state.selectedImages.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: state.selectedImages.length,
                  itemBuilder: (context, index) {
                    final file = state.selectedImages[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => bloc.add(RemoveSelectedImageEvent(index)),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => bloc.add(PickImagesFromGalleryEvent()),
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
                    onTap: ()async{
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        bloc.add(AddImageFromCameraEvent(File(pickedFile.path)));
                      }
                    },
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
