import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_constant.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:libdding/view/seller screen/seller authentication/seller_log_in.dart';
import 'package:libdding/widget/button_global.dart';
import 'package:libdding/widget/custom_navigator.dart';

class CustomSuccessDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? nextPageName;
  final String? nextPageViewType;
  final String? nextPageApiEndpoint;
  final String? nextPageTitle;
  final dynamic design;

  const CustomSuccessDialog({
    super.key,
    this.title,
    this.description,
    this.nextPageName,
    this.nextPageViewType,
    this.nextPageApiEndpoint,
    this.nextPageTitle,
    this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/success.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title ?? 'Congratulations!',
            textAlign: TextAlign.center,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,
            ).copyWith(fontSize: 22),
          ),
          const SizedBox(height: 15),
          Text(
            description ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          const SizedBox(height: 30),
          ButtonGlobalWithoutIcon(
            buttontext: 'Done',
            buttonDecoration: kButtonDecoration.copyWith(
              color: AppColors.appButtonColor,
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              if (nextPageName != null && nextPageName!.isNotEmpty) {
                Get.back(); // Close dialog
                CustomNavigator.navigate(nextPageName, arguments: AppMenuItem(
                  nextPageName: nextPageName,
                  nextPageApiEndpoint: nextPageApiEndpoint,
                  nextPageViewType: nextPageViewType,
                  title: nextPageTitle,
                  design: design,
                ));
              } else {
                Get.back(); // Close dialog
                // Default fallback
                isFreelancer 
                    ? Get.offAll(() => const SellerLogIn()) 
                    : Get.offAll(() => LoginScreen());
              }
            },
            buttonTextColor: AppColors.appButtonTextColor,
          ),
        ],
      ),
    );
  }
}
