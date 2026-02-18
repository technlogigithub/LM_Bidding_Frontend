import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../core/app_constant.dart';
import '../core/app_textstyle.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../view/profile_screens/My Posts/Post_Details_screen.dart';
import '../widget/custom_banner_with_video.dart';
import 'custom_auto_image_handle.dart';
import '../core/app_imagetype_helper.dart';

class MypostListCustomWidget extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final String statusValue;
  final Function(String)? onItemTap;
  final RxBool isLoading;
  final String? bgColor;
  final String? bgImg;

  const MypostListCustomWidget({
    super.key,
    required this.model,
    required this.statusValue,
    this.onItemTap,
    required this.isLoading,
    this.bgColor,
    this.bgImg,
  });

  // Calculate countdown duration from countdown_dt
  Duration _calculateCountdownDuration(String? countdownDt) {
    if (countdownDt == null || countdownDt.isEmpty) {
      return Duration.zero;
    }

    try {
      // Parse the date string (format: "2025-12-15 23:15:45")
      final countdownStr = countdownDt.trim();
      DateTime countdownDateTime;

      if (countdownStr.contains(' ')) {
        // Format: "2025-12-15 23:15:45"
        countdownDateTime = DateTime.parse(countdownStr);
      } else {
        // Try other formats if needed
        countdownDateTime = DateTime.parse(countdownStr);
      }

      // Get current date and time
      final now = DateTime.now();

      // Calculate difference
      final difference = countdownDateTime.difference(now);

      // Only set if future date, otherwise Duration.zero
      if (difference.isNegative) {
        return Duration.zero;
      } else {
        return difference;
      }
    } catch (e) {
      print('❌ Error parsing countdown_dt: $countdownDt - $e');
      return Duration.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return _buildShimmerList();
      }

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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (_, index) {
                final result = results[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildOrderCard(context, result),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // Shimmer List
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: _buildShimmerCard(),
        ),
      ),
    );
  }

  // Shimmer Card
  Widget _buildShimmerCard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: kBorderColorTextField),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 120, height: 16, color: Colors.white),
              const Spacer(),
              Container(width: 80, height: 24, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Container(width: 200, height: 14, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.white),
          const SizedBox(height: 8),
          _shimmerRow(),
          const SizedBox(height: 8),
          _shimmerRow(),
          const SizedBox(height: 8),
          _shimmerRow(),
          const SizedBox(height: 8),
          _shimmerRow(),
        ],
      ),
    );
  }

  Widget _shimmerRow() {
    return Row(
      children: [
        Container(width: 60, height: 14, color: Colors.white),
        const SizedBox(width: 10),
        Container(width: 20, height: 14, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 14, color: Colors.white)),
      ],
    );
  }

  // Real Order Card - works directly with Result
  Widget _buildOrderCard(BuildContext context, Result result) {
    // Calculate countdown duration
    final countdownDuration = _calculateCountdownDuration(
      result.info?['countdownDt'],
    );

    // Get order ID - use title or s2 as fallback
    final orderId = result.info?['title'] ?? '';

    // Get seller name
    final sellerName = result.info?['1'] ?? '';

    // Get order date
    final orderDate = result.info?['2'] ?? '';

    return GestureDetector(
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(result.hidden?.ukey ?? '');
        } else {
           const PostDetailsScreen().launch(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.appMutedColor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Media (Images/Videos)
            if (result.media != null && result.media!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMediaViewer(result.media!),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    orderId,
                    style: AppTextStyle.title(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                SlideCountdownSeparated(
                  duration: countdownDuration,
                  decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 👤 Seller & Date
            Text(
              " $sellerName  |  $orderDate",
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),

            const SizedBox(height: 12),

            Divider(),
            const SizedBox(height: 12),

            // Dynamic fields from details only
            if (result.details != null)
              ...result.details!.toJson().entries.map((entry) {
                // Skip empty or null values
                final value = entry.value?.toString().trim() ?? '';
                if (value.isEmpty || value == 'null') {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _betterInfoRow(entry.key, value),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  // --- Reusable Cleaner Row (No Icons) ---
  Widget _betterInfoRow(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 5),

        // Value
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.title(
              fontWeight: FontWeight.w500,
              color: AppColors.appTitleColor,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  // --- Media Viewer Widget using CustomBannerWithVideo ---
  Widget _buildMediaViewer(List<Media> mediaList) {
    // Convert Media list to format expected by CustomBannerWithVideo
    final mediaItems = mediaList.map((media) {
      return {
        'type': media.mediaType ?? 'image', // 'image' or 'video'
        'url': media.url ?? '',
        'redirectUrl': null, // Optional redirect URL
      };
    }).toList();

    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomBannerWithVideo(
      mediaItems: mediaItems,
      height: 200.0,
      width: double.infinity,
      borderRadius: 8.0,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
    );
  }
}
