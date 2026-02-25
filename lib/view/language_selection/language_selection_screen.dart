import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/Onboard_screen/onboard_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart';

import '../../widget/form_widgets/app_button.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
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
    // 🌐 Web Layout: Limited width, scrollable, robust scaling
    if (kIsWeb) {
      return _buildWebLayout();
    } 
    
    // 📱 Android/Mobile Layout: EXACTLY as it was before (untouched)
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appbarColor),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          controller.languagePageTitle.value.isNotEmpty ? controller.languagePageName.value : '',
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final buttonText = controller.languageSubmitButtonLabel.value.isNotEmpty ? controller.languageSubmitButtonLabel.value : "";
        return Container(
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          padding: EdgeInsets.only(bottom: 24.w, left: 24.w, right: 24.w),
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
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Obx(() {
              final title = controller.languagePageTitle.value;
              final description = controller.languagePageDescription.value;
              final languageOptions = controller.getLanguageOptions();
              final bool longList = languageOptions.length > 7;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: longList ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  _buildHeaderImage(),
                  SizedBox(height: 8.h),
                  Text(title, style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(height: 8.h),
                  Text(description, style: AppTextStyle.description(color: AppColors.appDescriptionColor), textAlign: TextAlign.center),
                  if (!longList) SizedBox(height: 40.h),
                  SizedBox(
                    height: longList ? 450.h : languageOptions.length * 60.h,
                    child: _buildLanguageList(languageOptions),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 800 ? 500.0 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(decoration: BoxDecoration(gradient: AppColors.appbarColor)),
        toolbarHeight: 60, // Slightly smaller on Web
        centerTitle: true,
        title: Obx(() => Text(
          controller.languagePageName.value.isNotEmpty ? controller.languagePageName.value : 'Language',
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        )),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                const SizedBox(height: 20),
                // Compact Header for Web (Fixed size)
                Obx(() {
                  final imageUrl = controller.languagePageImage.value;
                  return imageUrl.isEmpty 
                      ? const Icon(Icons.language, size: 60, color: Colors.grey)
                      : Image.network(imageUrl, height: 80, width: 80, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.language, size: 60, color: Colors.grey));
                }),
                const SizedBox(height: 15),
                Obx(() => Text(
                  controller.languagePageTitle.value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 5),
                Obx(() => Text(
                  controller.languagePageDescription.value,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 20),
                // Language buttons area
                Obx(() {
                  final languageOptions = controller.getLanguageOptions();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _buildLanguageList(languageOptions, isWeb: true),
                  );
                }),
                const Spacer(), // Push button to bottom
                Obx(() {
                  final buttonText = controller.languageSubmitButtonLabel.value.isNotEmpty ? controller.languageSubmitButtonLabel.value : "Continue";
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomButton(onTap: selectedLanguageKey != null ? _onContinuePressed : null, text: buttonText),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Obx(() {
      final imageUrl = controller.languagePageImage.value;
      if (imageUrl.isEmpty) return Icon(Icons.language, size: 80.sp, color: AppColors.appIconColor);
      return Image.network(
        imageUrl, height: 100.sp, width: 100.sp, fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.language, size: 80.sp, color: AppColors.appIconColor),
      );
    });
  }

  Widget _buildLanguageList(List<Map<String, String>> options, {bool isWeb = false}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: isWeb ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedLanguageKey == option['key'];
        return GestureDetector(
          onTap: () => setState(() => selectedLanguageKey = option['key']),
          child: Container(
            height: 50.h, margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.appColor : AppColors.appMutedColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text(
              option['name']!,
              style: AppTextStyle.title(
                color: isSelected ? AppColors.appWhite : AppColors.appMutedTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
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
