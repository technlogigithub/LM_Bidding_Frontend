import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';

import '../../controller/transaction/transaction_controller.dart';
import '../../core/app_string.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../widget/form_widgets/custom_date_time.dart';
import '../../widget/transaction_list_item.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          toolbarHeight: 80,
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.transaction,
                style: AppTextStyle.title(
                  color: AppColors.appTextColor,
                ),
              ),
              Obx(
                    () => Text(
                  '${controller.transactions.length} Transactions',
                  style:
                  AppTextStyle.description(color: AppColors.appTextColor),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => _pick(context),
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.appMutedColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Obx(
                          () => Text(
                        controller.formattedDate,
                        style: AppTextStyle.body(
                          color: AppColors.appMutedTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      FeatherIcons.chevronDown,
                      size: 18.r,
                      color: AppColors.appMutedTextColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.02.sh),
                Obx(
                      () => TransactionListItem(
                    transactions: controller.transactions.toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ FIXED DATE & TIME PICKER
  Future<void> _pick(BuildContext context) async {
    final currentDate = controller.selectedDate.value;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => themedPicker(context, child!),
    );

    if (date == null) return;

    // ✅ Update only date (no time involved)
    controller.updateDate(date);
  }

}
