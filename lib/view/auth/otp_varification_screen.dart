import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widget/web_card_container_layout.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/Otp_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../core/app_textstyle.dart';
import '../../widget/app_image_handle.dart';
import '../../widget/form_widgets/app_button.dart';

class OtpVarificationScreen extends StatefulWidget {
  final String mobile;
  final String? otp;

  const OtpVarificationScreen({super.key, required this.mobile, this.otp});

  @override
  State<OtpVarificationScreen> createState() => _OtpVarificationScreenState();
}

class _OtpVarificationScreenState extends State<OtpVarificationScreen> {
  final OtpController controller = Get.put(OtpController());
  static final controllerApp = Get.put(AppSettingsController());

  @override
  void initState() {
    super.initState();
    controller.setMobile(widget.mobile);
    if (widget.otp != null && widget.otp!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.pinController.text = widget.otp!;
        controller.submitOtp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebUI(context);
    }
    return _buildMobileUI(context);
  }

  Widget _buildMobileUI(BuildContext context) {
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
            child: _buildFormContent(context, isWeb: false),
          ),
        ),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    return WebCardContainerLayout(
      logoUrl: controllerApp.logoNameWhite.toString(),
      child: _buildFormContent(context, isWeb: true),
    );
  }

  Widget _buildFormContent(BuildContext context, {required bool isWeb}) {
    final width = Get.width;
    final height = Get.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: isWeb ? 10 : height * 0.02),
        Obx(() {
          final v = controllerApp.verifyOtpPage.value;
          final desc = v?.pageDescription ?? AppStrings.wevesentthecodetoyourmobilenumber;
          return Text(
            desc,
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,

            ),
            textAlign: TextAlign.center,
          );
        }),
        SizedBox(height: isWeb ? 5 : height * 0.005),
        Text(
          widget.mobile,
          style: AppTextStyle.title(
            color: AppColors.appTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isWeb ? 15 : height * 0.03),

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
          final pinWidth = isWeb ? 50.0 : width * 0.15;
          return Pinput(
            length: length,
            autofillHints: const [AutofillHints.oneTimeCode],
            controller: controller.pinController,
            defaultPinTheme: PinTheme(
              width: pinWidth,
              height: pinWidth,
              textStyle: TextStyle(
                  fontSize: isWeb ? 20 : width * 0.05, color: AppColors.appTitleColor),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appBodyTextColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: pinWidth,
              height: pinWidth,
              textStyle: TextStyle(
                  fontSize: isWeb ? 20 : width * 0.05, color: AppColors.appBodyTextColor),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appMutedTextColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            showCursor: true,
            onCompleted: (_) => controller.submitOtp(),
          );
        }),
        SizedBox(height: isWeb ? 15 : height * 0.02),

        /// Timer
        Obx(() {
          final seconds = controller.secondsRemaining.value;
          final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
          final secs = (seconds % 60).toString().padLeft(2, '0');
          return Text(
            "$minutes:$secs",
            style: AppTextStyle.title(
              color: AppColors.appBodyTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
        SizedBox(height: isWeb ? 10 : height * 0.015),

        /// Resend Code
        Obx(() => GestureDetector(
          onTap: controller.secondsRemaining.value == 0
              ? controller.resendOtp
              : null,
          child: Text(
            controller.secondsRemaining.value == 0
                ? AppStrings.resendCode
                : AppStrings.verification,
            style: AppTextStyle.title(
              color: controller.secondsRemaining.value == 0
                  ? AppColors.appLinkColor
                  : AppColors.appLinkColor,

            ),
          ),
        )),
        if (!isWeb) const Spacer(),
        if (isWeb) const SizedBox(height: 25),

        /// Submit button
        Obx(() => CustomButton(
          text: controller.isLoading.value
              ? "${AppStrings.loggingIn}..."
              : AppStrings.loggingIn,
          onTap: controller.submitOtp,
        )),
        SizedBox(height: isWeb ? 10 : height * 0.05),
      ],
    );

  }
}

