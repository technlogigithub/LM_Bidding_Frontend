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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        final buttonText = controller.forceUpdateSubmitButtonLabel.value.isNotEmpty
            ? controller.forceUpdateSubmitButtonLabel.value
            : "Update";
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          ),
          padding: EdgeInsets.only(bottom: 24.w, left: 24.w, right: 24.w),
          child: CustomButton(
            onTap: _onUpdatePressed,
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
              final title = controller.forceUpdatePageTitle.value.isNotEmpty
                  ? controller.forceUpdatePageTitle.value
                  : "Please Update";
              final description = controller.forceUpdatePageDescription.value.isNotEmpty
                  ? controller.forceUpdatePageDescription.value
                  : "Update Your App For New Features";

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appTextColor.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child:Icon(
                            Icons.system_update,
                            size: 60.sp,
                            color: AppColors.appColor,
                          ),
                  ),
                  SizedBox(height: 40.h),
                  // Title
                  Text(
                    title,
                    style: AppTextStyle.kTextStyle.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    description,
                    style: AppTextStyle.kTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.appTextColor.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),

                  // Update Icon
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.system_update_alt,
                      size: 40.sp,
                      color: AppColors.appColor,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Version Info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: AppColors.appTextColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.sp,
                              color: AppColors.appTextColor.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "${AppStrings.currentVersion} $currentVersion",
                              style: AppTextStyle.kTextStyle.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.appTextColor.withValues(alpha: 0.6),
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
                              color: AppColors.appTextColor.withValues(alpha: 0.5),
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
      ),
    );
  }

  void _onUpdatePressed() async {
    final updateUrl = controller.getUpdateUrl();
    if (updateUrl.isNotEmpty) {
      try {
        final Uri url = Uri.parse(updateUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showErrorDialog("Unable to open the update link. Please update manually from your app store.");
        }
      } catch (e) {
        _showErrorDialog("Error opening update link: $e");
      }
    } else {
      _showErrorDialog("Update URL not available. Please update manually from your app store.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onUpdatePressed(); // Try again
              },
              child: const Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
