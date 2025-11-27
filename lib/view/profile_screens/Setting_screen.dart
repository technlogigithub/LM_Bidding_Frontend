import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/profile/setting _controller.dart';
import '../../widget/form_widgets/custom_toggle.dart';

class LinkIconData {
  final IconData icon;
  final Color color;
  LinkIconData(this.icon, this.color);
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppSettingsController>();
    final settingcontroller = Get.put(SettingsController());

    // Initialize selectedLanguage from AppSettingsController
    if (settingcontroller.selectedLanguage == "English" && controller.selectedLanguageName.value.isNotEmpty) {
      settingcontroller.selectedLanguage = controller.selectedLanguageName.value;
    }

    final setting = controller.settings.value;

    final inputs = setting?.design?.inputs ?? {};
    final links = setting?.design?.link ?? [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.appTextColor),
            title: Text(
              setting?.label ?? 'Settings',
              style: TextStyle(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          body: ListView(
        children: [

          // ---------------------
          // INPUTS (TOGGLE + SELECT)
          // ---------------------
          ...inputs.entries.map((entry) {
            final key = entry.key;
            final input = entry.value;

            // Toggle Input
            if (input.inputType == "toggle") {
              return Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.appColor.withValues(alpha: 0.2),
                      child: Icon(Icons.notifications, color: AppColors.appColor),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: CustomToggle(
                        label: input.label ?? "",
                        value: settingcontroller.toggleValues[key] ?? false,
                        onChanged: (newValue) {
                          settingcontroller.toggleValues[key] = newValue;
                        },
                      ),
                    ),
                  ],
                ),
              ));
            }

            // Select input
            if (input.inputType == "select") {
              return Obx(() => settingTile(
                title: input.label ?? "",
                icon: Icons.language,
                trailingText: controller.selectedLanguageName.value.isNotEmpty 
                    ? controller.selectedLanguageName.value 
                    : settingcontroller.selectedLanguage,
                iconscolor: Colors.blue,
                onTapLink: () {
                  _showLanguageBottomSheet(context, controller, settingcontroller);
                },
                isLink: false, // Don't show arrow, show language name instead
              ));
            }

            return const SizedBox();
          }),


          // ---------------------
          // LINKS (DYNAMIC COLOR + ICON)
          // ---------------------
          ...links.map((link) {
            final iconData = getLinkIconData(link.label ?? "");

            return settingTile(
              title: link.label ?? "",
              icon: iconData.icon,
              iconscolor: iconData.color,
              isLink: true,
              onTapLink: () {
                settingcontroller.openPage(link);
              },
            );
          }),
        ],
      ),
        ),
      ),
    );
  }

  Widget settingTile({
    required String title,
    required IconData icon,
    bool? toggleValue,
    Function(bool)? onToggle,
    String? trailingText,
    Color? iconscolor,
    bool isLink = false,
    VoidCallback? onTapLink,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconscolor?.withValues(alpha: 0.2),
        child: Icon(icon, color: iconscolor),
      ),
      title: Text(title,style:  TextStyle(
          fontSize: 14, color: AppColors.appBodyTextColor),),

      trailing: trailingText != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailingText,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                if (isLink) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ],
            )
          : isLink
              ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
              : Switch(
                  value: toggleValue ?? false,
                  onChanged: onToggle,
                  activeColor: AppColors.appColor,
                ),

      onTap: onTapLink,
    );
  }


  LinkIconData getLinkIconData(String label) {
    switch (label.toLowerCase()) {
      case "privacy policy":
        return LinkIconData(Icons.warning, Colors.deepOrange);

      case "terms and conditions":
        return LinkIconData(Icons.verified_user_rounded, Colors.deepPurpleAccent);

      default:
        return LinkIconData(Icons.arrow_forward, Colors.black);
    }
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    AppSettingsController appController,
    SettingsController settingsController,
  ) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);
    final languageOptions = appController.getLanguageOptions();
    String? selectedLanguageKey = appController.selectedLanguageKey.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24.w,
                right: 24.w,
                top: 20.h,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.appDescriptionColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  
                  // Title
                  Text(
                    'Select Language',
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTitleColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),

                  // Language List
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languageOptions.length,
                      itemBuilder: (context, index) {
                        final option = languageOptions[index];
                        final isSelected = selectedLanguageKey == option['key'];
                        return GestureDetector(
                          onTap: () async {
                            // Don't do anything if same language is selected
                            if (selectedLanguageKey == option['key']) {
                              Navigator.pop(context);
                              return;
                            }
                            
                            setState(() {
                              selectedLanguageKey = option['key'];
                            });
                            
                            // Close bottom sheet first
                            Navigator.pop(context);
                            
                            // Wait a bit for bottom sheet to close
                            await Future.delayed(const Duration(milliseconds: 300));
                            
                            // Show loading indicator using GetX (handles context better)
                            Get.dialog(
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'Updating language...',
                                          style: AppTextStyle.kTextStyle.copyWith(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              barrierDismissible: false,
                            );
                            
                            try {
                              // Update selected language
                              await appController.setSelectedLanguage(option['key']!);
                              settingsController.selectedLanguage = option['name'] ?? 'English';
                              
                              // Refresh app content with new language (this updates all app content)
                              await appController.fetchAppContent();
                              
                              // Also refetch settings to get language-specific settings content
                              await appController.fetchAllData();
                              
                              // Close loading dialog using GetX
                              try {
                                Get.back();
                              } catch (e) {
                                // Dialog already closed or error
                              }
                              
                              // Show success message
                              toast('Language changed successfully');
                            } catch (e) {
                              // Close loading dialog using GetX
                              try {
                                Get.back();
                              } catch (e2) {
                                // Dialog already closed or error
                              }
                              
                              // Show error message
                              toast('Failed to change language: $e');
                            }
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.appColor : AppColors.appMutedColor,
                              borderRadius: BorderRadius.circular(10.r),
                              // border: isSelected
                              //     ? null
                              //     : Border.all(
                              //         color: AppColors.appBodyTextColor,
                              //       ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option['name'] ?? '',
                                    style: AppTextStyle.kTextStyle.copyWith(
                                      color: isSelected
                                          ? AppColors.appTextColor
                                          : AppColors.appMutedTextColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                // if (isSelected)
                                //   Icon(
                                //     Icons.check,
                                //     color: AppColors.appTextColor,
                                //     size: 20.sp,
                                //   ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
