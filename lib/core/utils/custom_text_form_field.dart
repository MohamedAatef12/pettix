import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;

  final String? hintText;
  final String? labelText;

  final Widget? leading;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool enablePasswordToggle;
  final VoidCallback? onToggleObscureText; // 🔹 جديد
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final bool? fillColor;
  final Color? fillColorValue;

  const CustomTextFormField({
    super.key,
    this.controller,

    this.hintText,
    this.labelText,
    this.leading,
    this.suffixIcon,
    this.obscureText = false,
    this.enablePasswordToggle = false,
    this.onToggleObscureText, // 🔹 جديد
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.enabled = true,
    this.contentPadding,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.fillColor,
    this.fillColorValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: fillColor,
        fillColor: fillColorValue,
        prefixIcon: leading,
        suffixIcon: enablePasswordToggle
            ? IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.current.lightText,
          ),
          onPressed: onToggleObscureText, // 🔹 يبعث event للبلوك
        )
            : suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: border ?? const OutlineInputBorder(),
        focusedBorder: focusedBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
        enabledBorder: enabledBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
      ),
    );
  }
}
