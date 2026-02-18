import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widget/web_card_container_layout.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../core/app_textstyle.dart';
import '../../core/utils.dart';
import '../../core/input_formatters.dart';
import '../../widget/app_image_handle.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../../widget/form_widgets/custom_mobile_number_textfield.dart';
import 'create_account_screen.dart';
import 'login_screen.dart';
class LoginWithMobileNoScreen extends StatelessWidget {
   LoginWithMobileNoScreen({super.key});

  final AuthController controller = Get.put(AuthController());
   static final controllerApp = Get.put(AppSettingsController());
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebUI(context);
    }
    return _buildMobileUI(context);
  }

  Widget _buildMobileUI(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appWhite,
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
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor, // LinearGradient here
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*0.02),
                  Center(
                    child: Obx(() {
                      final v = controllerApp.loginWithOtpPage.value;
                      final title = v?.pageTitle ?? AppStrings.logInYourAccount;
                      return Text(
                        title,
                        style: AppTextStyle.title(
                            color: AppColors.appTitleColor,
                            fontWeight: FontWeight.bold,
                            ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight*0.04),
                  Obx(() {
                    final page = controllerApp.loginWithOtpPage.value;
                    final inputs = page?.inputs ?? [];
                    final List<Widget> fields = [];
                    if ((page?.pageDescription ?? '').isNotEmpty) {
                      fields.add(Text(page!.pageDescription!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)));
                      fields.add(SizedBox(height: screenHeight * 0.02));
                    }
                    for (final field in inputs) {
                      final label = field.label ?? '';
                      final hint = field.placeholder ?? '';
                      fields.add(CustomMobileNumberTextField(
                        label: label,
                        hintText: hint,
                        controller: controller.mobileController,
                        onChanged: (v) => controller.mobile.value = v,
                        onCountryChanged: (code) {
                          controller.countryCode.value = code;
                        },
                      ));
                      fields.add(SizedBox(height: screenHeight * 0.02));
                    }
                    return AutofillGroup(child: Column(children: fields));
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () =>Utils.gotoNextPage(() => LoginScreen()),
                        child: Text(
                          AppStrings.loginwitPassword,
                          style: AppTextStyle.description(color: AppColors.appLinkColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.06),

                  // Login button NEEDS Obx for isLoading state
                  Obx(() => CustomButton(
                    text: controller.isLoading.value ? "${AppStrings.loggingIn}..." : AppStrings.loggingIn,
                    onTap: () {
                      // Dynamic validation from login_with_otp
                      final page = controllerApp.loginWithOtpPage.value;
                      final inputs = page?.inputs ?? [];
                      String? firstError;
                      final value = controller.mobileController.text.trim();
                      for (final field in inputs) {
                        if ((field.required ?? false) && value.isEmpty) { firstError = '${field.label ?? 'Mobile'} is required'; break; }
                        for (final v in (field.validations ?? [])) {
                          final t = (v.type ?? '').toLowerCase();
                          if (t == 'numeric' && !RegExp(r'^\d+$').hasMatch(value)) { firstError = v.errorMessage ?? 'Mobile must be numeric'; break; }
                          if (t == 'exact_length' && (v.value ?? 0) != value.length) { firstError = v.errorMessage ?? 'Mobile must be exactly ${v.value} digits'; break; }
                        }
                        if (firstError != null) break;
                      }
                      if (firstError != null) { Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: firstError!); return; }
                      controller.loginWithOtp(context, controller.mobileController.text.trim());
                    },
                  )),

                  SizedBox(height: screenHeight*0.02),
                  Divider(thickness: 1.0, color: AppColors.textgrey),
                  SizedBox(height: screenHeight*0.02),
                  Center(
                    child: GestureDetector(
                      onTap: () => Utils.gotoNextPage(() => CreateAccountScreen(),),
                      child: RichText(
                        text: TextSpan(
                          text:AppStrings.donthaveanaccount,
                          style: AppTextStyle.description(color: AppColors.appBodyTextColor),
                          children: [
                            TextSpan(
                              text: AppStrings.createNewAccount,
                              style: AppTextStyle.description(
                                  color: AppColors.appLinkColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    return WebCardContainerLayout(
      logoUrl: controllerApp.logoNameWhite.toString(),
      child: _buildWebFormContent(context),
    );
  }

  Widget _buildWebFormContent(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Obx(() {
            final v = controllerApp.loginWithOtpPage.value;
            final title = v?.pageTitle ?? AppStrings.logInYourAccount;
            return Text(
              title,
              style: AppTextStyle.title(
                color: AppColors.appTitleColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ),
        const SizedBox(height: 15),
        Obx(() {
          final page = controllerApp.loginWithOtpPage.value;
          final inputs = page?.inputs ?? [];
          final List<Widget> fields = [];
          if ((page?.pageDescription ?? '').isNotEmpty) {
            fields.add(Text(page!.pageDescription!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)));
            fields.add(const SizedBox(height: 15));
          }
          for (final field in inputs) {
            final label = field.label ?? '';
            final hint = field.placeholder ?? '';
            fields.add(CustomMobileNumberTextField(
              label: label,
              hintText: hint,
              controller: controller.mobileController,
              onChanged: (v) => controller.mobile.value = v,
              onCountryChanged: (code) {
                controller.countryCode.value = code;
              },
            ));
            fields.add(const SizedBox(height: 15));
          }
          return AutofillGroup(child: Column(children: fields));
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Utils.gotoNextPage(() => LoginScreen()),
              child: Text(
                AppStrings.loginwitPassword,
                style: AppTextStyle.description(color: AppColors.appLinkColor),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Obx(() => CustomButton(
          text: controller.isLoading.value ? "${AppStrings.loggingIn}..." : AppStrings.loggingIn,
          onTap: () {
            final page = controllerApp.loginWithOtpPage.value;
            final inputs = page?.inputs ?? [];
            String? firstError;
            final value = controller.mobileController.text.trim();
            for (final field in inputs) {
              if ((field.required ?? false) && value.isEmpty) { firstError = '${field.label ?? 'Mobile'} is required'; break; }
              for (final v in (field.validations ?? [])) {
                final t = (v.type ?? '').toLowerCase();
                if (t == 'numeric' && !RegExp(r'^\d+$').hasMatch(value)) { firstError = v.errorMessage ?? 'Mobile must be numeric'; break; }
                if (t == 'exact_length' && (v.value ?? 0) != value.length) { firstError = v.errorMessage ?? 'Mobile must be exactly ${v.value} digits'; break; }
              }
              if (firstError != null) break;
            }
            if (firstError != null) { Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: firstError!); return; }
            controller.loginWithOtp(context, controller.mobileController.text.trim());
          },
        )),
        SizedBox(height: 20.h),
        Divider(thickness: 1.0, color: AppColors.textgrey),
        SizedBox(height: 20.h),
        Center(
          child: GestureDetector(
            onTap: () => Utils.gotoNextPage(() => CreateAccountScreen()),
            child: RichText(
              text: TextSpan(
                text: AppStrings.donthaveanaccount,
                style: AppTextStyle.description(color: AppColors.appBodyTextColor),
                children: [
                  TextSpan(
                    text: AppStrings.createNewAccount,
                    style: AppTextStyle.description(
                        color: AppColors.appLinkColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
