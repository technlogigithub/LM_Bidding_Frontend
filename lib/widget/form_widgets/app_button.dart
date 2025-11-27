import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_textstyle.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? backgroundColor;
  final bool isLoading;

  CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
    this.isLoading = false,
  });

  final controller = Get.put(AppSettingsController());

  Color parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.blue; // fallback color
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor'; // add alpha if missing
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final buttonColor = AppColors.appButtonColor;
    final isDisabled = isLoading || onTap == null;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: screenHeight * 0.055,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDisabled ? 0.1 : 0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          color: isDisabled 
              ? (backgroundColor ?? buttonColor).withValues(alpha: 0.6)
              : (backgroundColor ?? buttonColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.appButtonTextColor,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: AppTextStyle.title(
                    color: AppColors.appButtonTextColor,
                  ),
                ),
        ),
      ),
    );
  }
}
