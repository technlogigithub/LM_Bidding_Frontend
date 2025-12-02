import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_constant.dart';
import '../../../widget/button_global.dart';
import '../seller popUp/seller_popup.dart';

class SellerWithdrawMoney extends StatefulWidget {
  const SellerWithdrawMoney({super.key});

  @override
  State<SellerWithdrawMoney> createState() => _SellerWithdrawMoneyState();
}

class _SellerWithdrawMoneyState extends State<SellerWithdrawMoney> {
  //__________gateway____________________________________________________________
  DropdownButton<String> getGateway() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in gateWay) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedGateWay,
      style: kTextStyle.copyWith(color: AppColors.subTitleColor),
      onChanged: (value) {
        setState(() {
          selectedGateWay = value!;
        });
      },
    );
  }

  //__________withdraw_amount_popup________________________________________________
  void withdrawAmountPopUp() {
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
              child: const WithdrawAmountPopUp(),
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
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Withdraw Money',
          style: kTextStyle.copyWith(color:  AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
          buttontext: 'Submit',
          buttonDecoration: kButtonDecoration.copyWith(
            color: AppColors.appColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            withdrawAmountPopUp();
          },
          buttonTextColor: AppColors.appWhite),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.appWhite,
                          border: Border.all(color: AppColors.kBorderColorTextField),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.currencySign} 220',
                              style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Pending Clearance',
                              style: kTextStyle.copyWith(color: AppColors.subTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.appWhite,
                          border: Border.all(color: AppColors.kBorderColorTextField),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.currencySign} 7,000',
                              style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Withdrawal Available ',
                              maxLines: 1,
                              style: kTextStyle.copyWith(color: AppColors.subTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Withdraw Method',
                  style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return InputDecorator(
                      decoration: kInputDecoration.copyWith(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(color: AppColors.kBorderColorTextField, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(7.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Select Gateway',
                        labelStyle: kTextStyle.copyWith(color: AppColors.neutralColor),
                      ),
                      child: DropdownButtonHideUnderline(child: getGateway()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.neutralColor,
                  textInputAction: TextInputAction.next,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Amount',
                    labelStyle: kTextStyle.copyWith(color: AppColors.neutralColor),
                    hintText: '\$500',
                    hintStyle: kTextStyle.copyWith(color: AppColors.textgrey),
                    focusColor: AppColors.neutralColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
