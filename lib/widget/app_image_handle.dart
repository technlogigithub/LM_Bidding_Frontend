import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UniversalImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BoxFit fit;

  const UniversalImage({
    Key? key,
    required this.url,
    required this.height,
    required this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith(".svg");
  }

  @override
  Widget build(BuildContext context) {
    if (_isSvg(url)) {
      // Handle SVG
      return SvgPicture.network(
        url,
        height: height,
        width: width,
        fit: fit,
        placeholderBuilder: (context) => const SizedBox(),
      );
    }

    // Handle all raster formats JPG/JPEG/PNG/WEBP/HEIF/HEIC/GIF/BMP/AVIF/etc.
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }
}
