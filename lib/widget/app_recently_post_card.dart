import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';
import '../models/Post/Get_Post_List_Model.dart';

class AppRecentlyPostCard extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final VoidCallback? onItemTap;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onSaveForLaterTap;
  final VoidCallback? onBuyNowTap;
  final Function(int, bool) onFavoriteToggle;
  final RxBool isLoading;
  final bool isFromCartScreen;

  const AppRecentlyPostCard({
    super.key,
    required this.model,
    this.onItemTap,
    this.onRemoveTap,
    this.onSaveForLaterTap,
    this.onBuyNowTap,
    required this.onFavoriteToggle,
    required this.isLoading,
    this.isFromCartScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? _buildShimmerList()
          : _buildPostList(context),
    );
  }

  Widget _buildPostList(BuildContext context) {
    final results = model.value?.result;
    
    if (results == null || results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No posts found',
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: results.length * (isFromCartScreen ? 200.h : 182.h),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 0.0,
          right: 0.0,
        ),
        scrollDirection: Axis.vertical,
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10.0),
        itemBuilder: (_, index) {
          final result = results[index];
          return Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: _buildItemCard(context, result, index),
          );
        },
      ),
    );
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 15.0,
          right: 15.0,
        ),
        scrollDirection: Axis.vertical,
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
                  Container(width: 150, height: 16, color: Colors.white),
                  const SizedBox(height: 5.0),
                  // Rating and price shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(width: 80, height: 14, color: Colors.white),
                      const SizedBox(width: 40),
                      Container(width: 60, height: 14, color: Colors.white),
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
                          Container(width: 60, height: 12, color: Colors.white),
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
      onTap: onItemTap ?? () {},
      child: Container(
        width: 330.w,
        height: isFromCartScreen ? 185.h : 140.h,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(result, index, isFromCartScreen),
                  Expanded(child: _buildContentSection(result)),
                ],
              ),
            ),
            if (isFromCartScreen)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                  vertical: 8.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // ✅ Horizontal scroll
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onRemoveTap ?? () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.appMutedTextColor,
                            ),
                          ),
                          child: Text(
                            AppStrings.remove,
                            style: AppTextStyle.body(
                              color: AppColors.appBodyTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8), // ✅ spacing

                      InkWell(
                        onTap: onSaveForLaterTap ?? () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.kBorderColorTextField,
                            ),
                          ),
                          child: Text(
                            AppStrings.saveForLater,
                            style: AppTextStyle.body(
                              color: AppColors.appBodyTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8), // ✅ spacing

                      InkWell(
                        onTap: onBuyNowTap ?? () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.kBorderColorTextField,
                            ),
                          ),
                          child: Text(
                            AppStrings.buyThisNow,
                            style: AppTextStyle.body(
                              color: AppColors.appBodyTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Result result, int index, bool isFromCart) {
    // Get first image from media list
    String? imageUrl;
    if (result.media != null && result.media!.isNotEmpty) {
      final firstImage = result.media!.firstWhere(
        (media) => media.mediaType == 'image',
        orElse: () => result.media!.first,
      );
      imageUrl = firstImage.url;
    }

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: isFromCart ? 120.h : 140.h,
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
                    placeholder: (context, url) => Container(
                      color: AppColors.appMutedColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.appMutedColor,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : Container(
                  color: AppColors.appMutedColor,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                  ),
                ),
        ),
        // Always show favorite icon - filled when true, outline when false
        Obx(() {
          // Watch the model to get reactive updates
          final currentResult = model.value?.result?[index];
          final isFavorite = currentResult?.info?['favorite'] ?? result.info?['favorite'] ?? false;
          return GestureDetector(
            onTap: () {
              // Toggle favorite state
              final newValue = !isFavorite;
              // Update the model immediately for better UX
              if (result.info != null) {
                result.info!['favorite'] = newValue;
              }
              // Refresh the model to trigger UI update
              model.refresh();
              // Call the callback to handle API call if needed
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
      ],
    );
  }

  Widget _buildContentSection(Result result) {
    final title = result.info?['title'] ?? '';
    final ratingReview = result.info?['ratingReview'];
    final price = result.info?['price'];
    final badge = result.info?['badge'];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
     mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
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
          const SizedBox(height: 5.0),
          // Rating/Review and Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Rating Review - show if available
              if (ratingReview != null && ratingReview.isNotEmpty) ...[
                const Icon(Icons.star, color: Colors.amber, size: 18.0),
                const SizedBox(width: 2.0),
                Flexible(
                  child: Text(
                    ratingReview,
                    style: AppTextStyle.body(color: AppColors.appTitleColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              // Price - show only if not null
              if (price != null && price.isNotEmpty) ...[
                if (ratingReview != null && ratingReview.isNotEmpty)
                  const SizedBox(width: 20),
                Text(
                  "₹$price",
                  style: AppTextStyle.description(
                    color: AppColors.appTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ],
          ),
          const SizedBox(height: 5.0),
          // Badge - show only if available
          if (badge != null && badge.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body(),
                  ),
                ),
              ],
            ),

    // // Seller info
          // if (sellerName.isNotEmpty)
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
          //       Flexible(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               sellerName,
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: AppTextStyle.body(
          //                 color: AppColors.appTitleColor,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }

}
class CartActionButtons extends StatelessWidget {
  final VoidCallback? onRemoveTap;
  final VoidCallback? onSaveForLaterTap;
  final VoidCallback? onBuyNowTap;
  final double screenWidth;

  const CartActionButtons({
    super.key,
    this.onRemoveTap,
    this.onSaveForLaterTap,
    this.onBuyNowTap,
    required this.screenWidth,
  });

  Widget _actionButton({
    required String title,
    required Color textColor,
    required Color borderColor,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _actionButton(
              title: AppStrings.remove,
              textColor: AppColors.appBodyTextColor,
              borderColor: AppColors.appMutedTextColor,
              onTap: onRemoveTap,
            ),
            _actionButton(
              title: AppStrings.saveForLater,
              textColor: AppColors.appButtonTextColor,
              borderColor: AppColors.kBorderColorTextField,
              onTap: onSaveForLaterTap,
            ),
            _actionButton(
              title: AppStrings.buyThisNow,
              textColor: AppColors.appButtonTextColor,
              borderColor: AppColors.kBorderColorTextField,
              onTap: onBuyNowTap,
            ),
          ],
        ),
      ),
    );
  }
}

