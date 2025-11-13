import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_constant.dart';
import '../seller popUp/seller_popup.dart';

class SellerWithDrawHistory extends StatefulWidget {
  const SellerWithDrawHistory({super.key});

  @override
  State<SellerWithDrawHistory> createState() => _SellerWithDrawHistoryState();
}

class _SellerWithDrawHistoryState extends State<SellerWithDrawHistory> {
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
      backgroundColor: AppColors.darkWhite,
      appBar: AppBar(
        backgroundColor: AppColors.darkWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.neutralColor,),
        title: Text(
          'Withdraw Money',
          style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          width: context.width(),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                              color: AppColors.appWhite,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: AppColors.kBorderColorTextField),
                              boxShadow:  [
                                BoxShadow(
                                  color: AppColors.darkWhite,
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 5),
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
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${AppStrings.currencySign} 5,000',
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '10 Jun 2023',
                                  style: kTextStyle.copyWith(color: AppColors.textgrey),
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
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: AppColors.kBorderColorTextField),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkWhite,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 5),
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
                                    style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${AppStrings.currencySign} 5,000',
                                    style: kTextStyle.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '10 Jun 2023',
                                style: kTextStyle.copyWith(color: AppColors.textgrey),
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
