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
import '../view/client orders/client_order_details.dart';

class ParticipationListCustomWidget extends StatelessWidget {
  final List<ParticipationOrder> items;
  final VoidCallback? onItemTap;
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
      onTap: onItemTap ?? () => const ClientOrderDetails().launch(context),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: context.width(),
        decoration: BoxDecoration(
       gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(color: AppColors.appMutedColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.appMutedColor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 10),
              // blurRadius: 1,
              // spreadRadius: 1,
              // offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Countdown
            SingleChildScrollView(

              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Order ID #${item.orderId}',
                      style: AppTextStyle.title(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10.w),
                    SlideCountdownSeparated(
                      duration: item.countdownDuration,
                      separatorType: SeparatorType.symbol,
                      separatorStyle:
                      AppTextStyle.body(color: Colors.transparent),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appMutedColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 15),
                            // blurRadius: 1,
                            // spreadRadius: 1,
                            // offset: Offset(0, 6),
                          ),
                        ],
                        color: AppColors.appColor,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  ],
                ),
              ),

            ),
            const SizedBox(height: 10.0),

            // Seller & Date
            RichText(
              text: TextSpan(
                text: 'Seller: ',
                style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                children: [
                  TextSpan(
                    text: item.sellerName,
                    style: AppTextStyle.title(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '  |  ',
                    style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                  ),
                  TextSpan(
                    text: item.orderDate,
                    style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
             Divider(thickness: 1.0, color: AppColors.appMutedColor, height: 1.0),
            const SizedBox(height: 8.0),

            // Title
            _buildInfoRow('Title', item.title, maxLines: 2),
            const SizedBox(height: 8.0),

            // Duration
            _buildInfoRow('Duration', item.duration),
            const SizedBox(height: 8.0),

            // Amount
            _buildInfoRow('Amount', '$currencySign ${item.amount}'),
            const SizedBox(height: 8.0),

            // Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(':',
                          style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                      const SizedBox(width: 10.0),
                      Flexible(
                        child: Text(
                          item.status,
                          style: AppTextStyle.title(color: AppColors.appTitleColor,fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: AppTextStyle.description(color: AppColors.appDescriptionColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Text(':',
                  style:AppTextStyle.description(color: AppColors.appDescriptionColor)),
              const SizedBox(width: 10.0),
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyle.title(color: AppColors.appTitleColor,fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}