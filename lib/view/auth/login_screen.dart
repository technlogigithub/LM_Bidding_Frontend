import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/core/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libdding/widget/app_image_handle.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/app_textfield.dart';
import 'create_account_screen.dart';
import 'login_with_mobile_no_screen.dart';


// Fixed LoginScreen with persistent controllers

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.put(AuthController());
  static final controllerApp = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
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
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.appTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.04),

                // FORM FIELDS
                Obx(() {
                  final page = controllerApp.loginWithPasswordPage.value;
                  final inputs = page?.inputs ?? [];
                  final List<Widget> fields = [];

                  if ((page?.pageDescription ?? '').isNotEmpty) {
                    fields.add(Text(
                      page!.pageDescription!,
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.appDescriptionColor,
                      ),
                    ));
                    fields.add(SizedBox(height: screenHeight * 0.02));
                  }

                  for (final field in inputs) {
                    final fname = (field.name ?? '').toLowerCase();
                    final label = field.label ?? '';
                    final hint = field.placeholder ?? '';
                    final type = (field.inputType ?? 'text').toLowerCase();

                    // PERSISTENT CONTROLLER FIX
                    TextEditingController textController;

                    if (fname.contains('mobile') || fname.contains('phone')) {
                      textController = controller.mobileController;
                    } else if (fname.contains('password')) {
                      textController = controller.passwordController;
                    } else {
                      if (!controller.fieldControllers.containsKey(fname)) {
                        controller.fieldControllers[fname] = TextEditingController();
                      }
                      textController = controller.fieldControllers[fname]!;
                    }

                    // TEXT FIELD
                    if (type == 'text') {
                      fields.add(
                        CustomTextfield(
                          label: label,
                          hintText: hint,
                          controller: textController,
                          keyboardType: fname.contains('email')
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                          onChanged: (v) {
                            if (fname.contains('mobile') || fname.contains('phone')) {
                              controller.mobile.value = v;
                            }
                          },
                        ),
                      );
                    }

                    // PASSWORD FIELD
                    else if (type == 'password') {
                      fields.add(
                        Obx(
                              () => CustomTextfield(
                            label: label,
                            hintText: hint,
                            obscureText: controller.hidePassword.value,
                            controller: textController,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.appIconColor,
                              ),
                              onPressed: controller.togglePassword,
                            ),
                            onChanged: (v) => controller.password.value = v,
                          ),
                        ),
                      );
                    }

                    fields.add(SizedBox(height: screenHeight * 0.02));
                  }

                  return AutofillGroup(child: Column(children: fields));
                }),

                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Utils.gotoNextPage(
                            () => LoginWithMobileNoScreen(),
                      ),
                      child: Text(
                        AppStrings.loginwithOTP,
                        style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.appLinkColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.06),

                // LOGIN BUTTON
                Obx(
                      () => CustomButton(
                    text: controller.isLoading.value
                        ? "${AppStrings.loggingIn}..."
                        : AppStrings.loggingIn,
                    onTap: () {
                      final page = controllerApp.loginWithPasswordPage.value;
                      final inputs = page?.inputs ?? [];
                      String? firstError;

                      String getVal(String name) {
                        final lname = name.toLowerCase();
                        if (lname == 'username' ||
                            lname.contains('mobile') ||
                            lname.contains('phone'))
                          return controller.mobileController.text.trim();
                        if (lname == 'password')
                          return controller.passwordController.text.trim();
                        return '';
                      }

                      for (final field in inputs) {
                        final name = field.name ?? '';
                        final value = getVal(name);

                        if ((field.required ?? false) && value.isEmpty) {
                          firstError = '${field.label ?? name} is required';
                          break;
                        }
                      }

                      if (firstError != null) {
                        Utils.showSnackbar(
                          isSuccess: false,
                          title: AppStrings.alert,
                          message: firstError!,
                        );
                        return;
                      }

                      controller.loginApi(context);
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Divider(thickness: 1.0, color: AppColors.appTextColor),
                SizedBox(height: screenHeight * 0.02),

                Center(
                  child: GestureDetector(
                    onTap: () => Utils.gotoNextPage(
                          () => SignUpScreen(),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.donthaveanaccount,
                        style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.appBodyTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.createNewAccount,
                            style: AppTextStyle.kTextStyle.copyWith(
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
}

