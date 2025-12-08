import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';

import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_deposit_card.dart';
import '../../widget/form_widgets/custom_date_time.dart';



class DepositHistory extends StatefulWidget {
  const DepositHistory({super.key});

  @override
  State<DepositHistory> createState() => _DepositHistoryState();
}

class _DepositHistoryState extends State<DepositHistory> {

  /// ✅ Make it NORMAL DateTime (since you are NOT using GetX here)
  DateTime selectedDate = DateTime.now();

  /// ✅ Correct pickDate using your themedPicker
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) => themedPicker(context, child!),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // ✅ Call your filter API here if needed
      // filterTransactionsByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),

        /// ❌ Removed Obx (you were not using Rx here)
        title: Text(
          'Add Deposit',
          style: AppTextStyle.title(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            onTap: () {},
            text: "Submit",
          ),
        ),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),

              /// ✅ FIXED DATE PICKER ROW
              Row(
                children: [
                  Text(
                    'Deposit',
                    style: AppTextStyle.title(),
                  ),
                  const Spacer(),

                  GestureDetector(
                    onTap: () => pickDate(context),
                    child: Row(
                      children: [
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: AppTextStyle.body(),
                        ),
                        Icon(
                          FeatherIcons.chevronDown,
                          color: AppColors.appBodyTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const DepositCard(
                title: "PayPal",
                image: "assets/images/paypal2.png",
                amount: 5000,
                date: "24 Jun 2023",
                status: "Paid",
              ),

              const SizedBox(height: 20),

              const DepositCard(
                title: "Credit or Debit Card",
                image: "assets/images/creditcard.png",
                amount: 5000,
                date: "24 Jun 2023",
                status: "Paid",
              ),

              const SizedBox(height: 20),

              const DepositCard(
                title: "Bkash",
                image: "assets/images/bkash2.png",
                amount: 5000,
                date: "24 Jun 2023",
                status: "Paid",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

