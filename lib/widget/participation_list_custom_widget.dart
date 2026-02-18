import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../core/app_constant.dart';
import '../core/app_textstyle.dart';
import '../core/app_constant.dart';
import '../models/Order/my_order_list_model.dart';
import '../view/client orders/client_order_details.dart';
import 'custom_banner_with_video.dart';
import 'form_widgets/app_button.dart';

class ParticipationCardUiModel {
  final String orderId;
  final String? countdownDt;
  final String? date;
  final String? title;
  final List<dynamic>? media; // Added media field
  final Map<String, dynamic> dynamicDetails; // Changed from fixed fields to dynamic map
  final List<ActionButton>? actionButtons;
  final String? nextPageName;
  final String? nextPageApiEndpoint;

  ParticipationCardUiModel({
    required this.orderId,
    this.countdownDt,
    this.date,
    this.title,
    this.media,
    required this.dynamicDetails,
    this.actionButtons,
    this.nextPageName,
    this.nextPageApiEndpoint,
  });
}

class ParticipationListCustomWidget extends StatelessWidget {
  final List<ParticipationCardUiModel> items;
  final Function(ParticipationCardUiModel)? onItemTap;
  final RxBool isLoading;

  const ParticipationListCustomWidget({
    super.key,
    required this.items,
    this.onItemTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : ListView.builder(
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
      ),
    );
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

  Widget _buildOrderCard(BuildContext context, ParticipationCardUiModel item) {
    return GestureDetector(
      onTap: () => onItemTap?.call(item),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: context.width(),
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(8.0),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.media != null && item.media!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMediaViewer(item.media!),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.title}',
                  style: AppTextStyle.title(fontWeight: FontWeight.bold),
                ),
                if (item.countdownDt != null && item.countdownDt!.isNotEmpty)
                  Builder(
                    builder: (context) {
                      String? countdownStr = item.countdownDt;
                      Duration remaining = Duration.zero;

                      if (countdownStr != null && countdownStr.isNotEmpty) {
                        try {
                           // Try parsing manually first if format is known (e.g. HH:mm:ss or similar), 
                           // otherwise DateTime.parse expects ISO 8601 usually.
                           // Assuming countdownDt is absolute date string for now.
                          final target = DateTime.tryParse(countdownStr);
                           if (target != null) {
                             final now = DateTime.now();
                             final diff = target.difference(now);
                             if (!diff.isNegative) {
                               remaining = diff;
                             }
                           } else {
                              // If it's a duration string like "3 days", logic would be different.
                              // For now, if parsing fails, remaining is zero.
                           }
                        } catch (e) {
                          debugPrint("Error parsing countdown date: $e");
                        }
                      }

                      if (remaining.inSeconds > 0) {
                        return SlideCountdownSeparated(
                          duration: remaining,
                          separatorType: SeparatorType.symbol,
                          separatorStyle: AppTextStyle.body(color: Colors.transparent),
                          decoration: BoxDecoration(
                            color: AppColors.appButtonColor,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10.0),

            // Date
            // if (item.date != null)
            //  Text("${item.date}",style: AppTextStyle.description(color: AppColors.appDescriptionColor),),
            // const SizedBox(height: 8.0),
            Divider(thickness: 1.0, color: AppColors.appMutedColor, height: 1.0),
            const SizedBox(height: 8.0),

            // Dynamic Details Section
            ...item.dynamicDetails.entries.map((entry) {
              if (entry.value != null && entry.value.toString().isNotEmpty) {
                 // Format key: "payment_status" -> "Payment Status"
                String label = entry.key.split('_').map((word) => word.capitalizeFirstLetter()).join(' ');
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildInfoRow(label, entry.value.toString()),
                );
              }
              return const SizedBox.shrink();
            }).toList(),

            if (item.actionButtons != null && item.actionButtons!.isNotEmpty) ...[
               const SizedBox(height: 10.0),
              _buildActionButtons(item.actionButtons!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {int maxLines = 1}) {
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMediaViewer(List<dynamic> mediaList) {
    // Convert Media list to format expected by CustomBannerWithVideo
    final mediaItems = mediaList.map((media) {
      // Check if media is a Map (from JSON) or an object
      String type = 'image';
      String url = '';

      if (media is Map) {
         type = media['media_type'] ?? 'image';
         url = media['url'] ?? '';
      } 
      // Add other checks if media can be a class

      return {
        'type': type, 
        'url': url,
        'redirectUrl': null, 
      };
    }).toList();

    // Filter out invalid items
    mediaItems.removeWhere((item) => (item['url'] as String).isEmpty);

    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200, // Explicit height constraint
      child: CustomBannerWithVideo(
        mediaItems: mediaItems,
        height: 200.0,
        width: double.infinity,
        borderRadius: 8.0,
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
      ),
    );
  }

  Widget _buildActionButtons(List<ActionButton> buttons) {
    List<Widget> buttonWidgets = [];
    int i = 0;
    while (i < buttons.length) {
      if (i + 1 < buttons.length) {
        // Pair
        buttonWidgets.add(
          Row(
            children: [
              Expanded(
                child: _buildSingleButton(buttons[i]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSingleButton(buttons[i + 1]),
              ),
            ],
          ),
        );
        i += 2;
      } else {
        // Single (Remainder)
        buttonWidgets.add(_buildSingleButton(buttons[i]));
        i++;
      }
      
      // Add spacing between rows
      if (i < buttons.length) {
        buttonWidgets.add(const SizedBox(height: 10));
      }
    }
    
    return Column(
      children: buttonWidgets,
    );
  }

  Widget _buildSingleButton(ActionButton button) {
    return CustomButton(
      onTap: () {
        // Handle button tap
        print("Tapped ${button.label}");
      },
      text: button.label ?? '',
    );
  }
}