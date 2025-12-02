import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';

class CustomTextarea extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isRequired;
  final int minLines;
  final int maxLines;

  const CustomTextarea({super.key, required this.label, required this.hintText, this.controller, this.isRequired = false, this.minLines = 3, this.maxLines = 6});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.appTitleColor),
      decoration: InputDecoration(
        label: Text(label, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
        hintText: hintText,
        hintStyle: AppTextStyle.description(color: AppColors.appDescriptionColor.withValues(alpha: 0.4)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appBodyTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appDescriptionColor),
        ),
      ),
    );
  }
}


