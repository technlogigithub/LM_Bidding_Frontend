import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import '../../controller/cart/cart_controller.dart';
import '../../models/Post/Get_coupons_model.dart';

class CouponCustomBottomSheet extends StatelessWidget {
  const CouponCustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    
    return Container(
      decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 5.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: AppColors.appMutedColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Text(
          //   "",
          //   style: AppTextStyle.title(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 10.h),
          Obx(() {
            if (controller.couponsResponseModel.value == null ||
                controller.couponsResponseModel.value!.data == null ||
                controller.couponsResponseModel.value!.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    "No coupons available",
                    style: AppTextStyle.body(color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.couponsResponseModel.value!.data!.length,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                final coupon = controller.couponsResponseModel.value!.data![index];
                return _buildCouponCard(coupon);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponsGet coupon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.appMutedColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // // Icon or Discount Box
          // Container(
          //   height: 60.h,
          //   width: 60.w,
          //   decoration: BoxDecoration(
          //     color: AppColors.appButtonColor.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(8.r),
          //   ),
          //   child: Center(
          //     child: Icon(
          //       Icons.local_offer,
          //       color: AppColors.appButtonColor,
          //       size: 30.sp,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 15.w),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.appButtonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.appButtonColor,width: 0.5),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Text(
                      coupon.code ?? '',
                      style: AppTextStyle.description(color: AppColors.appButtonColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  coupon.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.description(),
                ),
                  Builder(builder: (context) {
                     final now = DateTime.now();

                     // 1. Check if Coupon has NOT started yet (Future Start Date)
                     if (coupon.validFrom != null && coupon.validFrom!.isNotEmpty) {
                        try {
                           final startDate = DateTime.parse(coupon.validFrom!);
                           if (startDate.isAfter(now)) {
                              final startDiff = startDate.difference(now);
                              String startText = "";
                              Color startColor = Colors.blue;

                              if (startDiff.inDays > 0) {
                                  startText = "Starts in ${startDiff.inDays} days";
                              } else if (startDiff.inHours > 0) {
                                  startText = "Starts in ${startDiff.inHours} hours";
                              } else if (startDiff.inMinutes > 0) {
                                  startText = "Starts in ${startDiff.inMinutes} minutes";
                              } else {
                                  startText = "Starts shortly";
                              }
                              return Text(
                                startText,
                                style: AppTextStyle.body(color: startColor),
                              );
                           }
                        } catch(e) {
                          // Ignore parse errors
                        }
                     }

                     // 2. If started, show Expiry Status (Existing Logic)
                    if (coupon.validTo == null || coupon.validTo!.isEmpty) return const SizedBox();
                     DateTime? validDate;
                     try {
                        validDate = DateTime.parse(coupon.validTo!);
                     } catch(e) { 
                        return const SizedBox(); 
                     }

                     final diff = validDate.difference(now);
                     String timeText = "";
                     Color color = Colors.red;

                     if (diff.isNegative) {
                       timeText = "Expired";
                       // color = Colors.grey;
                     } else {
                        if (diff.inDays > 0) {
                           timeText = "${diff.inDays} days remaining";
                           // color = Colors.green;
                        } else if (diff.inHours > 0) {
                           timeText = "${diff.inHours} hours remaining";
                           // color = Colors.orange;
                        } else if (diff.inMinutes > 0) {
                           timeText = "${diff.inMinutes} minutes remaining";
                           // color = Colors.red;
                        } else {
                           timeText = "Expiring soon";
                        }
                     }

                     return Text(
                      timeText,
                      style: AppTextStyle.body(),
                    );
                  }),
              ],
            ),
          ),

          // Apply Button
          TextButton(
            onPressed: () {
              // Handle Apply Logic here
              Get.back(result: coupon);
              final controller = Get.find<CartController>();
              controller.couponController.text = coupon.code ?? '';
              controller.appliedCouponCode.value = coupon.code ?? ''; // Trigger UI update
              print(" Coupon Applied: ${controller.couponController.text}");
              // Optionally trigger apply API or update UI
            },
            child: Text(
              "APPLY",
              style: AppTextStyle.body(
                  color: AppColors.appButtonColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
