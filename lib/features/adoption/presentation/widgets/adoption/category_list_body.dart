import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/utils/custom_button.dart';

import '../../../../../config/router/routes.dart';

class CategoryListBody extends StatelessWidget {
  const CategoryListBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = ['assets/images/buddy.svg', 'assets/images/caty.svg'];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xffF0E8DB), width: 1.5.w),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                ListTile(
                  title: Center(child: Text('Charlie')),
                  subtitle: Text(
                    'Subbran animal leagueEnergtic and loves walks',
                  ),
                ),
                CustomFilledButton(
                  text: 'View Profile',
                  onPressed: () {
                    context.push(AppRoutes.petProfile);
                  },

                  hasLeading: true,
                  leading: Icon(
                    Icons.pets_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),

                SizedBox(height: 10.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
