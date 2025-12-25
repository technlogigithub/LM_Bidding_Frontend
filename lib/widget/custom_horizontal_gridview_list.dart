import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../../core/app_textstyle.dart';
import '../../core/app_images.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import 'custom_navigator.dart';

class CustomHorizontalGridViewList extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final RxBool isLoading;
  final Function(String)? onItemTap;
  final Function(int, bool)? onFavoriteToggle;
  final double? height;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  const CustomHorizontalGridViewList({
    super.key,
    required this.model,
    required this.isLoading,
    this.onItemTap,
    this.onFavoriteToggle,
    this.height,
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
          : _buildFlexibleListView(context),
    );
  }

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

  Widget _buildFlexibleListView(BuildContext context) {
    final results = model.value?.result;

    if (results == null || results.isEmpty) {
      return SizedBox(
        height: height ?? 295.h,
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

    // Calculate default height: image (135.h) + content min (100.h) + padding (40.h) + extra space (20.h)
    final defaultHeight = 135.h + 104.h + 40.h + 20.h;
    final listViewHeight = height ?? defaultHeight;
    final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

    Widget contentList = ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 20.h,
        left: 15.w,
        right: 15.w,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: results.length,
      separatorBuilder: (_, __) => SizedBox(width: 10.w),
      itemBuilder: (_, i) => _buildItemCard(context, results[i], i),
    );

    Widget contentWithHeader = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(
          height: listViewHeight,
          child: contentList,
        ),
      ],
    );

    if (hasValidImage) {
      return Stack(
        children: [
          Positioned.fill(
              child: AutoNetworkImage(
            imageUrl: bgImg,
            // fit: BoxFit.cover,
          ))       ,
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
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    // Calculate default height: image (135.h) + content min (100.h) + padding (40.h) + extra space (20.h)
    final defaultHeight = 135.h + 100.h + 40.h + 20.h;
    final listViewHeight = height ?? defaultHeight;

    return SizedBox(
      height: listViewHeight,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: 20.h,
          left: 15.w,
          right: 15.w,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section shimmer
          Container(
            height: 135.h,
            width: 156.w,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                topLeft: Radius.circular(8.r),
              ),
              border: Border.all(color: AppColors.kBorderColorTextField),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkWhite,
                  blurRadius: 5.r,
                  spreadRadius: 2.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
          ),
          // Content section shimmer
          Container(
            width: 156.w,
            constraints: BoxConstraints(minHeight: 100.h),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              border: Border(
                left: BorderSide(
                  color: AppColors.kBorderColorTextField,
                  width: 1,
                ),
                right: BorderSide(
                  color: AppColors.kBorderColorTextField,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: AppColors.kBorderColorTextField,
                  width: 1,
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkWhite,
                  blurRadius: 5.r,
                  spreadRadius: 2.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller name shimmer
                  Container(width: 100.w, height: 16.sp, color: Colors.white),
                  SizedBox(height: 6.h),
                  // Rating shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.w,
                        height: 14.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Seller level shimmer
                  Container(width: 80.w, height: 14.sp, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Actual item card
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

    // Parse rating and review count from ratingReview string (format: "5.0 (520 review)" or similar)
    double rating = 0.0;
    String reviewText = '';
    if (ratingReview.isNotEmpty) {
      // Try to extract rating number (first number in the string)
      final ratingMatch = RegExp(r'(\d+\.?\d*)').firstMatch(ratingReview);
      if (ratingMatch != null) {
        rating = double.tryParse(ratingMatch.group(1) ?? '0') ?? 0.0;
      }
      // Extract review text (everything after rating)
      final reviewMatch = RegExp(r'\(([^)]+)\)').firstMatch(ratingReview);
      if (reviewMatch != null) {
        reviewText = reviewMatch.group(1) ?? '';
      } else {
        // If no parentheses, use the whole string after rating
        reviewText = ratingReview.replaceFirst(RegExp(r'^\d+\.?\d*\s*'), '');
      }
    }
    final badge = result.info?['badge'];

    return GestureDetector(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(result.hidden?.ukey ?? '');
        }
      },
      child: Container(
        width: 156.w,
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
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- IMAGE ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 135.h,
                          width: 156.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.appMutedColor,
                            highlightColor: AppColors.appMutedTextColor,
                            child: Container(
                              height: 135.h,
                              width: 156.w,
                              color: AppColors.appMutedColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AppImage.placeholder,
                            height: 135.h,
                            width: 156.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppImage.placeholder,
                          height: 135.h,
                          width: 156.w,
                          fit: BoxFit.cover,
                        ),
                ),
                // Favorite icon
                if (onFavoriteToggle != null)
                  Obx(() {
                    final currentResult = model.value?.result?[index];
                    final isFavorite =
                        currentResult?.info?['favorite'] ??
                        result.info?['favorite'] ??
                        false;
                    return Positioned(
                      top: 5.h,
                      right: 5.w,
                      child: GestureDetector(
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
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.red
                                  : AppColors.appIconColor,
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
                    left: 2,
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
            ),

            // --- DETAILS ---
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "",
                    style: AppTextStyle.title(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6.h),

                  if (ratingReview.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          IconlyBold.star,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 3.w),
                        if (rating > 0)
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyle.body(
                              color: AppColors.appTitleColor,
                            ),
                          ),
                        if (reviewText.isNotEmpty) ...[
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              '($reviewText)',
                              style: AppTextStyle.body(
                                color: AppColors.appDescriptionColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (price.isNotEmpty)
                    Text(
                      "₹$price",
                      style: AppTextStyle.title(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // if (sellerLevel.isNotEmpty) ...[
                  //   SizedBox(height: 6.h),
                  //   RichText(
                  //     text: TextSpan(
                  //       text: "Seller Level - ",
                  //       style: AppTextStyle.body(
                  //         color: AppColors.appTitleColor,
                  //       ),
                  //       children: [
                  //         TextSpan(
                  //           text: sellerLevel,
                  //           style: AppTextStyle.body(
                  //             color: AppColors.appDescriptionColor,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
