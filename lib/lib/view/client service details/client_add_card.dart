import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/view/client%20service%20details/requirements.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import '../client popup/client_popup.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {

  //__________Show_Processing_popup________________________________________________
  void showProcessingPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const ProcessingPopUp(),
            );
          },
        );
      },
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isChecked = false;
  String currencySign = '₹';

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
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
          'Add Credit or Debit Card',
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
          buttontext: 'Pay Now ($currencySign${35.50})',
          buttonDecoration: kButtonDecoration.copyWith(borderRadius: BorderRadius.circular(30.0), color: AppColors.appColor),
          onPressed: () {
            setState(() {
              showProcessingPopUp();
              finish(context);
              const Requirements().launch(context);
            });
          },
          buttonTextColor: AppColors.appWhite),
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
                CreditCardWidget(
                  cardType: CardType.mastercard,
                  backgroundImage: 'images/cardbg.png',
                  textStyle: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appWhite,
                    fontSize: 10
                  ),
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: AppColors.appColor,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                ),
                CreditCardForm(
                  formKey: formKey,
                  // Required
                  onCreditCardModelChange: onCreditCardModelChange,
                  // Required
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumber: cardNumber,
                  cvvCode: cvvCode,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  cardHolderName: cardHolderName,
                  expiryDate: expiryDate,
                  // themeColor: AppColors.neutralColor,
                  // textColor: AppColors.neutralColor,
                 inputConfiguration: InputConfiguration(
                   cardNumberDecoration: kInputDecoration.copyWith(
                       labelText: 'Number',
                       hintText: '6037 9975 2941 7165',
                       labelStyle: AppTextStyle.kTextStyle.copyWith(
                         color: AppColors.appTextColor,
                       ),
                       hintStyle: AppTextStyle.kTextStyle.copyWith(
                         color: AppColors.subTitleColor,
                       ),
                       focusColor: AppColors.neutralColor,
                       border: const OutlineInputBorder(),
                       floatingLabelBehavior: FloatingLabelBehavior.always),
                   expiryDateDecoration: kInputDecoration.copyWith(
                     labelStyle:AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.appTextColor,
                     ),
                     hintStyle: AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.subTitleColor,
                     ),
                     focusColor: AppColors.neutralColor,
                     border: const OutlineInputBorder(),
                     labelText: 'Expired Date',
                     hintText: 'XX/XX',
                   ),
                   cvvCodeDecoration: kInputDecoration.copyWith(
                     labelStyle: AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.appTextColor,
                     ),
                     hintStyle: AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.subTitleColor,
                     ),
                     focusColor: AppColors.neutralColor,
                     border: const OutlineInputBorder(),
                     labelText: 'CVV',
                     hintText: 'XXX',
                   ),
                   cardHolderDecoration: kInputDecoration.copyWith(
                     labelStyle: AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.appTextColor,
                     ),
                     hintStyle: AppTextStyle.kTextStyle.copyWith(
                       color: AppColors.subTitleColor,
                     ),
                     focusColor: AppColors.neutralColor,
                     border: const OutlineInputBorder(),
                     labelText: 'Name',
                   ),
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
