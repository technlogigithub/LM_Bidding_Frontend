import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_images.dart';

class CustomBanner extends StatelessWidget {
  final List<Map<String, String>> banners;
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
    this.padding = const EdgeInsets.only(left: 15.0),
    this.margin = const EdgeInsets.only(right: 10.0),
    this.borderRadius = 8.0,
    this.fallbackImage,
  });

  // Shimmer widget for loading state
  Widget _buildBannerShimmer() {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: padding,
        itemCount: 3, // Default shimmer item count
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height.h,
            width: width.w, // Responsive width
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
    return Obx(
          () => isLoading.value
          ? _buildBannerShimmer()
          : SizedBox(
        height: height.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: padding,
          itemCount: banners.length,
          itemBuilder: (_, i) {
            final banner = banners[i];
            return GestureDetector(
              onTap: () {
                if (banner['redirectUrl']?.isNotEmpty ?? false) {
                  toast("Opening: ${banner['redirectUrl']}");
                }
              },
              child: Container(
                height: height.h,
                width: width.w,
                margin: margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
                child: Image.network(
                  banner['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      fallbackImage ?? AppImage.placeholder,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}