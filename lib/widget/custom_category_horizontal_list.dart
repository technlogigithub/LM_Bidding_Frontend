import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_images.dart';
import '../../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import '../../core/app_textstyle.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import 'custom_navigator.dart';

class CustomCategoryHorizontalList extends StatelessWidget {
  final List<Map<String, String>> categories;
  final RxBool isLoading;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double fontSize;
  final TextStyle? textStyle;
  final String? fallbackImage;
  final int shimmerItemCount;
  final String? bgColor;
  final String? bgImg;

  const CustomCategoryHorizontalList({
    super.key,
    required this.categories,
    required this.isLoading,
    this.height = 130.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.itemPadding = const EdgeInsets.only(right: 12),
    this.fontSize = 14,
    this.textStyle,
    this.fallbackImage,
    this.shimmerItemCount = 4,
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
  });

  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  Widget _buildCategoryShimmer() {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: shimmerItemCount,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: Padding(
            padding: itemPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 60.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Text(
            label!,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
            ),
          ),
          const Spacer(),
          if (viewAllLabel != null && viewAllLabel!.isNotEmpty)
            GestureDetector(
              onTap: () {
                CustomNavigator.navigate(
                    viewAllNextPage?.isNotEmpty == true
                        ? viewAllNextPage
                        : nextPageName);
              },
              child: Text(
                viewAllLabel!,
                style: AppTextStyle.description(
                  color: AppColors.appLinkColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) return _buildCategoryShimmer();

      final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

      Widget contentList = ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final category = categories[i];
          final name = category['name'] ?? 'Category';
          final image = category['image'] ?? '';

          return GestureDetector(
            onTap: () {
              if (nextPageName?.isNotEmpty == true) {
                CustomNavigator.navigate(nextPageName);
              }
            },
            child: Padding(
              padding: itemPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: image.isNotEmpty
                        ? (image.startsWith('http')
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  fallbackImage ?? AppImage.placeholder,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(image, fit: BoxFit.cover))
                        : Image.asset(
                            fallbackImage ?? AppImage.placeholder,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          AppTextStyle.body(
                            color: AppColors.appBodyTextColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Create content with header
      Widget contentWithHeader = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildHeader(),
           SizedBox(
             height: height.h,
             child: contentList,
           ),
         ],
      );

      return Column(
        children: [
          hasValidImage
              ? Stack(
            children: [
              AutoNetworkImage(
                imageUrl: bgImg,
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 10.h,
                child: contentWithHeader,
              ),
            ],
          )
              : Container(
            // height: height.h, // Remove fixed height to allow growth
            decoration: BoxDecoration(
              gradient: (bgColor != null && bgColor!.isNotEmpty)
                  ? parseLinearGradient(bgColor)
                  : AppColors.appPagecolor,
            ),
            child: contentWithHeader,
          ),
        ],
      );
    });
  }
}
