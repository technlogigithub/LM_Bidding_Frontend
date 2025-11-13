import 'package:get/get.dart';

class ServiceItem {
  final String imagePath;
  final String title;
  final double rating;
  final int reviewCount;
  final double price;
  final String profileImagePath;
  final String sellerName;
  final String sellerLevel;
  RxBool isFavorite;

  ServiceItem({
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.profileImagePath,
    required this.sellerName,
    required this.sellerLevel,
    required bool isFavorite,
  }) : isFavorite = isFavorite.obs;
}