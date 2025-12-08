import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';

class DepositCard extends StatelessWidget {
  final String title;
  final String image;
  final double amount;
  final String date;
  final String status;

  const DepositCard({
    super.key,
    required this.title,
    required this.image,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        gradient: AppColors.appPagecolor, // ✅ SAME GRADIENT FOR ALL
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
      child: ListTile(
        horizontalTitleGap: 10,
        contentPadding: EdgeInsets.zero,

        leading: Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),

        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // ✅ prevents overflow
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 8), // ✅ spacing between title & amount

            Text(
              '$currencySign${amount.toStringAsFixed(2)}',
              maxLines: 1,
              style: AppTextStyle.description(
                color: AppColors.appTitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),


        subtitle: Row(
          children: [
            Text(
              date,
              style: AppTextStyle.body(
                color: AppColors.appDescriptionColor,

              ),
            ),
            const Spacer(),
            Text(
              status,
              style: AppTextStyle.body(color: AppColors.appButtonColor),
            ),
          ],
        ),
      ),
    );
  }
}
