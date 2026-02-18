import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../core/app_textstyle.dart';
import '../view/Home_screen/search_history_screen.dart';
import 'custom_auto_image_handle.dart';

class SearchBarWidget extends StatelessWidget {
  final String? title;
  final String? bgColor;
  final String? bgImg;
  final String? nextPageName;

  const SearchBarWidget({
    super.key,
    this.title,
    this.bgColor,
    this.bgImg,
    this.nextPageName,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: (bgColor != null && bgColor!.isNotEmpty)
                ? parseLinearGradient(bgColor)
                : null,
            color: (bgColor == null || bgColor!.isEmpty)
                ? AppColors.appDescriptionColor.withValues(alpha: 0.1)
                : null,

          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (hasValidImage)
                    AutoNetworkImage(
                      imageUrl: bgImg,
                      // width: double.infinity,
                    ),
                  hasValidImage
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: _buildSearchContent(context),
                        )
                      : _buildSearchContent(context),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildSearchContent(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Get.to(() => SearchHistoryScreen(
        nextPageName: nextPageName,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              FeatherIcons.search,
              color: AppColors.appTitleColor,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title ?? '',
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


