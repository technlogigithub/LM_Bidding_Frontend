import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';
import '../models/static models/participation_detail_model.dart';

class ParticipationDetailCard extends StatelessWidget {
  final ParticipationDetailModel data;
  final bool isLoading;

  const ParticipationDetailCard({super.key, required this.data, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer();

    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all(color: AppTextStyle.kBorderColorTextField),
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
                  Text('Order ID #${data.orderId}', style: AppTextStyle.title(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.w),
                  SlideCountdownSeparated(
                    duration: data.countdownDuration,
                    separatorType: SeparatorType.symbol,
                    separatorStyle: AppTextStyle.body(color: Colors.transparent),
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
          // Row(
          //   children: [
          //     Text(
          //       'Order ID #${data.orderId}',
          //       style: AppTextStyle.kTextStyle.copyWith(
          //         color: AppTextStyle.kNeutralColor,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const Spacer(),
          //     SlideCountdownSeparated(
          //       duration: data.countdownDuration,
          //       separatorType: SeparatorType.symbol,
          //       separatorStyle: AppTextStyle.kTextStyle.copyWith(color: Colors.transparent),
          //       decoration: BoxDecoration(
          //         color: AppTextStyle.kPrimaryColor,
          //         borderRadius: BorderRadius.circular(3.0),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10.0),

          // Seller & Date
          RichText(
            text: TextSpan(
              text: 'Seller: ',
              style: AppTextStyle.description(color: AppColors.appDescriptionColor),
              children: [
                TextSpan(
                  text: data.sellerName,
                  style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: ' | ',
                  style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                ),
                TextSpan(
                  text: data.orderDate,
                  style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                ),
              ],
            ),
          ),
          // RichText(
          //   text: TextSpan(
          //     text: 'Seller: ',
          //     style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kLightNeutralColor),
          //     children: [
          //       TextSpan(
          //         text: data.sellerName,
          //         style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kNeutralColor),
          //       ),
          //       TextSpan(
          //         text: '  |  ',
          //         style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kLightNeutralColor),
          //       ),
          //       TextSpan(
          //         text: data.orderDate,
          //         style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kLightNeutralColor),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 8.0),
          Divider(thickness: 1.0, color: AppColors.appMutedColor, height: 1.0),
          const SizedBox(height: 8.0),

          // Info Rows
          _buildInfoRow('Title', data.title, maxLines: 2),
          const SizedBox(height: 8.0),
          _buildInfoRow(
            'Service Info',
            data.serviceInfo,
            customValue: ReadMoreText(
              data.serviceInfo,
              style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.w400),
              trimLines: 3,
              colorClickableText: AppColors.appColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: '..Read more',
              trimExpandedText: '..Read less',
            ),
          ),
          const SizedBox(height: 8.0),
          _buildInfoRow('Duration', data.duration),
          const SizedBox(height: 8.0),
          _buildInfoRow('Amount', '₹ ${data.amount}'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Status', data.status, valueColor: AppColors.appTitleColor),

          const SizedBox(height: 15.0),
          Text(
            'Order Details',
            style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          _buildInfoRow('Revisions', data.revisions),
          const SizedBox(height: 8.0),
          _buildInfoRow('File', data.fileTypes),
          const SizedBox(height: 8.0),
          _buildInfoRow('Resolution', data.resolution),
          const SizedBox(height: 8.0),
          _buildInfoRow('Package', data.package),

          const SizedBox(height: 15.0),
          Text(
            'Order Summary',
            style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          _buildInfoRow('Subtotal', '₹ ${data.subtotal}'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Service', '₹ ${data.serviceFee}'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Total', '₹ ${data.total}'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Delivery date', data.deliveryDate),

          // Delivery Section - Only if Completed
          if (data.showDeliverySection) ...[
            const SizedBox(height: 15.0),
            Text(
              'Delivery File From Seller',
              style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            Container(

              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                gradient:AppColors.appPagecolor ,
                borderRadius: BorderRadius.circular(8.0),
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
                // border: Border.all(color: AppColors.appTitleColor),
              ),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.appMutedColor),
                  child: Icon(IconlyBold.document, color: AppColors.appMutedTextColor),
                ),
                title: Text(data.deliveryFileName, style: AppTextStyle.description(color: AppColors.appTitleColor, fontWeight: FontWeight.bold), maxLines: 1),
                subtitle: Text(
                  data.deliveryFileSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.body(color: AppColors.appDescriptionColor),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.appMutedColor),
                  child: Icon(FeatherIcons.download, color: AppColors.appMutedTextColor),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Image',
              style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 130.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                image: DecorationImage(image: AssetImage(data.deliveryImagePath), fit: BoxFit.cover),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {int maxLines = 1, Color? valueColor, Widget? customValue}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Text(':', style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
              const SizedBox(width: 10.0),
              Flexible(
                child:
                    customValue ??
                    Text(
                      value,
                      style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.w400),
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor,
      highlightColor: AppColors.appMutedTextColor,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(color: AppTextStyle.kBorderColorTextField),
          // boxShadow: const [
          //   BoxShadow(
          //     color: AppTextStyle.kDarkWhite,
          //     spreadRadius: 4.0,
          //     blurRadius: 4.0,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Countdown
            Row(children: [_shimmerBox(120, 16), const Spacer(), _shimmerBox(80, 24)]),
            const SizedBox(height: 10),

            // Seller & Date
            _shimmerBox(200, 14),
            const SizedBox(height: 8),
            _shimmerBox(double.infinity, 1), // Divider
            const SizedBox(height: 8),

            // Info Rows (Repeat 15 times as in real card)
            ...List.generate(
              15,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _shimmerBox(60, 14)),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          _shimmerBox(20, 14),
                          const SizedBox(width: 10),
                          Expanded(child: _shimmerBox(double.infinity, 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Delivery Section (only if completed)
            const SizedBox(height: 15),
            _shimmerBox(150, 16), // "Delivery File From Seller"
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.appTitleColor),
              ),
              child: Row(
                children: [
                  _shimmerBox(40, 40), // Icon
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_shimmerBox(150, 14), const SizedBox(height: 4), _shimmerBox(100, 12)]),
                  ),
                  _shimmerBox(40, 40), // Download icon
                ],
              ),
            ),
            const SizedBox(height: 10),
            _shimmerBox(80, 16), // "Image"
            const SizedBox(height: 10),
            _shimmerBox(100, 70), // Image placeholder
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height) {
    return Container(width: width, height: height, color: AppColors.appMutedColor);
  }
}
