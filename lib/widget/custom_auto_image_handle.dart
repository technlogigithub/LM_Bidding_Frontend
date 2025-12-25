import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_imagetype_helper.dart';

class AutoNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? height;

  const AutoNetworkImage({
    super.key,
    required this.imageUrl,
    this.margin,
    this.borderRadius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!ImageTypeHelper.isImage(imageUrl)) {
      return const SizedBox();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          imageUrl!,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return _shimmerPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor,
      highlightColor: AppColors.appMutedTextColor,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
