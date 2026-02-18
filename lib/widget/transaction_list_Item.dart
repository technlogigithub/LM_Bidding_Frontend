import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_color.dart';
import '../../core/app_images.dart';
import '../core/app_constant.dart';
import '../core/app_textstyle.dart';
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
         gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20), // stronger shadow
              blurRadius: 12,     // soft glow
              spreadRadius: 5,    // outer spread
              offset: Offset(0, 4), // down shadow
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8), // top highlight
              blurRadius: 6,
              spreadRadius: -2,
              offset: Offset(0, -2),
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
            style:AppTextStyle.description(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,

            ),
          ),
          subtitle: Text(
            item.date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.body(color: AppColors.appDescriptionColor,),
          ),
          trailing: Text(
            '${item.isDeposit ? '+' : '-'}₹ ${item.amount.abs().toStringAsFixed(0)}',
            style: AppTextStyle.description(
              color: item.isDeposit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}