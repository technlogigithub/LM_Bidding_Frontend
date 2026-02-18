import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widget/web_card_container_layout.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/core/utils.dart';
import '../../core/input_formatters.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libdding/widget/app_image_handle.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../../widget/form_widgets/custom_mobile_number_textfield.dart';
import 'create_account_screen.dart';
import 'login_with_mobile_number_screen.dart';


// Fixed LoginScreen with persistent controllers

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

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

    print("Login page loaded fields = ${controllerApp.loginWithPasswordPage.value?.inputs?.length}");

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              gradient: AppColors.appbarColor,
            ),
            child: Column(
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
              gradient: AppColors.appPagecolor
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Obx(() {
                    final v = controllerApp.loginWithPasswordPage.value;
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
                SizedBox(height: screenHeight * 0.04),
                Obx(() {
                  final page = controllerApp.loginWithPasswordPage.value;
                  final inputs = page?.inputs ?? [];
                  final List<Widget> fields = [];
                  if ((page?.pageDescription ?? '').isNotEmpty) {
                    fields.add(Text(page!.pageDescription!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)));
                    fields.add(SizedBox(height: screenHeight * 0.02));
                  }
                  for (final field in inputs) {
                    final fname = (field.name ?? '').toLowerCase();
                    final label = field.label ?? '';
                    final hint = field.placeholder ?? '';
                    final type = (field.inputType ?? 'text').toLowerCase();
                    if (type == 'text') {
                      fields.add(CustomMobileNumberTextField(
                        label: label,
                        hintText: hint,
                        controller: controller.mobileController,
                        onChanged: (v) => controller.mobile.value = v,
                        onCountryChanged: (code) => controller.countryCode.value = code,
                      ));
                      fields.add(SizedBox(height: screenHeight * 0.02));
                    } else if (type == 'password') {
                      fields.add(Obx(() => CustomTextfield(
                        label: label,
                        hintText: hint,
                        obscureText: controller.hidePassword.value,
                        keyboardType: TextInputType.visiblePassword,
                        controller: controller.passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.hidePassword.value ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.appIconColor,
                          ),
                          onPressed: controller.togglePassword,
                        ),
                        onChanged: (v) => controller.password.value = v,
                      )));
                      fields.add(SizedBox(height: screenHeight * 0.02));
                    }
                  }
                  return AutofillGroup(child: Column(children: fields));
                }),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Utils.gotoNextPage(() => LoginWithMobileNoScreen()),
                      child: Text(
                        AppStrings.loginwithOTP,
                        style: AppTextStyle.description(
                          color: AppColors.appLinkColor,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.06),

                // Login button with loading state
                Obx(() => CustomButton(
                  text: controller.isLoading.value ? "${AppStrings.loggingIn}..." : AppStrings.loggingIn,
                  onTap: () {
                    // Dynamic validation from login_with_password
                    final page = controllerApp.loginWithPasswordPage.value;
                    final inputs = page?.inputs ?? [];
                    String? firstError;
                    String getVal(String name) {
                      final lname = name.toLowerCase();
                      if (lname == 'username' || lname.contains('mobile') || lname.contains('phone')) return controller.mobileController.text.trim();
                      if (lname == 'password') return controller.passwordController.text.trim();
                      return '';
                    }
                    for (final field in inputs) {
                      final name = field.name ?? '';
                      final value = getVal(name);
                      final type = (field.inputType ?? '').toLowerCase();
                      if ((field.required ?? false) && value.isEmpty) {
                        firstError = '${field.label ?? name} is required';
                        break;
                      }
                      for (final v in (field.validations ?? [])) {
                        final t = (v.type ?? '').toLowerCase();
                        if (t == 'numeric' && !RegExp(r'^\d+$').hasMatch(value)) { firstError = v.errorMessage ?? '${field.label ?? name} must be numeric'; break; }
                        if (t == 'exact_length' && (v.value ?? 0) != value.length) { firstError = v.errorMessage ?? '${field.label ?? name} must be exactly ${v.value} characters'; break; }
                        if (t == 'min_length' && value.length < (v.value ?? v.minLength ?? 0)) { firstError = v.errorMessage ?? v.minLengthError ?? '${field.label ?? name} must be at least ${v.value ?? v.minLength} characters'; break; }
                        if (t == 'pattern' && v.pattern != null && !RegExp(v.pattern!).hasMatch(value)) { firstError = v.errorMessage ?? v.patternErrorMessage ?? '${field.label ?? name} format is invalid'; break; }
                      }
                      if (firstError != null) break;
                    }
                    if (firstError != null) { Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: firstError!); return; }
                    controller.loginApi(context);
                  },
                )),

                SizedBox(height: screenHeight * 0.02),
                Divider(thickness: 1.0, color: AppColors.appDescriptionColor),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: GestureDetector(
                    onTap: () => Utils.gotoNextPage(() => CreateAccountScreen()),
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.donthaveanaccount,
                        style: AppTextStyle.description(
                          color: AppColors.appBodyTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.createNewAccount,
                            style:  AppTextStyle.description(
                              color: AppColors.appLinkColor,
                              fontWeight: FontWeight.bold,
                            ),
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
            final v = controllerApp.loginWithPasswordPage.value;
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
          final page = controllerApp.loginWithPasswordPage.value;
          final inputs = page?.inputs ?? [];
          final List<Widget> fields = [];
          if ((page?.pageDescription ?? '').isNotEmpty) {
            fields.add(Text(page!.pageDescription!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)));
            fields.add(const SizedBox(height: 15));
          }
          for (final field in inputs) {
            final label = field.label ?? '';
            final hint = field.placeholder ?? '';
            final type = (field.inputType ?? 'text').toLowerCase();
            if (type == 'text') {
              fields.add(CustomMobileNumberTextField(
                label: label,
                hintText: hint,
                controller: controller.mobileController,
                onChanged: (v) => controller.mobile.value = v,
                onCountryChanged: (code) => controller.countryCode.value = code,
              ));
              fields.add(const SizedBox(height: 15));
            } else if (type == 'password') {
              fields.add(Obx(() => CustomTextfield(
                label: label,
                hintText: hint,
                obscureText: controller.hidePassword.value,
                keyboardType: TextInputType.visiblePassword,
                controller: controller.passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.hidePassword.value ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.appIconColor,
                  ),
                  onPressed: controller.togglePassword,
                ),
                onChanged: (v) => controller.password.value = v,
              )));
              fields.add(const SizedBox(height: 15));
            }
          }
          return AutofillGroup(child: Column(children: fields));
        }),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Utils.gotoNextPage(() => LoginWithMobileNoScreen()),
              child: Text(
                AppStrings.loginwithOTP,
                style: AppTextStyle.description(
                  color: AppColors.appLinkColor,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Obx(() => CustomButton(
          text: controller.isLoading.value ? "${AppStrings.loggingIn}..." : AppStrings.loggingIn,
          onTap: () {
            final page = controllerApp.loginWithPasswordPage.value;
            final inputs = page?.inputs ?? [];
            String? firstError;
            String getVal(String name) {
              final lname = name.toLowerCase();
              if (lname == 'username' || lname.contains('mobile') || lname.contains('phone')) return controller.mobileController.text.trim();
              if (lname == 'password') return controller.passwordController.text.trim();
              return '';
            }
            for (final field in inputs) {
              final name = field.name ?? '';
              final value = getVal(name);
              final type = (field.inputType ?? '').toLowerCase();
              if ((field.required ?? false) && value.isEmpty) { firstError = '${field.label ?? name} is required'; break; }
              for (final v in (field.validations ?? [])) {
                final t = (v.type ?? '').toLowerCase();
                if (t == 'numeric' && !RegExp(r'^\d+$').hasMatch(value)) { firstError = v.errorMessage ?? '${field.label ?? name} must be numeric'; break; }
                if (t == 'exact_length' && (v.value ?? 0) != value.length) { firstError = v.errorMessage ?? '${field.label ?? name} must be exactly ${v.value} characters'; break; }
                if (t == 'min_length' && value.length < (v.value ?? v.minLength ?? 0)) { firstError = v.errorMessage ?? v.minLengthError ?? '${field.label ?? name} must be at least ${v.value ?? v.minLength} characters'; break; }
                if (t == 'pattern' && v.pattern != null && !RegExp(v.pattern!).hasMatch(value)) { firstError = v.errorMessage ?? v.patternErrorMessage ?? '${field.label ?? name} format is invalid'; break; }
              }
              if (firstError != null) break;
            }
            if (firstError != null) { Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: firstError!); return; }
            controller.loginApi(context);
          },
        )),
        SizedBox(height: 20.h),
        Divider(thickness: 1.0, color: AppColors.appDescriptionColor),
        SizedBox(height: 20.h),
        Center(
          child: GestureDetector(
            onTap: () => Utils.gotoNextPage(() => CreateAccountScreen()),
            child: RichText(
              text: TextSpan(
                text: AppStrings.donthaveanaccount,
                style: AppTextStyle.description(
                  color: AppColors.appBodyTextColor,
                ),
                children: [
                  TextSpan(
                    text: AppStrings.createNewAccount,
                    style:  AppTextStyle.description(
                      color: AppColors.appLinkColor,
                      fontWeight: FontWeight.bold,
                    ),
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

