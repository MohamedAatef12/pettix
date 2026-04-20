import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatTextFormField extends StatefulWidget {
  final int conversationId;
  const ChatTextFormField({super.key, required this.conversationId});

  @override
  State<ChatTextFormField> createState() => _ChatTextFormFieldState();
}

class _ChatTextFormFieldState extends State<ChatTextFormField> {
  late TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(
            conversationId: widget.conversationId,
            content: text,
          ));
      _controller.clear();
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.current.lightGray,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 25.h),
            _buildPickerOption(
              icon: Iconsax.camera,
              label: 'Camera',
              onTap: () => _handleImageSelection(ImageSource.camera),
            ),
            SizedBox(height: 15.h),
            _buildPickerOption(
              icon: Iconsax.gallery,
              label: 'Gallery',
              onTap: () => _handleImageSelection(ImageSource.gallery),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.current.lightGray.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.current.primary),
            SizedBox(width: 15.w),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14.r, color: AppColors.current.gray),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    Navigator.pop(context);

    if (source == ImageSource.gallery) {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (images.isNotEmpty && mounted) {
        // Send images sequentially to avoid flooding memory & network
        for (var image in images) {
          if (!mounted) break;
          context.read<ChatBloc>().add(SendMessageEvent(
                conversationId: widget.conversationId,
                content: '',
                imagePath: image.path,
              ));
          // Small delay between sends to avoid concurrent upload OOM
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
    } else {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null && mounted) {
        context.read<ChatBloc>().add(SendMessageEvent(
              conversationId: widget.conversationId,
              content: '',
              imagePath: image.path,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.lightGray,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.current.gray.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          SizedBox(width: 15.w),
          SvgPicture.asset(
            'assets/icons/pencil.svg',
            width: 20.w,
            height: 20.h,
          ),

          Expanded(
            child: CustomTextFormField(
              controller: _controller,
              fillColor: true,
              fillColorValue: AppColors.current.lightGray,
              hintText: 'write your message here',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              onFieldSubmitted: (_) => _sendMessage(),
            ),
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: SvgPicture.asset(
              'assets/icons/send.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                AppColors.current.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
            child: VerticalDivider(
              color: AppColors.current.gray.withValues(alpha: 0.4),
              thickness: 0.8,
              width: 20.w,
            ),
          ),

          GestureDetector(
            onTap: _pickImage,
            child: SvgPicture.asset(
              'assets/icons/camera.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                AppColors.current.gray,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}
