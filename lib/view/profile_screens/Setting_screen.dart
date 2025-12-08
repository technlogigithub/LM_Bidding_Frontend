import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/profile/setting _controller.dart';
import '../../widget/form_widgets/custom_toggle.dart';

class settingScreen {
  final IconData icon;
  final Color color;
  settingScreen(this.icon, this.color);
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppSettingsController>();
    final settingcontroller = Get.put(SettingsController());

    if (settingcontroller.selectedLanguage == "English" &&
        controller.selectedLanguageName.value.isNotEmpty) {
      settingcontroller.selectedLanguage =
          controller.selectedLanguageName.value;
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
            title: Obx(() => Text(
              setting?.label ?? '',
              style: AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
          body: ListView(
            children: [
              ...inputs.entries.map((entry) {
                final key = entry.key;
                final input = entry.value;

                if (input.inputType == "toggle") {
                  return Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          AppColors.appColor.withValues(alpha: 0.2),
                          child: Icon(Icons.notifications,
                              color: AppColors.appColor),
                        ),
                        const SizedBox(width: 14),
                        Obx(() => Text( input.label??"",style: AppTextStyle.description(color: AppColors.appBodyTextColor),)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomToggle(
                            label:  "",
                            value: settingcontroller.toggleValues[key] ??
                                false,
                            onChanged: (newValue) {
                              settingcontroller.toggleValues[key] =
                                  newValue;
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
                }

                if (input.inputType == "select") {
                  return Obx(() => settingTile(
                    title: input.label ?? "",
                    icon: Icons.language,
                    trailingText:
                    controller.selectedLanguageName.value.isNotEmpty
                        ? controller.selectedLanguageName.value
                        : settingcontroller.selectedLanguage,
                    iconscolor: Colors.blue,
                    onTapLink: () {
                      _showLanguageBottomSheet(
                          context, controller, settingcontroller);
                    },
                    isLink: false,
                  ));
                }

                return const SizedBox();
              }),

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

              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.appMutedColor,
                    child: Icon(
                      Icons.text_increase,
                      color: AppColors.appMutedTextColor,
                    ),
                  ),
                  title: Obx(() => Text(
                    "Font Size ",
                    style: AppTextStyle.description(
                        color: AppColors.appBodyTextColor),
                  )),
                  trailing: InkWell(
                      onTap: () => showFontSizeBottomSheet(context),
                      child: Icon(Icons.keyboard_arrow_down,
                          color: AppColors.appMutedTextColor)))
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
      title: Obx(() => Text(
        title,
        style: AppTextStyle.description(
          color: AppColors.appBodyTextColor,
        ),
      )),
      trailing: trailingText != null
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Text(
            trailingText,
            style: AppTextStyle.description(
                color: Colors.grey,
                fontWeight: FontWeight.w500),
          )),
          if (isLink) ...[
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ],
      )
          : isLink
          ? const Icon(Icons.arrow_forward_ios,
          size: 16, color: Colors.grey)
          : Switch(
        value: toggleValue ?? false,
        onChanged: onToggle,
        activeColor: AppColors.appColor,
      ),
      onTap: onTapLink,
    );
  }

  settingScreen getLinkIconData(String label) {
    switch (label.toLowerCase()) {
      case "privacy policy":
        return settingScreen(Icons.warning, Colors.deepOrange);

      case "terms and conditions":
        return settingScreen(
            Icons.verified_user_rounded, Colors.deepPurpleAccent);

      default:
        return settingScreen(Icons.arrow_forward, Colors.black);
    }
  }

  void _showLanguageBottomSheet(
      BuildContext context,
      AppSettingsController appController,
      SettingsController settingsController,
      ) {
    ScreenUtil.init(context,
        designSize: const Size(375, 812), minTextAdapt: true);
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Obx(() => Text(
                    'Select Language',
                    style: AppTextStyle.title(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(height: 20.h),

                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languageOptions.length,
                      itemBuilder: (context, index) {
                        final option = languageOptions[index];
                        final isSelected =
                            selectedLanguageKey == option['key'];

                        return GestureDetector(
                          onTap: () async {
                            if (selectedLanguageKey == option['key']) {
                              Navigator.pop(context);
                              return;
                            }

                            setState(() {
                              selectedLanguageKey = option['key'];
                            });

                            Navigator.pop(context);

                            await Future.delayed(
                                const Duration(milliseconds: 300));

                            Get.dialog(
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              AppColors.appColor),
                                        ),
                                        SizedBox(height: 16.h),
                                        Obx(() => Text(
                                          'Updating language...',
                                          style:
                                          AppTextStyle.description(),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            try {
                              await appController
                                  .setSelectedLanguage(option['key']!);
                              settingsController.selectedLanguage =
                                  option['name'] ?? 'English';

                              await appController.fetchAppContent();
                              await appController.fetchAllData();

                              Get.back();

                              toast('Language changed successfully');
                            } catch (e) {
                              Get.back();
                              toast('Failed: $e');
                            }
                          },
                          child: Container(
                            height: 50.h,
                            padding:
                            EdgeInsets.symmetric(horizontal: 16.w),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.appColor
                                  : AppColors.appMutedColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(() => Text(
                                    option['name'] ?? '',
                                    style: AppTextStyle.description(
                                      color: isSelected
                                          ? AppColors.appTextColor
                                          : AppColors.appMutedTextColor,
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showFontSizeBottomSheet(BuildContext context) {
    final controller = Get.find<AppSettingsController>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      "Font Size",
                      style: AppTextStyle.title(
                        color: AppColors.appBodyTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close,
                            color: AppColors.appMutedTextColor)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // controller.decreaseTitle();
                        // controller.decreaseDescription();
                        // controller.decreaseBody();
                        controller.decreaseCounter();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.appButtonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            color: AppColors.appButtonTextColor,
                          ),
                        ),
                      ),
                    ),
                    Obx(() => Text(
                      controller.fontCounter.value.toString(),
                      style: AppTextStyle.title(
                        color: AppColors.appBodyTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        // controller.increaseTitle();
                        // controller.increaseDescription();
                        // controller.increaseBody();
                        controller.increaseCounter();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.appButtonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: AppColors.appButtonTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
