import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_color.dart'; // For LengthLimitingTextInputFormatter


class CustomTextfield extends StatelessWidget {
  final String label;
  final String hintText;
  final double lines;
  final TextEditingController? controller; // 🔹 Now optional
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool isRequired;
  final int? maxLength;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

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
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          // selectionColor: AppColors.appTextColor.withValues(alpha: 0.20),
          // selectionHandleColor: AppColors.appTextColor.withValues(alpha: 0.80),
          selectionColor: AppColors.appColor,
            selectionHandleColor: AppColors.appColor,
        ),
      ),
      child: TextField(
        controller: controller, // can be null
        style: TextStyle(color: AppColors.appTitleColor),
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        cursorColor: AppColors.appColor,
        maxLines: lines.toInt(),
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          ...?inputFormatters,
        ],
        onChanged: onChanged, // 🔹 callback added
        decoration: InputDecoration(
          label:Text(label,style: TextStyle(color: AppColors.appDescriptionColor),) ,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.appDescriptionColor),
          suffixIcon: suffixIcon,
          counterText: "", // 🔹 hides default counter
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
