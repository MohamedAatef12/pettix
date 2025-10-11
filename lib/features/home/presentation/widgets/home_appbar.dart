
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
    return Padding(
      padding: PaddingConstants.medium,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: NetworkImage(DI.find<ICacheManager>().getUserData()!.image.toString()),
          ),
          SizedBox(width: 10.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi', style: AppTextStyles.description.copyWith(
                  fontSize: 12.sp
              )),
              SizedBox(height: 2.h,),
              SizedBox(
                  width:120.w,child: Text(DI.find<ICacheManager>().getUserData()!.userName, style: AppTextStyles.bold)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              context.push('/home_search');
              final userToken = DI.find<ICacheManager>().getToken();
            },
            child: CircleAvatar(
                radius: 20.r,
                backgroundColor:AppColors.current.white,
                child:SvgPicture.asset('assets/icons/search.svg')),
          ),
          SizedBox(width: 10.w,),
          GestureDetector(
            onTap: () {},
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