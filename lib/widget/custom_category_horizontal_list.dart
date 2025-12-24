import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_images.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';

class CustomCategoryHorizontalList extends StatelessWidget {
  final List<Map<String, String>> categories;
  final RxBool isLoading;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double avatarRadius;
  final double imageSize;
  final double fontSize;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final String? fallbackImage;
  final int shimmerItemCount;
  final String? bgColor;
  final String? bgImg;

  const CustomCategoryHorizontalList({
    super.key,
    required this.categories,
    required this.isLoading,
    this.height = 130.0,
    this.padding = const EdgeInsets.only(left: 15.0, right: 15.0),
    this.itemPadding = const EdgeInsets.only(right: 8.0),
    this.avatarRadius = 35.0,
    this.imageSize = 70.0,
    this.fontSize = 14.0,
    this.textStyle,
    this.backgroundColor,
    this.fallbackImage,
    this.shimmerItemCount = 4,
    this.bgColor,
    this.bgImg,
  });

  Widget _buildCategoryShimmer() {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: padding,
        itemCount: shimmerItemCount,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: Padding(
            padding: itemPadding,
            child: Column(
              children: [
                Container(
                  width: (avatarRadius * 2).r,
                  height: (avatarRadius * 2).r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                // CircleAvatar(
                //   radius: avatarRadius.r,
                //   backgroundColor: backgroundColor ?? AppColors.appColor,
                // ),
                SizedBox(height: 4.h),
                Container(
                  width: 60.w,
                  height: fontSize.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildCategoryShimmer()
          : SizedBox(
        height: height.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: padding,
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final category = categories[i];
            final categoryName = category['name'] ?? 'Category';
            final categoryImage = category['image'] ?? '';


            print(" BG color for category $bgColor");
            print(" BG image for category $bgImg");



            return Padding(
              padding: itemPadding,
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
                  // shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   radius: avatarRadius.r,
                    //   backgroundColor: backgroundColor ?? AppColors.appColor,
                    //   child: ClipOval(
                    //     child: categoryImage.isNotEmpty
                    //         ? (categoryImage.startsWith('http')
                    //         ? Image.network(
                    //       categoryImage,
                    //       fit: BoxFit.cover,
                    //       width: imageSize.r,
                    //       height: imageSize.r,
                    //       loadingBuilder: (context, child, loadingProgress) {
                    //         if (loadingProgress == null) return child;
                    //         return Image.asset(
                    //           fallbackImage ?? AppImage.placeholder,
                    //           fit: BoxFit.cover,
                    //           width: imageSize.r,
                    //           height: imageSize.r,
                    //         );
                    //       },
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Image.asset(
                    //           fallbackImage ?? AppImage.placeholder,
                    //           fit: BoxFit.cover,
                    //           width: imageSize.r,
                    //           height: imageSize.r,
                    //         );
                    //       },
                    //     )
                    //         : Image.asset(
                    //       categoryImage,
                    //       fit: BoxFit.cover,
                    //       width: imageSize.r,
                    //       height: imageSize.r,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Image.asset(
                    //           fallbackImage ?? AppImage.placeholder,
                    //           fit: BoxFit.cover,
                    //           width: imageSize.r,
                    //           height: imageSize.r,
                    //         );
                    //       },
                    //     ))
                    //         : Image.asset(
                    //       fallbackImage ?? AppImage.placeholder,
                    //       fit: BoxFit.cover,
                    //       width: imageSize.r,
                    //       height: imageSize.r,
                    //     ),
                    //   ),
                    // ),
                  Container(
                  width: 80.w,
                  height: 80.h,
                    decoration: BoxDecoration(
                      // image: (bgImg != null && bgImg!.isNotEmpty)
                      //     ? DecorationImage(
                      //   image: NetworkImage(bgImg!),
                      //   fit: BoxFit.cover,
                      // )
                      //     : null,
                      // gradient: (bgImg == null || bgImg!.isEmpty)
                      //     ? (bgColor != null && bgColor!.isNotEmpty
                      //     ? parseLinearGradient(bgColor)
                      //     : null)
                      //     : null,
                      // shape: BoxShape.circle,
                    ),
                  clipBehavior: Clip.antiAlias,
                  child: categoryImage.isNotEmpty
                      ? (categoryImage.startsWith('http')
                      ? Image.network(
                    categoryImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset(
                        fallbackImage ?? AppImage.placeholder,
                        fit: BoxFit.cover,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        fallbackImage ?? AppImage.placeholder,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    categoryImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        fallbackImage ?? AppImage.placeholder,
                        fit: BoxFit.cover,
                      );
                    },
                  ))
                      : Image.asset(
                    fallbackImage ?? AppImage.placeholder,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 10.h,),
                    Text(
                      categoryName,
                      style: textStyle ??
                          AppTextStyle.body(
                            color: AppColors.appBodyTextColor,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}