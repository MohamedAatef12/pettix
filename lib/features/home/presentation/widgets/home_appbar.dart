import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';

import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    return Padding(
      padding: PaddingConstants.medium,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/side_menu'),
            child: CachedNetworkImage(
              imageUrl: user?.avatar ?? '',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 30.r,
                backgroundImage: imageProvider,
                backgroundColor: AppColors.current.lightGray,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.current.lightGray,
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 30.r,
                backgroundImage: const AssetImage('assets/images/no_user.png'),
              ),
            ),
          ),
          SizedBox(width: 10.w,),
          SizedBox(
                  width:120.w,child: Text(user!.userName, style: AppTextStyles.bold)),

          Spacer(),
          GestureDetector(
            onTap: () {
              context.push('/home_search');
            },
            child: CircleAvatar(
                radius: 20.r,
                backgroundColor:AppColors.current.white,
                child:SvgPicture.asset('assets/icons/search.svg')),
          ),
          SizedBox(width: 10.w,),
          GestureDetector(
            onTap: () {
              context.push('/notifications');
            },
            child: CircleAvatar(
                radius: 20.r,
                backgroundColor:AppColors.current.white,
                child:Image.asset('assets/icons/notification.png')),
          ),
        ],
      ),
    );
  }
}