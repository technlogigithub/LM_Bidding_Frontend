import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/app_images.dart';
import '../core/app_color.dart';

class CustomBanner extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final RxBool isLoading;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String? fallbackImage;

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
  });

  /// 🔹 Shimmer while loading
  Widget _buildBannerShimmer() {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: 3,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: Container(
            height: height.h,
            width: width.w,
            margin: margin,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
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

      return SizedBox(
        height: height.h,
        child: ListView.builder(
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
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                  child: Image.network(
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
        ),
      );
    });
  }
}
