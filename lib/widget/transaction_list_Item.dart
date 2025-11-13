import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_color.dart';
import '../../core/app_images.dart';
import '../core/app_constant.dart';
import '../models/static models/transaction_data.dart';

class TransactionListItem extends StatelessWidget {
  final List<TransactionData> transactions;

  const TransactionListItem({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 10.h),
      itemBuilder: (context, index) => _buildTransactionTile(transactions[index]),
    );
  }

  Widget _buildTransactionTile(TransactionData item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.kBorderColorTextField),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkWhite,
              blurRadius: 4.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 10.w,
          leading: Container(
            height: 44.r,
            width: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppImage.userIcon),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(
              color: AppColors.neutralColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          subtitle: Text(
            item.date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kLightNeutralColor, fontSize: 12.sp),
          ),
          trailing: Text(
            '${item.isDeposit ? '+' : '-'}₹ ${item.amount.abs().toStringAsFixed(0)}',
            style: kTextStyle.copyWith(
              color: item.isDeposit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}