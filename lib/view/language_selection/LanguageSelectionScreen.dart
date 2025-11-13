import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/Onboard_screen/Onboard_screen.dart';

import '../../widget/form_widgets/app_button.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final AppSettingsController controller = Get.put(AppSettingsController());
  String? selectedLanguageKey;
  @override
  void initState() {
    super.initState();
    selectedLanguageKey = controller.selectedLanguageKey.value;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        final buttonText = controller.languageSubmitButtonLabel.value.isNotEmpty
            ? controller.languageSubmitButtonLabel.value
            : AppStrings.continueButtonTitle;
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          padding: EdgeInsets.only(bottom: 24.w,left: 24.w,right: 24.w),
          child: CustomButton(
            onTap: selectedLanguageKey != null ? _onContinuePressed : null,
            text: buttonText,
          ),
        );
      }),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Obx(() {
              final title = controller.languagePageTitle.value.isNotEmpty
                  ? controller.languagePageTitle.value
                  : AppStrings.selectLanguage;
              final description = controller.languagePageDescription.value.isNotEmpty
                  ? controller.languagePageDescription.value
                  : AppStrings.chooseYourPreferredLanguage;
              final languageOptions = controller.getLanguageOptions();

              final bool longList = languageOptions.length > 7;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: longList ?  MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    size: 90.sp,
                    color: AppColors.appColor,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    title,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTextColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTextColor.withValues(alpha: 0.60),
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!longList) SizedBox(height: 40.h),

                  SizedBox(
                    height: longList ? 450.h : languageOptions.length * 60.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: longList ? 16.h : 0),
                      itemCount: languageOptions.length,
                      itemBuilder: (context, index) {
                        final option = languageOptions[index];
                        final isSelected = selectedLanguageKey == option['key'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLanguageKey = option['key'];
                            });
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.all(10.w),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.appColor : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(10.r),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                color: AppColors.appTextColor.withValues(alpha: 0.10),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              option['name']!,
                              style: AppTextStyle.kTextStyle.copyWith(
                                color: isSelected
                                    ? AppColors.appWhite
                                    : AppColors.appTextColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() async {
    if (selectedLanguageKey != null) {
      await controller.setSelectedLanguage(selectedLanguageKey!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_language_selected', true);
      await controller.fetchAppContent();
      Get.off(() => const OnBoard());
    }
  }
}