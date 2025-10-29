import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';

import '../../../../../core/utils/custom_button.dart';

class PetMedicalHistory extends StatelessWidget {
  const PetMedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffAEBED6), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F425A),
            ),
          ),
          const SizedBox(height: 10),
          PetFeaturesWidget(),
          const SizedBox(height: 10),

          CustomFilledButton(
            text: 'Apply To Adopt',
            onPressed: () {
              context.push(AppRoutes.petApplication);
            },
            leading: const Icon(Icons.pets, color: Colors.white),
            hasLeading: true,
            widthFactor: 1,
            heightFactor: 0.06,
          ),
        ],
      ),
    );
  }
}

class PetFeaturesWidget extends StatelessWidget {
  const PetFeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      'vaccinated',
      'Good Kids Energy',
      'Medium Energy',
      'Operations Man',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Features chips
          Wrap(
            spacing: 10.w,
            runSpacing: 3.h,
            alignment: WrapAlignment.start,
            children:
                features.map((feature) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        feature,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF2E2E3A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),

          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 20.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Ideal Home for Buddy: ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'active Family.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
