import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? backgroundImage; // Background image for the dialog box
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    this.backgroundImage,
    this.confirmText = 'Yes',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          // gradient: AppColors.appPagecolor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
          image: backgroundImage.validate().isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(backgroundImage!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), 
                    BlendMode.darken
                  ), // Darken to make text readable
                )
              : null,
          gradient: backgroundImage.validate().isEmpty ? AppColors.appPagecolor : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.title(
                color: AppColors.appTitleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel!();
                        }
                        finish(context);
                      },
                      child: Text(
                        cancelText,
                        style: AppTextStyle.body(
                          color: AppColors.appColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomButton(
                    text: confirmText,
                    onTap: onConfirm,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
