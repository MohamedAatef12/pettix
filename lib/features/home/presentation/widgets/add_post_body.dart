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
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

class AddPostBody extends StatelessWidget {
  const AddPostBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final userData = DI.find<ICacheManager>().getUserData();

    return BlocListener<HomeBloc, HomeState>(
      listenWhen:
          (previous, current) => previous.isPostAdded != current.isPostAdded,
      listener: (context, state) {
        if (state.isPostAdded) {
          context.pop();
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container(
            child: Column(
              children: [
                // ─── Custom Header ──────────────────────────────────────────
                _Header(
                  isLoading: state.isAddPostLoading,
                  onCancel: () => context.pop(),
                  onPost: () => bloc.add(SubmitPostEvent()),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        // ─── User Profile Info ──────────────────────────────
                        _UserHeader(userData: userData),

                        SizedBox(height: 24.h),

                        // ─── Content Input ──────────────────────────────────
                        TextField(
                          controller: bloc.postTextController,
                          maxLines: null,
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.current.text,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: TextStyle(
                              color: AppColors.current.midGray,
                              fontSize: 18.sp,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ─── Media Preview ──────────────────────────────────
                        if (state.selectedImages.isNotEmpty)
                          _ImagePreviewGrid(
                            images: state.selectedImages,
                            onRemove:
                                (i) => bloc.add(RemoveSelectedImageEvent(i)),
                          ),

                        SizedBox(height: 100.h), // Space for bottom toolbar
                      ],
                    ),
                  ),
                ),

                // ─── Bottom Toolbar ─────────────────────────────────────────
                _MediaToolbar(
                  onPickGallery: () => bloc.add(PickImagesFromGalleryEvent()),
                  onPickCamera: () async {
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      bloc.add(AddImageFromCameraEvent(File(pickedFile.path)));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Header Component ────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onPost;

  const _Header({
    required this.isLoading,
    required this.onCancel,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 16.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isLoading ? null : onPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.current.primary,
              foregroundColor: AppColors.current.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

// ─── User Info Component ─────────────────────────────────────────────────────

class _UserHeader extends StatelessWidget {
  final userData; // Using dynamic for brevity as per existing code context

  const _UserHeader({this.userData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.current.primary, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.current.lightGray,
            backgroundImage:
                userData?.avatar != null
                    ? NetworkImage("${Constants.baseUrl}/${userData!.avatar}")
                    : const AssetImage('assets/images/no_user.png')
                        as ImageProvider,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData?.userName ?? 'User',
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.current.lightGray,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 12.sp,
                    color: AppColors.current.midGray,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Public',
                    style: TextStyle(
                      color: AppColors.current.midGray,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Image Grid Component ────────────────────────────────────────────────────

class _ImagePreviewGrid extends StatelessWidget {
  final List<File> images;
  final Function(int) onRemove;

  const _ImagePreviewGrid({required this.images, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 1 ? 1 : 2,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(images[index], fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16.w,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Media Toolbar ───────────────────────────────────────────────────────────

class _MediaToolbar extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  const _MediaToolbar({
    required this.onPickGallery,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomPad),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.current.lightGray, width: 1),
        ),
      ),
      child: Row(
        children: [
          _ToolbarIcon(
            iconPath: 'assets/icons/add_photo.svg',
            color: const Color(0xFF34A853),
            label: 'Photo',
            onTap: onPickGallery,
          ),
          SizedBox(width: 16.w),
          _ToolbarIcon(
            iconPath: 'assets/icons/camera.svg',
            color: AppColors.current.primary,
            label: 'Camera',
            onTap: onPickCamera,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final String iconPath;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ToolbarIcon({
    required this.iconPath,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
