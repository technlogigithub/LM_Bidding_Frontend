import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/app_constant.dart';

class SellerTransaction extends StatefulWidget {
  const SellerTransaction({super.key});

  @override
  State<SellerTransaction> createState() => _SellerTransactionState();
}

class _SellerTransactionState extends State<SellerTransaction> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        backgroundColor: AppColors.appWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Transaction',
          style: kTextStyle.copyWith(color:  AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Transactions',
                      style: kTextStyle.copyWith(color:  AppColors.neutralColor, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: kTextStyle.copyWith(color:  AppColors.neutralColor),
                      ),
                    ),
                    Icon(
                      FeatherIcons.chevronDown,
                      color:  AppColors.textgrey,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ListView.builder(
                    itemCount: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 10.0),
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color:  AppColors.kBorderColorTextField),
                            boxShadow: [
                              BoxShadow(
                                color:  AppColors.darkWhite,
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 10,
                            leading: Container(
                              height: 44,
                              width: 44,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage('images/usericon.png'), fit: BoxFit.cover),
                              ),
                            ),
                            title: Text(
                              'Marvin McKinney',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStyle.copyWith(color:  AppColors.neutralColor, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '10 Jun 2023',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStyle.copyWith(color: AppColors.textgrey),
                            ),
                            trailing: Text(
                              '${AppStrings.currencySign} 5,000',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
