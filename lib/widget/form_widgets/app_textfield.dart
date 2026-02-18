import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_color.dart';
import '../../core/app_textstyle.dart'; // For LengthLimitingTextInputFormatter


class CustomTextfield extends StatelessWidget {
  final String label;
  final String hintText;
  final double lines;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool isRequired;
  final int? maxLength;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;

  // 🔹 New
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextfield({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.lines = 1,
    this.isRequired = false,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.readOnly = false,       // 🔹
    this.onTap,                 // 🔹

  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.appColor,
          selectionHandleColor: AppColors.appColor,
        ),
      ),
      child: TextField(
        textInputAction: textInputAction,
        controller: controller,
        style: TextStyle(color: AppColors.appTitleColor),
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        cursorColor: AppColors.appColor,
        maxLines: lines.toInt(),
        readOnly: readOnly,     // 🔹
        onTap: onTap,           // 🔹
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          ...?inputFormatters,
        ],
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          label: Text(
            label,
            style: AppTextStyle.description(color: AppColors.appDescriptionColor),
          ),
          hintText: hintText,
          hintStyle: AppTextStyle.description(color: AppColors.appDescriptionColor),
          suffixIcon: suffixIcon,
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appBodyTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appDescriptionColor),
          ),
        ),
      ),
    );
  }
}

