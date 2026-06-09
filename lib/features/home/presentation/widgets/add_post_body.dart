import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';

class AddPostBody extends StatefulWidget {
  final PostEntity? editingPost;

  const AddPostBody({super.key, this.editingPost});

  @override
  State<AddPostBody> createState() => _AddPostBodyState();
}

class _AddPostBodyState extends State<AddPostBody> {
  late List<String> _existingImages;
  late HomeBloc _bloc;
  final List<String> _deletedImages = [];

  bool get _isEditing => widget.editingPost != null;

  @override
  void initState() {
    super.initState();
    _existingImages = List<String>.from(widget.editingPost?.images ?? []);
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<HomeBloc>().add(ClearSelectedImagesEvent());
        context.read<HomeBloc>().postTextController.text =
            widget.editingPost!.content;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<HomeBloc>();
  }

  @override
  void dispose() {
    if (_isEditing) {
      _bloc.postTextController.clear();
      _bloc.add(ClearSelectedImagesEvent());
    }
    super.dispose();
  }

  void _submit(BuildContext context, HomeBloc bloc) {
    if (!_isEditing) {
      bloc.add(SubmitPostEvent());
      return;
    }

    final content = bloc.postTextController.text.trim();
    final original = widget.editingPost!;
    final newImagePaths =
        bloc.state.selectedImages.map((file) => file.path).toList();
    final hasImageChanges =
        _deletedImages.isNotEmpty || newImagePaths.isNotEmpty;

    if ((content.isEmpty && _existingImages.isEmpty && newImagePaths.isEmpty) ||
        (content == original.content.trim() && !hasImageChanges)) {
      context.pop();
      return;
    }

    final editedPost = original.copyWith(
      content: content,
      modifyDate: DateTime.now().toUtc().toIso8601String(),
      images: [..._existingImages, ...newImagePaths],
    );

    context.pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(EditPostEvent(editedPost, deletedImages: _deletedImages));
    });
  }

  void _removeExistingImage(String image) {
    setState(() {
      _existingImages.remove(image);
      _deletedImages.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final userData = DI.find<ICacheManager>().getUserData();

    return BlocListener<HomeBloc, HomeState>(
      listenWhen:
          (previous, current) =>
              previous.isPostAdded != current.isPostAdded ||
              (current.error != null && previous.error != current.error),
      listener: (context, state) {
        if (state.isPostAdded) {
          context.pop();
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.current.red,
            ),
          );
          bloc.add(ClearErrorEvent());
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              // ─── Custom Header ──────────────────────────────────────────
              _Header(
                isLoading: state.isAddPostLoading,
                onCancel: () => context.pop(),
                onPost: () => _submit(context, bloc),
                actionLabel: _isEditing ? AppText.edit : AppText.post,
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
                          hintText: AppText.whatsOnYourMind,
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
                      if (_isEditing && _existingImages.isNotEmpty)
                        _ExistingImagePreviewGrid(
                          images: _existingImages,
                          onRemove: _removeExistingImage,
                        ),

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
  final String actionLabel;

  const _Header({
    required this.isLoading,
    required this.onCancel,
    required this.onPost,
    required this.actionLabel,
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
              AppText.cancel,
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
              actionLabel,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── User Info Component ─────────────────────────────────────────────────────

class _UserHeader extends StatelessWidget {
  final UserModel? userData;

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
          child: AppProfileImage(
            radius: 22.r,
            imageUrl: userData?.avatar ?? userData?.image,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData?.userName ?? AppText.userFallback,
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
                  AppIcon(
                    token: AppIconToken.public,
                    size: 12.sp,
                    color: AppColors.current.midGray,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    AppText.publicLabel,
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
              child: AppCachedImage(
                imageUrl: images[index].path,
                fit: BoxFit.cover,
              ),
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
                  child: AppIcon(
                    token: AppIconToken.close,
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

class _ExistingImagePreviewGrid extends StatelessWidget {
  final List<String> images;
  final ValueChanged<String> onRemove;

  const _ExistingImagePreviewGrid({
    required this.images,
    required this.onRemove,
  });

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
        final image = images[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AppCachedImage(imageUrl: image, fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => onRemove(image),
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
            token: AppIconToken.photo,
            color: const Color(0xFF34A853),
            label: AppText.photo,
            onTap: onPickGallery,
          ),
          SizedBox(width: 16.w),
          _ToolbarIcon(
            token: AppIconToken.camera,
            color: AppColors.current.primary,
            label: AppText.camera,
            onTap: onPickCamera,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final AppIconToken token;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ToolbarIcon({
    required this.token,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconPill(token: token, label: label, color: color, onTap: onTap);
  }
}
