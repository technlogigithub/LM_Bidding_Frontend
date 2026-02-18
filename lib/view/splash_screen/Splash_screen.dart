import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_config.dart';
import '../../widget/app_image_handle.dart';
import '../Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../force_update/force_update_screen.dart';
import '../language_selection/language_selection_screen.dart';
import 'package:libdding/core/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(AppSettingsController());
  String appVersion = "";

  void whereToGo() async {
    await Future.delayed(const Duration(seconds: 3));

    final updateRequired = await controller.isUpdateRequired();
    if (updateRequired) {
      Get.offAllNamed(AppRoutes.forceUpdate);
      return;
    }
    
    final bool loginRequired = controller.loginRequired.value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    final isLoggedIn = sp.getBool('isLoggedIn') ?? false;
    final isOnboardingCompleted = sp.getBool('is_onboarding_completed') ?? false;
    final isLanguageSelected = sp.getBool('is_language_selected') ?? false;

    // If language already selected, prefetch app content
    if (isLanguageSelected) {
      await controller.fetchAppContent();
    }

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.bottomNav);
    }
    else if(loginRequired) {
      Get.offAllNamed(AppRoutes.login);
    }
    else if (isOnboardingCompleted) {
      Get.offAllNamed(AppRoutes.bottomNav);
    }
    else {
      Get.offAllNamed(AppRoutes.languageSelection);
    }
  }

  @override
  void initState() {
    super.initState();
    loadVersion();
    whereToGo();
    controller.fetchAllData();
  }
  void loadVersion() async {
    appVersion = await AppInfo.getCurrentVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with a reference design size (375x812 for mobile)
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);
    final screenWidth = MediaQuery.of(context).size.width;
    // Define max width for web/large screens
    final maxContentWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: Center(
          child: ConstrainedBox(

            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Obx(() {
              // Check if the controller logo data is loaded
              if (controller.logo.value.isEmpty) {
                // Full screen shimmer while loading
                return Shimmer.fromColors(
                  baseColor: AppColors.appMutedColor,
                  highlightColor: AppColors.appMutedTextColor,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                );
              }

              // Once loaded, show logo at center with version info
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h, left: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              AppStrings.version,
                              style: AppTextStyle.description(
                                color: AppColors.appTextColor,

                              ),
                            ),
                            Text(
                              appVersion,
                              style: AppTextStyle.title(
                                color: AppColors.appTextColor,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                    width: maxContentWidth * 0.9,
                    child: UniversalImage(
                      url: controller.logoSplash.value,
                      height: 100.h,
                      width: maxContentWidth * 0.9,
                      fit: BoxFit.contain,
                    ),
                  )

                ],
              );
            }),
          ),
        ),
      ),
    );
  }

}