import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/app_images.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import 'custom_auto_image_handle.dart';

class CustomBanner extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final RxBool isLoading;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String? fallbackImage;
  final String? bgColor;
  final String? bgImg;

  const CustomBanner({
    super.key,
    required this.banners,
    required this.isLoading,
    this.height = 140.0,
    required this.width,
    this.padding = const EdgeInsets.only(left: 0),
    this.margin = const EdgeInsets.only(right: 2),
    this.borderRadius = 8.0,
    this.fallbackImage,
    this.bgColor,
    this.bgImg,
  });

  /// 🔹 Shimmer while loading
  Widget _buildBannerShimmer() {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: 3,
        itemBuilder: (_, __) => Container(
            height: height.h,
            width: width.w,
            margin: margin,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
            child: ClipRRect(
               borderRadius: BorderRadius.circular(borderRadius.r),
               child: Image.asset(AppImage.placeholder, fit: BoxFit.cover),
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value || banners.isEmpty) {
        return _buildBannerShimmer();
      }


      final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

      Widget contentList = ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: padding,
              itemCount: banners.length,
              itemBuilder: (_, index) {
                final banner = banners[index];

                final image = banner['image']?.toString() ?? '';
                final redirectUrl = banner['redirectUrl']?.toString() ?? '';

                return GestureDetector(
                  onTap: () {
                    if (redirectUrl.isNotEmpty) {
                      toast("Opening: $redirectUrl");
                    }
                  },
                  child: Container(
                    height: height.h,
                    width: width.w,
                    margin: margin,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(borderRadius.r),
                    ),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(borderRadius.r),
                      child: image.isEmpty 
                      ? Image.asset(AppImage.placeholder, fit: BoxFit.cover)
                      : Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            fallbackImage ?? AppImage.placeholder,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );

      if (hasValidImage) {
        return Stack(
          children: [
            AutoNetworkImage(imageUrl: bgImg),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: height.h,
                  child: contentList,
                ),
              ),
            ),
          ],
        );
      }

      return Container(
        height: height.h,
        decoration: BoxDecoration(
          gradient: (bgColor != null && bgColor!.isNotEmpty)
              ? parseLinearGradient(bgColor)
              : AppColors.appPagecolor,
        ),
        child: contentList,
      );
    });
  }
}
