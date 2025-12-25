class ImageTypeHelper {
  static bool isImage(String? url) {
    if (url == null || url.isEmpty) return false;

    final lowerUrl = url.toLowerCase();
    final urlWithoutQuery = lowerUrl.split('?').first;

    return urlWithoutQuery.endsWith('.jpg') ||
        urlWithoutQuery.endsWith('.jpeg') ||
        urlWithoutQuery.endsWith('.png') ||
        urlWithoutQuery.endsWith('.gif') ||
        urlWithoutQuery.endsWith('.webp') ||
        urlWithoutQuery.endsWith('.bmp');
  }
}
