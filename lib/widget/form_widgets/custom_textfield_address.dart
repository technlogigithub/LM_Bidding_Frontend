import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';

class CustomTextfieldForAddress extends StatelessWidget {
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

  // 🔹 Address specific controls
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;

  const CustomTextfieldForAddress({
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
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onSuffixTap,
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
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        style: TextStyle(color: AppColors.appTitleColor),
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        cursorColor: AppColors.appColor,
        maxLines: lines.toInt(),

        onTap: onTap,
        onChanged: onChanged,

        inputFormatters: [
          if (maxLength != null)
            LengthLimitingTextInputFormatter(maxLength),
          ...?inputFormatters,
        ],

        decoration: InputDecoration(
          label: Text(
            label,
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          hintText: hintText,
          hintStyle:
          AppTextStyle.description(color: AppColors.appDescriptionColor),

          suffixIcon: suffixIcon != null
              ? GestureDetector(
            onTap: onSuffixTap,
            child: suffixIcon,
          )
              : null,

          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appBodyTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appDescriptionColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.appBodyTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
