import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/Otp_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../core/app_textstyle.dart';
import '../../widget/app_image_handle.dart';
import '../../widget/form_widgets/app_button.dart';

class OtpVarificationScreen extends StatelessWidget {
  final String mobile;
  final OtpController controller = Get.put(OtpController());
  static final controllerApp = Get.put(AppSettingsController());

  OtpVarificationScreen({super.key, required this.mobile}) {
    controller.setMobile(mobile); // store mobile in controller
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // needed for gradient
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 180,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // shadow color
                spreadRadius: 2, // how much the shadow spreads
                blurRadius: 6,   // blur effect
                offset: Offset(0, 3), // x, y offset
              ),
            ],
            gradient: AppColors.appbarColor,

          ),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () => Navigator.pop(context),
              //   child: const Padding(
              //     padding: EdgeInsets.only(left: 10.0),
              //     child: Icon(Icons.arrow_back),
              //   ),
              // ),
              Center(
                child: Column(
                  children: [
                    Center(
                      child: UniversalImage(
                        url: controllerApp.logoNameWhite.toString(),
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(controllerApp.appName.toString(),style: TextStyle(color: AppColors.appTextColor,fontWeight: FontWeight.bold,fontSize: screenWidth*0.07),)
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02),
                Obx(() {
                  final v = controllerApp.verifyOtpPage.value;
                  final desc = v?.pageDescription ?? AppStrings.wevesentthecodetoyourmobilenumber;
                  return Text(
                    desc,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appDescriptionColor,
                      fontSize: width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
                SizedBox(height: height * 0.005),
                Text(
                  mobile,
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTitleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.045,
                  ),
                ),
                SizedBox(height: height * 0.03),

                /// Dynamic OTP length from verify_otp rules
                Obx(() {
                  final verify = controllerApp.verifyOtpPage.value;
                  int length = 4;
                  final inputs = verify?.inputs ?? [];
                  if (inputs.isNotEmpty) {
                    for (final v in (inputs.first.validations ?? [])) {
                      if ((v.type ?? '').toLowerCase() == 'exact_length' && v.value != null) {
                        length = v.value!;
                        break;
                      }
                    }
                  }
                  return Pinput(
                    length: length,
                    controller: controller.pinController,
                    defaultPinTheme: PinTheme(
                      width: width * 0.15,
                      height: width * 0.15,
                      textStyle: TextStyle(
                          fontSize: width * 0.05, color: AppColors.appTitleColor),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.appBodyTextColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: width * 0.15,
                      height: width * 0.15,
                      textStyle: TextStyle(
                          fontSize: width * 0.05, color: AppColors.appBodyTextColor),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.appGreyTextColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    showCursor: true,
                    onCompleted: (_) => controller.submitOtp(),
                  );
                }),
                SizedBox(height: height * 0.02),

                /// Timer
                Obx(() {
                  final seconds = controller.secondsRemaining.value;
                  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
                  final secs = (seconds % 60).toString().padLeft(2, '0');
                  return Text(
                    "$minutes:$secs",
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appBodyTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05,
                    ),
                  );
                }),
                SizedBox(height: height * 0.015),

                /// Resend Code
                Obx(() => GestureDetector(
                  onTap: controller.secondsRemaining.value == 0
                      ? controller.resendOtp
                      : null,
                  child: Text(
                    controller.secondsRemaining.value == 0
                        ? AppStrings.resendCode
                        : AppStrings.verification,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: controller.secondsRemaining.value == 0
                          ? AppColors.appLinkColor
                          : AppColors.appLinkColor,
                      fontSize: width * 0.04,
                    ),
                  ),
                )),
                const Spacer(),

                /// Submit button
                Obx(() => CustomButton(
                  text: controller.isLoading.value
                      ? "${AppStrings.loggingIn}..."
                      : AppStrings.loggingIn,
                  onTap: controller.submitOtp,
                )),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

