import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? widthFactor;
  final double? heightFactor;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.widthFactor = 0.9,
    this.heightFactor = 0.06,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: widthFactor != null ? screenWidth * widthFactor! : null,
      height: heightFactor != null ? screenHeight * heightFactor! : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // 🔹 Disable if loading
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.current.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: textColor ?? AppColors.current.white,
                    strokeWidth: 2.5,
                  ),
                )
                : Text(
                  text,
                  style:
                      textStyle ??
                      TextStyle(
                        color: textColor ?? AppColors.current.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
      ),
    );
  }
}
