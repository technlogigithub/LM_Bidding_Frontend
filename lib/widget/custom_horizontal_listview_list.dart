import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import '../core/app_textstyle.dart';
import '../../core/app_textstyle.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import 'post_detail_screen.dart';
import '../core/app_images.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import 'custom_navigator.dart';

class CustomHorizontalListViewList extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final Function(String)? onItemTap;
  final Function(int, bool) onFavoriteToggle;
  final RxBool isLoading;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  const CustomHorizontalListViewList({
    super.key,
    required this.model,
    this.onItemTap,
    required this.onFavoriteToggle,
    required this.isLoading,
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
        return _buildShimmerList();
      }

      final results = model.value?.result;

      if (results == null || results.isEmpty) {
        return SizedBox(
          height: 180,
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

      final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

      Widget contentList = ListView.separated(
        padding: const EdgeInsets.only(
            top: 20, bottom: 20, left: 15.0, right: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10.0),
        itemBuilder: (_, index) {
          final result = results[index];
          return _buildItemCard(context, result, index);
        },
      );

      Widget contentWithHeader = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(
            height: 160.h,
            child: contentList,
          ),
        ],
      );

      // If we have an image, we want the Stack to size itself to the content (Column), 
      // and the Image to fill that size.
      // So we do NOT wrap Stack in SizedBox. We rely on contentWithHeader to dictate height.
      
      if (hasValidImage) {
        return Stack(
          children: [
            Positioned.fill(
              child: AutoNetworkImage(
                imageUrl: bgImg,
                // fit: BoxFit.cover,
              ),
            ),
            contentWithHeader,
          ],
        );
      }

      return Container(
        decoration: BoxDecoration(
          gradient: (bgColor != null && bgColor!.isNotEmpty)
              ? parseLinearGradient(bgColor)
              : AppColors.appPagecolor,
        ),
        child: contentWithHeader,
      );
    });
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        // physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        separatorBuilder: (_, __) => const SizedBox(width: 10.0),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: _buildShimmerItemCard(),
        ),
      ),
    );
  }

  // Shimmer placeholder for a single card
  Widget _buildShimmerItemCard() {
    return Container(
      width: 330,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.kBorderColorTextField),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section shimmer
          Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
          ),
          // Content section shimmer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title shimmer
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5.0),
                  // Rating and price shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 40),
                      Container(
                        width: 60,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  // Seller info shimmer
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            width: 60,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Result result, int index) {
    return GestureDetector(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(result.hidden?.ukey ?? '');
        } else {
             Get.to(() => PostDetailScreen(
               ukey: result.hidden?.ukey,
             ));
        }
      },
      child: Container(
        width: 330.w,
        height: 150.h,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          boxShadow: [
            BoxShadow(
              color: AppColors.appMutedColor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(result, index),
            _buildContentSection(result),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Result result, int index) {
    // Get first image from media list
    String? imageUrl;
    if (result.media != null && result.media!.isNotEmpty) {
      final firstImage = result.media!.firstWhere(
            (media) => media.mediaType == 'image',
        orElse: () => result.media!.first,
      );
      imageUrl = firstImage.url;
    }
    final badge = result.info?['badge'];
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: 135.h,
          width: 120.w,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
            ),
            color: AppColors.appWhite,
          ),
          child: imageUrl != null
              ? ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.appMutedColor,
                highlightColor: AppColors.appMutedTextColor,
                child: Container(
                  height: 135.h,
                  width: 120.w,
                  color: AppColors.appMutedColor,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                AppImage.placeholder,
                height: 135.h,
                width: 120.w,
                fit: BoxFit.cover,
              ),
            ),
          )
              : Image.asset(
            AppImage.placeholder,
            height: 135.h,
            width: 120.w,
            fit: BoxFit.cover,
          ),
        ),
        Obx(() {
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
              onFavoriteToggle(index, newValue);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.appIconColor,
                    size: 16.0,
                  ),
                ),
              ),
            ),
          );
        }),
        if (badge != null && badge.isNotEmpty)
          Positioned(
            top: 3,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                badge,
                textAlign: TextAlign.center,
                style: AppTextStyle.body(),
              ),
            ),
          ),

      ],
    );
  }

  Widget _buildContentSection(Result result) {
    final title = result.info?['title'] ?? '';
    final ratingReview = result.info?['ratingReview'] ?? '';
    final price = result.info?['price'] ?? '';

    // Parse rating and review count from ratingReview string
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

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              width: 190,
              child: Text(
                title,
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (ratingReview.isNotEmpty) ...[
                const Icon(Icons.star, color: Colors.amber, size: 18.0),
                const SizedBox(width: 2.0),
                if (rating > 0)
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTextStyle.body(
                      color: AppColors.appDescriptionColor,
                    ),
                  ),
                if (reviewText.isNotEmpty) ...[
                  const SizedBox(width: 2.0),
                  Text(
                    '($reviewText)',
                    style: AppTextStyle.body(
                      color: AppColors.appDescriptionColor,
                    ),
                  ),
                ],
                const SizedBox(width: 40),
              ],
              if (price.isNotEmpty)
                Text(
                  "₹$price",
                  style: AppTextStyle.title(

                  ),
                ),
            ],
          ),
          // if (sellerName.isNotEmpty) ...[
          //   const SizedBox(height: 5.0),
          //   Row(
          //     children: [
          //       Container(
          //         height: 32,
          //         width: 32,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: AppColors.appColor.withOpacity(0.2),
          //         ),
          //         child: Icon(
          //           Icons.person,
          //           size: 20,
          //           color: AppColors.appColor,
          //         ),
          //       ),
          //       const SizedBox(width: 5.0),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             sellerName,
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //             style: AppTextStyle.body(
          //               color: AppColors.appTitleColor,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           if (sellerLevel.isNotEmpty)
          //             Text(
          //               sellerLevel,
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: AppTextStyle.body(
          //                 color: AppColors.appDescriptionColor,
          //               ),
          //             ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ],
        ],
      ),
    );
  }
}