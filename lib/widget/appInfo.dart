import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

import '../core/app_textstyle.dart';


class InfoShowCase extends StatelessWidget {
  const InfoShowCase({
    super.key,
    required this.title,
    required this.subTitle,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String subTitle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.appWhite,
        border: Border.all(color: AppColors.appTextColor.withOpacity(0.5)), // Updated
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTextStyle.kTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ), // Uses dynamic neutralColor from AppTextStyle
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Icon(
                  IconlyBold.edit,
                  color: AppColors.appMutedTextColor, // Updated
                  size: 18.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                subTitle,
                style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.appMutedTextColor, // Updated
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  IconlyBold.delete,
                  color: AppColors.appMutedTextColor, // Updated
                  size: 18.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}