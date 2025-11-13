import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/transaction/transaction_controller.dart';
import '../../core/app_string.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../widget/transaction_list_item.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.darkWhite,
        appBar: AppBar(
          backgroundColor: AppColors.darkWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.neutralColor),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.transaction,
                style: kTextStyle.copyWith(
                  color: kNeutralColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Obx(() => Text(
                '${controller.transactions.length} Transactions',
                style: kTextStyle.copyWith(
                  color: kLightNeutralColor,
                  fontSize: 12.sp,
                ),
              )),
            ],
          ),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () => controller.pickDate(context),   // moved to controller
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.appColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Obx(() => Text(
                      controller.formattedDate,
                      style: kTextStyle.copyWith(
                        color: AppColors.appColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    )),
                    SizedBox(width: 4.w),
                    Icon(FeatherIcons.chevronDown,
                        size: 18.r, color: AppColors.appColor),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.02.sh),
              Obx(() => TransactionListItem(
                transactions: controller.transactions.toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}