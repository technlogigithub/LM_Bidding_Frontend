import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';
import '../core/app_constant.dart';
import '../core/app_textstyle.dart';
import '../models/static models/participation_order.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../view/Participate_screens/participate_details_screen.dart';
import '../view/client orders/client_order_details.dart';
import '../view/profile_screens/My Posts/Post_Details_screen.dart';
import '../widget/custom_banner_with_video.dart';
import 'package:get/get.dart';

class MypostListCustomWidget extends StatelessWidget {
  final Rx<GetPostListResponseModel?> model;
  final String statusValue;
  final VoidCallback? onItemTap;
  final RxBool isLoading;

  const MypostListCustomWidget({
    super.key,
    required this.model,
    required this.statusValue,
    this.onItemTap,
    required this.isLoading,
  });

  // Convert API model to ParticipationOrder list
  List<ParticipationOrder> _convertModelToList(
    GetPostListResponseModel? model,
  ) {
    if (model?.result == null || model!.result!.isEmpty) {
      return [];
    }

    return model.result!.map((result) {
      // Parse countdown duration from countdown_dt
      Duration countdownDuration = Duration.zero;
      if (result.postHeader?.countdownDt != null) {
        try {
          // Parse the date string (format: "2025-12-15 23:15:45")
          final countdownStr = result.postHeader!.countdownDt!.trim();

          // Handle different date formats
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
            countdownDuration = Duration.zero;
          } else {
            countdownDuration = difference;
          }

          print('📅 Countdown Calculation:');
          print('   API Date: $countdownDateTime');
          print('   Current Date: $now');
          print('   Difference: $difference');
          print('   Duration: $countdownDuration');
        } catch (e) {
          print(
            '❌ Error parsing countdown_dt: ${result.postHeader?.countdownDt} - $e',
          );
          countdownDuration = Duration.zero;
        }
      }

      // Convert postBody to Map for dynamic fields
      Map<String, dynamic> postBodyMap = {};
      if (result.postBody != null) {
        postBodyMap = result.postBody!.toJson();
        // Remove null values
        postBodyMap.removeWhere((key, value) => value == null);
      }

      return ParticipationOrder(
        orderId: result.postHeader?.postId ?? '',
        sellerName: result.postHeader?.s2 ?? '',
        orderDate: result.postHeader?.s1 ?? '',
        title: result.postBody?.title ?? '',
        duration: result.postBody?.s2 ?? '',
        amount: result.postBody?.price ?? '0.00',
        status: statusValue,
        countdownDuration: countdownDuration,
        postBodyData: postBodyMap.isNotEmpty ? postBodyMap : null,
        mediaList: result.media, // Store media list
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return _buildShimmerList();
      }

      final items = _convertModelToList(model.value);

      if (items.isEmpty) {
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

      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildOrderCard(context, item),
          );
        },
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
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
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

  // Real Order Card
  Widget _buildOrderCard(BuildContext context, ParticipationOrder item) {
    return GestureDetector(
      onTap: onItemTap ?? () => const PostDetailsScreen().launch(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 Order ID + Timer

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Post ID: ${item.orderId}",
            //       style: AppTextStyle.title(fontWeight: FontWeight.w700),
            //     ),
            //     SlideCountdownSeparated(
            //       duration: item.countdownDuration,
            //       decoration: BoxDecoration(
            //         color: AppColors.appColor,
            //         borderRadius: BorderRadius.circular(4),
            //       ),
            //     ),
            //   ],
            // ),

            // 📸 Media (Images/Videos)
            if (item.mediaList != null && item.mediaList!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMediaViewer(item.mediaList!),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${item.orderId}",
                    style: AppTextStyle.title(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: 8),

                SlideCountdownSeparated(
                  duration: item.countdownDuration,
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
              " ${item.sellerName}  |  ${item.orderDate}",
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),

            const SizedBox(height: 12),

            Divider(),
            const SizedBox(height: 12),

            // Dynamic post_body fields from API
            if (item.postBodyData != null && item.postBodyData!.isNotEmpty)
              ...item.postBodyData!.entries.map((entry) {
                // Skip empty or null values
                final value = entry.value?.toString().trim() ?? '';
                if (value.isEmpty || value == 'null') {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _betterInfoRow(
                    entry.key,
                    value,
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  // --- Reusable Cleaner Row (No Icons) ---
  Widget _betterInfoRow(
    String key,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key
        // Text(
        //   "$key : ",
        //   style: AppTextStyle.description(color: AppColors.appDescriptionColor),
        // ),

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
