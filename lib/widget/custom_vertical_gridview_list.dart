import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_textstyle.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../core/app_color.dart';
import '../core/app_images.dart';
import '../core/app_imagetype_helper.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import 'custom_navigator.dart';

class CustomVerticalGridviewList extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final RxBool isLoading;
  final Function(int, bool)? onFavoriteToggle;
  final Function(String)? onItemTap;
  final double? childAspectRatio;
  final double? height;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  const CustomVerticalGridviewList({
    super.key,
    required this.model,
    required this.isLoading,
    this.onFavoriteToggle,
    this.onItemTap,
    this.childAspectRatio,
    this.height,
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
  });

  Widget _buildHeader() {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Text(
            label!,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
            ),
          ),
          const Spacer(),
          if (viewAllLabel != null && viewAllLabel!.isNotEmpty)
            GestureDetector(
              onTap: () {
                CustomNavigator.navigate(
                    viewAllNextPage?.isNotEmpty == true
                        ? viewAllNextPage
                        : nextPageName);
              },
              child: Text(
                viewAllLabel!,
                style: AppTextStyle.description(
                  color: AppColors.appLinkColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return _buildShimmerGrid();
      }

      final results = model.value?.result;

      if (results == null || results.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'No posts found',
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),
          ),
        );
      }

      // Calculate default aspect ratio if not provided
      final aspectRatio = childAspectRatio ?? 0.84;

      Widget contentGrid = GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: aspectRatio,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return _buildItemCard(context, result, index);
        },
      );

      Widget contentWithHeader = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          contentGrid,
        ],
      );

      Widget gridView = Stack(
        children: [
          if (ImageTypeHelper.isImage(bgImg))
            Positioned.fill(
              child: AutoNetworkImage(imageUrl: bgImg),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: !ImageTypeHelper.isImage(bgImg)
                  ? (bgColor != null && bgColor!.isNotEmpty
                      ? parseLinearGradient(bgColor)
                      : AppColors.appPagecolor)
                  : null,
            ),
            child: contentWithHeader,
          ),
        ],
      );


      if (height != null) {
        return SizedBox(height: height, child: gridView);
      }

      return gridView;
    });
  }

  Widget _buildShimmerGrid() {
    final aspectRatio = childAspectRatio ?? 0.64;

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemCount: 4, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: _buildShimmerItemCard(),
        );
      },
    );
  }

  Widget _buildShimmerItemCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderColorTextField),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Content shimmer
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 16, color: Colors.white),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 60, height: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Container(width: 80, height: 14, color: Colors.white),
                  ],
                ),
                SizedBox(height: 8),
                Container(width: 70, height: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Result result, int index) {
    // Get first image from media list
    String? imageUrl;
    if (result.media != null && result.media!.isNotEmpty) {
      final firstImage = result.media!.firstWhere(
        (media) => media.mediaType == 'image',
        orElse: () => result.media!.first,
      );
      imageUrl = firstImage.url;
    }

    // Extract data from result
    final title = result.info?['title'] ?? '';
    final ratingReview = result.info?['ratingReview'] ?? '';
    final price = result.info?['price'] ?? '';
    final badge = result.info?['badge'];

    // Parse rating from ratingReview string
    double rating = 0.0;
    String reviewText = '';
    if (ratingReview.isNotEmpty) {
      final ratingMatch = RegExp(r'(\d+\.?\d*)').firstMatch(ratingReview);
      if (ratingMatch != null) {
        rating = double.tryParse(ratingMatch.group(1) ?? '0') ?? 0.0;
      }
      final reviewMatch = RegExp(r'\(([^)]+)\)').firstMatch(ratingReview);
      if (reviewMatch != null) {
        reviewText = reviewMatch.group(1) ?? '';
      } else {
        reviewText = ratingReview.replaceFirst(RegExp(r'^\d+\.?\d*\s*'), '');
      }
    }

    return GestureDetector(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(result.hidden?.ukey ?? '');
        } else {
             print('Tapped: $title');
        }
      },

      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.appMutedColor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- IMAGE + FAVORITE ICON + BADGE ----------------
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.appMutedColor,
                              highlightColor: AppColors.appMutedTextColor,
                              child: Container(
                                height: 130,
                                width: double.infinity,
                                color: AppColors.appMutedColor,
                              ),
                            ),
                                errorWidget: (context, url, error) => Image.asset(
                                  AppImage.placeholder,
                                  height: 130,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ), /* Error Widget */
                              )
                            : Image.asset(
                                AppImage.placeholder,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ), /* Null URL Widget */
                  ),

                  // Favorite icon
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        final currentResult = model.value?.result?[index];
                        final isFavorite = currentResult?.info?['favorite'] ?? result.info?['favorite'] ?? false;
                        return GestureDetector(
                          onTap: () {
                            final newValue = !isFavorite;
                            if (result.info != null) {
                              result.info!['favorite'] = newValue;
                            }
                            Future.microtask(() {
                              model.refresh();
                            });
                            onFavoriteToggle!(index, newValue);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : AppColors.appIconColor,
                              size: 18.0,
                            ),
                          ),
                        );
                      }),
                    ),

                  // Badge
                  if (badge != null && badge.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.appPagecolor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          badge,
                          style: AppTextStyle.body(),
                        ),
                      ),
                    ),
                ],
              ),

              // ---------------- DETAILS SECTION ----------------
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.description(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appTitleColor,
                      ),
                    ),

                    SizedBox(height: 8),

                    // Rating Row
                    if (ratingReview.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          if (rating > 0)
                            Text(
                              rating.toStringAsFixed(1),
                              style: AppTextStyle.body(
                                color: AppColors.appTitleColor,
                              ),
                            ),
                          if (reviewText.isNotEmpty) ...[
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '($reviewText)',
                                style: AppTextStyle.body(
                                  color: AppColors.appDescriptionColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ],
                      ),

                    if (ratingReview.isNotEmpty) SizedBox(height: 8),

                    // Price
                    if (price.isNotEmpty)
                      Text(
                        "₹$price",
                        style: AppTextStyle.description(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appTitleColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
