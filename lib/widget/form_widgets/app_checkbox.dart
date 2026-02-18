import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';

import '../../core/app_textstyle.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.appColor ,
                width: 2,
              ),
              color: value ? AppColors.appButtonColor : Colors.transparent,
            ),
            child: value
                ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style:   AppTextStyle.description(
                color: AppColors.appBodyTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
