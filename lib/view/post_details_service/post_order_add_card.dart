import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import '../client popup/client_popup.dart';
import '../post_details_service/post_requirements_send.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String currencySign = '₹';

  void onCreditCardModelChange(CreditCardModel? model) {
    if (model == null) return;
    setState(() {
      cardNumber = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

  void showProcessingPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: const ProcessingPopUp(),
      ),
    );
  }

  InputDecoration _cardInputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      label: Text(label, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
      hintText: hint,
      hintStyle: AppTextStyle.description(color: AppColors.subTitleColor),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.appBodyTextColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.appBodyTextColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(decoration: BoxDecoration(gradient: AppColors.appbarColor)),
        title: Text(
          'Add Credit or Debit Card',
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Pay Now ($currencySign${35.50})',
          buttonDecoration: kButtonDecoration.copyWith(
            color: AppColors.appButtonColor,
            borderRadius: BorderRadius.circular(30),
          ),
          buttonTextColor: AppColors.appButtonTextColor,
          onPressed: () {
            showProcessingPopUp();
            finish(context);
            const PostRequirementsSendScreen().launch(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CreditCardWidget(
                cardType: CardType.mastercard,
                backgroundImage: 'images/cardbg.png',
                textStyle: AppTextStyle.body(color: AppColors.appButtonTextColor),
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: AppColors.appButtonColor,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (_) {},
              ),
              CreditCardForm(
                formKey: formKey,
                onCreditCardModelChange: onCreditCardModelChange,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                inputConfiguration: InputConfiguration(
                  cardNumberDecoration: _cardInputDecoration(
                    label: 'Number',
                    hint: '6037 9975 2941 7165',
                  ),
                  expiryDateDecoration: _cardInputDecoration(
                    label: 'Expired Date',
                    hint: 'MM/YY',
                  ),
                  cvvCodeDecoration: _cardInputDecoration(
                    label: 'CVV',
                    hint: 'XXX',
                  ),
                  cardHolderDecoration: _cardInputDecoration(
                    label: 'Name',
                    hint: 'Card Holder Name',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
