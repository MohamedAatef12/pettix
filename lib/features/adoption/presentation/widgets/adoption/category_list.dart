import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['Dogs', 'Cats', 'Birds', 'Rabbits', 'Fish'];
    List<String> categoryIcons = [
      'assets/images/Dog.svg',
      'assets/images/cat.svg',
      'assets/images/Bird.svg',
      'assets/images/Rabbit.svg',
      'assets/images/fish.svg',
    ];
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        separatorBuilder:
            (context, index) =>
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xffAEBED6),
                    width: 1.w,
                  ),
                ),
                child: SvgPicture.asset(
                  categoryIcons[index],
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                categories[index],
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}
