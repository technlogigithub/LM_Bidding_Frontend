import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_color.dart';

import '../core/app_textstyle.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../core/app_images.dart';
import '../core/app_imagetype_helper.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import 'custom_navigator.dart';
import 'custom_tapbar.dart';

class CustomVerticalListviewList extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final Function(String)? onItemTap;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onSaveForLaterTap;
  final VoidCallback? onBuyNowTap;
  final Function(int, bool) onFavoriteToggle;
  final RxBool isLoading;
  final bool isFromCartScreen;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added
  final Function(Map<String, dynamic> buttonData, String userKey)? onActionTap;

  const CustomVerticalListviewList({
    super.key,
    required this.model,
    this.onItemTap,
    this.onRemoveTap,
    this.onSaveForLaterTap,
    this.onBuyNowTap,
    this.onActionTap,
    required this.onFavoriteToggle,
    required this.isLoading,
    this.isFromCartScreen = false,
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : _buildPostList(context),
    );
  }

  Widget _buildHeader() {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb || screenWidth > 800;

    Widget contentList;

    if (isWeb) {
      contentList = GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: results.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // ✅ 1 Row me 3 items
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.4, // thoda wide card look ke liye
        ),
        itemBuilder: (_, index) {
          final result = results[index];
          return _buildItemCard(context, result, index);
        },
      );
    } else {
      // ✅ Mobile same rahega
      contentList = ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 15.0,
          right: 15.0,
        ),
        scrollDirection: Axis.vertical,
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10.0),
        itemBuilder: (_, index) {
          final result = results[index];
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildItemCard(context, result, index),
          );
        },
      );
    }

    // Widget contentList = ListView.separated(
    //   physics: const NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   padding: EdgeInsets.only(
    //     bottom: 20,
    //     left: isWeb ? 0 : 15.0,
    //     right: isWeb ? 0 : 15.0,
    //   ),
    //   scrollDirection: Axis.vertical,
    //   itemCount: results.length,
    //   separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    //   itemBuilder: (_, index) {
    //     final result = results[index];
    //     return Padding(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: _buildItemCard(context, result, index),
    //     );
    //   },
    // );

    Widget contentWithHeader = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        contentList,
      ],
    );

    return Stack(
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
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    final isWeb = kIsWeb;

    if (isWeb) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: _buildShimmerItemCard(),
          );
        },
      );
    } else {
      return SizedBox(
        height: 160 * 3,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 10.0),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: _buildShimmerItemCard(),
          ),
        ),
      );
    }
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
    final isWeb = kIsWeb || MediaQuery.of(context).size.width > 800;
    final cardHeight = isWeb ? (isFromCartScreen ? 160.0 : 130.0) : (isFromCartScreen ? 185.h : 140.h);

    return GestureDetector(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(result.hidden?.ukey ?? '');
        }
      },
      child: Container(
        width: isWeb ? null : double.infinity,
        height: cardHeight,
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
                  _buildImageSection(context, result, index, isFromCartScreen),
                  Expanded(child: _buildContentSection(context, result)),
                ],
              ),
            ),
            if (isFromCartScreen)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                  vertical: 8.0,
                ),
                child: result.actionButton != null && result.actionButton!.isNotEmpty
                    ? CustomTabBar(
                        tabs: result.actionButton!.map<String>((e) {
                          if (e is Map<String, dynamic>) {
                            return e['label']?.toString() ?? '';
                          }
                           // Fallback for unexpected types (though parsing logic in model makes it dynamic/Map usually, 
                           // unless we strictly typed it later)
                           // The model uses json['action_button'] which is List<dynamic> of Maps usually.
                           try {
                             return (e as dynamic)['label']?.toString() ?? '';
                           } catch (err) {
                             return '';
                           }
                        }).toList(),
                        textStyle: AppTextStyle.body(),
                        onTap: (index) {
                          if (index >= 0 && index < result.actionButton!.length) {
                             final btnData = result.actionButton![index];
                             final ukey = result.hidden?.ukey ?? "";
                             
                             if (onActionTap != null && btnData is Map<String, dynamic>) {
                                onActionTap!(btnData, ukey);
                             }
                          }
                        },
                      )
                    : SizedBox()
              )

          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, Result result, int index, bool isFromCart) {
    // Get first image from media list
    String? imageUrl;
    if (result.media != null && result.media!.isNotEmpty) {
      final firstImage = result.media!.firstWhere(
            (media) => media.mediaType == 'image',
        orElse: () => result.media!.first,
      );
      imageUrl = firstImage.url;
    }

    // Extract badge from result
    final badge = result.info?['badge'];

    final isWeb = kIsWeb || MediaQuery.of(context).size.width > 800;
    final imgWidth = isWeb ? 130.0 : 120.w;
    final imgHeight = isWeb ? (isFromCart ? 140.0 : 130.0) : (isFromCart ? 120.h : 140.h);

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: imgHeight,
          width: imgWidth,
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
                  height: imgHeight,
                  width: imgWidth,
                  color: AppColors.appMutedColor,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                AppImage.placeholder,
                height: imgHeight,
                width: imgWidth,
                fit: BoxFit.cover,
              ),
            ),
          )
              : Image.asset(
            AppImage.placeholder,
            height: imgHeight,
            width: imgWidth,
            fit: BoxFit.cover,
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
              // Defer refresh to avoid setState during build error
              Future.microtask(() {
                model.refresh();
              });
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
        // Badge - show only if available
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

  Widget _buildContentSection(BuildContext context, Result result) {
    final title = result.info?['title'] ?? '';
    final ratingReview = result.info?['rating_review'];
    final price = result.info?['price'];

    final isWeb = kIsWeb || MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyle.description(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,
            ).copyWith(
              fontSize: isWeb ? 16 : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
          // if (badge != null && badge.isNotEmpty)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 14,
          //           vertical: 6,
          //         ),
          //         decoration: BoxDecoration(
          //           gradient: AppColors.appPagecolor,
          //           borderRadius: BorderRadius.circular(10),
          //           boxShadow: [
          //             BoxShadow(
          //               color: AppColors.appMutedColor,
          //               blurRadius: 5,
          //               spreadRadius: 1,
          //               offset: Offset(0, 5),
          //             ),
          //           ],
          //         ),
          //         alignment: Alignment.center,
          //         child: Text(
          //           badge,
          //           textAlign: TextAlign.center,
          //           style: AppTextStyle.body(),
          //         ),
          //       ),
          //     ],
          //   ),

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
        // margin: const EdgeInsets.only(bottom: 10),
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
