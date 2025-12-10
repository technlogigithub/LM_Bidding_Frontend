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
import '../models/static models/participation_order.dart';
import '../view/Participate_screens/participate_details_screen.dart';
import '../view/client orders/client_order_details.dart';
import '../view/profile_screens/My Posts/Post_Details_screen.dart';

class MypostListCustomWidget extends StatelessWidget {
  final List<ParticipationOrder> items;
  final VoidCallback? onItemTap;
  final RxBool isLoading;

  const MypostListCustomWidget({
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
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔵 Order ID + Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post ID: ${item.orderId}",
                  style: AppTextStyle.title(fontWeight: FontWeight.w700),
                ),
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
              "Create Post By : ${item.sellerName}  |  ${item.orderDate}",
              style: AppTextStyle.description(color: AppColors.appDescriptionColor),
            ),

            const SizedBox(height: 12),
            Divider(),
            const SizedBox(height: 12),

            // 📝 Service Title
            _betterInfoRow(Icons.edit_note, "Post Name  : ", item.title),

            const SizedBox(height: 10),

            // ⏳ Delivery Time
            _betterInfoRow(Icons.timer_outlined, "Delivery Time : ", item.duration),

            const SizedBox(height: 10),

            // 💰 Price
            _betterInfoRow(Icons.currency_rupee, "Price : ", "$currencySign ${item.amount}"),

            const SizedBox(height: 10),

            // 🟢 Status
            _betterInfoRow(
              Icons.check_circle_outline_rounded,
              "Order Status : ",
              item.status,
            ),
          ],
        ),
      ),
    );
  }

// --- Reusable Cleaner Row ---
  Widget _betterInfoRow(
      IconData icon,
      String label,
      String value, {
        Color? iconColor,
      }) {
    iconColor ??= AppColors.appIconColor; // set default color

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),

        // Key
        Text(
          "$label",
          style: AppTextStyle.description(color: AppColors.appDescriptionColor),
        ),

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
            maxLines: 1,
          ),
        ),
      ],
    );
  }

}