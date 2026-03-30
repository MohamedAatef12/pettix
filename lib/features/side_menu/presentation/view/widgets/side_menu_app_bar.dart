import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

class SideMenuAppBar extends StatelessWidget {
  const SideMenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: RtlAwareIcon(
            child: SvgPicture.asset('assets/icons/backButton.svg'),
          ),
        ),
      ],
    );
  }
}
