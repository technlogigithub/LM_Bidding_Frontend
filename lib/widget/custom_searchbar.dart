import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';
import '../view/Home_screen/search_screen.dart';

class SearchBarWidget extends StatelessWidget {
  final String? title;
  final String? bgColor;
  final String? bgImg;

  const SearchBarWidget({
    super.key,
    this.title,
    this.bgColor,
    this.bgImg,
  });

  @override
  Widget build(BuildContext context) {

    print("BG image for saechbar $bgImg");
    print("BG color for saechbar $bgColor");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          decoration: BoxDecoration(
            image: (bgImg != null && bgImg!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(bgImg!),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: (bgImg == null || bgImg!.isEmpty)
                ? (bgColor != null && bgColor!.isNotEmpty
                    ? parseLinearGradient(bgColor)
                    : null)
                : null,
            color: (bgImg == null || bgImg!.isEmpty) &&
                    (bgColor == null || bgColor!.isEmpty)
                ? AppColors.appDescriptionColor.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(
              FeatherIcons.search,
              color: AppColors.appTitleColor,
              size: 18,
            ),
            title: Text(
              title ?? 'Search',
              style: AppTextStyle.description(color: AppColors.appTitleColor),
            ),
            onTap: () => Get.to(() => SearchScreen()),
          ),
        ),
    );
  }
}
