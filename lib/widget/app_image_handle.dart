import 'package:flutter/foundation.dart';
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
    // If URL is empty, return SizedBox or a default icon
    if (url.isEmpty) return const SizedBox();

    String finalUrl = url;
    // On Web, mixed content (HTTP image on HTTPS site) is blocked.
    // Try upgrading to HTTPS if the URL is HTTP.
    if (kIsWeb && finalUrl.startsWith("http://")) {
      finalUrl = finalUrl.replaceFirst("http://", "https://");
    }

    if (_isSvg(finalUrl)) {
      // Handle SVG
      return SvgPicture.network(
        finalUrl,
        height: height,
        width: width,
        fit: fit,
        placeholderBuilder: (context) => const SizedBox(),
      );
    }

    // Handle all raster formats JPG/JPEG/PNG/WEBP/HEIF/HEIC/GIF/BMP/AVIF/etc.
    return Image.network(
      finalUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Image Load Error for URL: $finalUrl -> $error");
        return const Icon(Icons.broken_image, size: 20, color: Colors.grey);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: const Center(
             child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
