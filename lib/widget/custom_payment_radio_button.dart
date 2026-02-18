import 'package:flutter/material.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';

class CustomPaymentRadioButton extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomPaymentRadioButton({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: AppColors.appPagecolor,
            border: Border.all(color: AppColors.appMutedColor),
          ),
          child: ListTile(
            visualDensity: const VisualDensity(vertical: -2),
            contentPadding: const EdgeInsets.only(right: 8.0),
            leading: Container(
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, color: AppColors.appMutedColor),
                      )
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, color: AppColors.appMutedColor),
                      ),
              ),
            ),
            title: Text(
              title,
              style: AppTextStyle.description(color: AppColors.appBodyTextColor),
            ),
            trailing: Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? AppColors.appButtonColor
                  : AppColors.appMutedColor,
            ),
          ),
        ),
      ),
    );
  }
}
