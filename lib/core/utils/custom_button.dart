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
  final bool hasLeading;
  final bool hasTrailing;
  final Widget? leading;
  final Widget? trailing;
  final double spacing;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.widthFactor = 0.4,
    this.heightFactor = 0.05,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.isLoading = false,
    this.hasLeading = false,
    this.hasTrailing = false,
    this.leading,
    this.trailing,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.current.primary,
        minimumSize: Size(
          screenWidth * (widthFactor ?? 0.4),
          screenHeight * (heightFactor ?? 0.05),
        ),
        maximumSize: Size(
          screenWidth * (widthFactor ?? 0.4),
          screenHeight * (heightFactor ?? 0.05),
        ),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),

      onPressed: isLoading ? null : onPressed,
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
              : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasLeading && leading != null) ...[
                    leading ?? SizedBox.shrink(),
                    SizedBox(width: spacing),
                  ],
                  Text(
                    text,
                    style:
                        textStyle ??
                        TextStyle(
                          color: textColor ?? AppColors.current.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (hasTrailing) ...[
                    SizedBox(width: spacing),

                    trailing ?? SizedBox.shrink(),
                  ],
                ],
              ),
    );
  }
}
