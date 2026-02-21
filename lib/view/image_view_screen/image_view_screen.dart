import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../widget/form_widgets/web_file_drop_zone_stub.dart'
    if (dart.library.html) '../../../widget/form_widgets/web_file_drop_zone_web.dart' as web_drop;

class ImageViewScreen extends StatelessWidget {
  final File imageFile;
  final String? imageUrl;

  const ImageViewScreen({
    super.key,
    required this.imageFile,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "View Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4.0,
          child: imageUrl != null
              ? Image.network(
            imageUrl!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image,
              color: Colors.white70,
              size: 100,
            ),
          )
              : kIsWeb
                  ? (web_drop.getWebFileBytes(imageFile.path) != null
                      ? Image.memory(
                          web_drop.getWebFileBytes(imageFile.path)!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 100,
                          ),
                        )
                      : const Icon(Icons.broken_image, color: Colors.white70, size: 100))
                  : Image.file(
                      imageFile,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: Colors.white70,
                        size: 100,
                      ),
                    ),
        ),
      ),
    );
  }
}