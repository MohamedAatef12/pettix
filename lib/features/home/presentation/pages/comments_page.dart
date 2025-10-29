import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/widgets/comments_body.dart';

class CommentsPage extends StatelessWidget {
  final int postId;
  const CommentsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final user = DI.find<ICacheManager>().getUserData();
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: AppBar(
        backgroundColor: AppColors.current.primary,
        elevation: 0,
        title: Text(
          'Comments',
          style: TextStyle(
            color: AppColors.current.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pushReplacement('/bottom_nav'); // للرجوع
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.current.white,
            size: 35.r,
          ),
        ),
      ),
      body: CommentsBody(postId: postId),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: NetworkImage(user!.image.toString()),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: bloc.commentTextController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: AppTextStyles.description,
                    filled: true,
                    fillColor: AppColors.current.gray.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  final text = bloc.commentTextController.text.trim();
                  if (text.isEmpty) return;

                  final user = bloc.getUserDataUseCase.call();
                  user.then((result) {
                    result.fold(
                      (failure) => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message))),
                      (userData) {
                        final comment = CommentEntity(
                          id: 0, // backend will assign
                          text: text,
                          author: AuthorModel(
                            id: userData.id,
                            email: userData.email,
                            nameAr: '',
                            nameEn: userData.userName,
                            phone: userData.phone,
                            genderId: userData.genderId,
                            genderName: userData.gender,
                            contactTypeId: userData.contactTypeId,
                            statusId: userData.statusId,
                            avatar: userData.avatar,
                            age: userData.age,
                          ),
                          creationDate: DateTime.now().toIso8601String(),
                          postId: postId,
                          replies: [],
                        );
                        bloc.add(AddCommentEvent(comment));
                        bloc.commentTextController.clear();
                      },
                    );
                  });
                },
                child: SvgPicture.asset('assets/icons/add_comment.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
