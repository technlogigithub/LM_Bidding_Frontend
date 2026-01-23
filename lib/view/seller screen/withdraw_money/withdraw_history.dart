import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_textstyle.dart';
import '../seller popUp/seller_popup.dart';

class WithDrawHistory extends StatefulWidget {
  const WithDrawHistory({super.key});

  @override
  State<WithDrawHistory> createState() => _WithDrawHistoryState();
}

class _WithDrawHistoryState extends State<WithDrawHistory> {
  //__________withdraw_amount_popup________________________________________________
  void withdrawHistoryPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const WithdrawHistoryPopUp(),
            );
          },
        );
      },
    );
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
          'Withdraw Money',
          style: AppTextStyle.title(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10.0),
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => withdrawHistoryPopUp(),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(6.0),
                              gradient: AppColors.appPagecolor,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Withdrawal Completed',
                                      style:AppTextStyle.description(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${AppStrings.currencySign} 5,000',
                                      style:AppTextStyle.description(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '10 Jun 2023',
                                  style: AppTextStyle.body(color: AppColors.appDescriptionColor),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(6.0),
                            gradient: AppColors.appPagecolor,
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Withdrawal Initiated',
                                    style:AppTextStyle.description(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${AppStrings.currencySign} 5,000',
                                    style:AppTextStyle.description(color: AppColors.appFail, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '10 Jun 2023',
                                style:AppTextStyle.body(color: AppColors.appDescriptionColor),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
