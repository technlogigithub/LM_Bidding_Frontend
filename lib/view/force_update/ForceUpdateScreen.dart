import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/core/app_config.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../widget/form_widgets/app_button.dart';

class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({super.key});

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  final AppSettingsController controller = Get.find<AppSettingsController>();
  String currentVersion = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentVersion();
  }

  void _loadCurrentVersion() async {
    final version = await AppInfo.getCurrentVersion();
    if (mounted) {
      setState(() {
        currentVersion = version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    return Obx(() => Scaffold(
      backgroundColor: Colors.white,

      /// ---------- Bottom Button with Dynamic Gradient ----------
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        padding: EdgeInsets.only(bottom: 24.w, left: 24.w, right: 24.w),
        child: CustomButton(
          onTap: _onUpdatePressed,
          text: controller.forceUpdateSubmitButtonLabel.value.isNotEmpty
              ? controller.forceUpdateSubmitButtonLabel.value
              : "Update",
        ),
      ),

      /// ---------- Main Body ----------
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          padding: EdgeInsets.all(24.w),
          child: Obx(() {
            final title = controller.forceUpdatePageTitle.value.isNotEmpty
                ? controller.forceUpdatePageTitle.value
                : " ";

            final description =
            controller.forceUpdatePageDescription.value.isNotEmpty
                ? controller.forceUpdatePageDescription.value
                : " ";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ICON BOX
                Container(
                  height: 120.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.appMutedColor,
                    borderRadius: BorderRadius.circular(20.r),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color:
                    //     AppColors.appTextColor.withValues(alpha: 0.1),
                    //     blurRadius: 10,
                    //     offset: const Offset(0, 5),
                    //   ),
                    // ],
                  ),
                  child: Icon(
                    Icons.system_update,
                    size: 60.sp,
                    color: AppColors.appIconColor,
                  ),
                ),

                SizedBox(height: 40.h),

                /// TITLE
                Text(
                  title,
                  style: AppTextStyle.kTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appTitleColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                /// DESCRIPTION
                Text(
                  description,
                  style: AppTextStyle.kTextStyle.copyWith(
                    fontSize: 16.sp,
                    color:
                    AppColors.appDescriptionColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                /// UPDATE ICON
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.appMutedColor,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.system_update_alt,
                    size: 40.sp,
                    color: AppColors.appIconColor,
                  ),
                ),

                SizedBox(height: 20.h),

                /// VERSION INFO BOX
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.appMutedColor,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color:
                      AppColors.appMutedColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16.sp,
                            color: AppColors.appMutedTextColor

                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "${AppStrings.currentVersion} $currentVersion",
                            style: AppTextStyle.kTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.appMutedTextColor
                            ),
                          ),
                        ],
                      ),

                      if (controller.getRequiredVersion().isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          "${AppStrings.requiredVersion} ${controller.getRequiredVersion()}",
                          style: AppTextStyle.kTextStyle.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.appMutedTextColor

                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ));
  }

  void _onUpdatePressed() async {
    final updateUrl = controller.getUpdateUrl();
    if (updateUrl.isEmpty) {
      _showErrorDialog("Update URL not available. Please update manually.");
      return;
    }

    try {
      final Uri url = Uri.parse(updateUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog("Unable to open the update link.");
      }
    } catch (e) {
      _showErrorDialog("Error opening update link: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Update Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onUpdatePressed();
            },
            child: const Text("Try Again"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
