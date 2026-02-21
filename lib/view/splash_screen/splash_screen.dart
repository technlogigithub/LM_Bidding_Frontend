import 'package:flutter/foundation.dart';
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
    
    // For Web, check token + flag (more robust)
    // For Mobile, keep original behavior
    final authToken = sp.getString('auth_token');
    final isLoggedInFlag = sp.getBool('isLoggedIn') ?? false;
    final isLoggedIn = kIsWeb 
        ? (isLoggedInFlag || (authToken != null && authToken.isNotEmpty)) 
        : isLoggedInFlag;
    
    final isOnboardingCompleted = sp.getBool('is_onboarding_completed') ?? false;
    final isLanguageSelected = sp.getBool('is_language_selected') ?? false;

    debugPrint("🕵️ Login Check - Flag: $isLoggedInFlag, Token: ${authToken != null}, Final: $isLoggedIn");

    // If language already selected, prefetch app content
    if (isLanguageSelected) {
      await controller.fetchAppContent();
    }

    if (isLoggedIn) {
      debugPrint("🚀 Session found, going to BottomNav");
      Get.offAllNamed(AppRoutes.bottomNav);
    }
    else if(loginRequired) {
      debugPrint("🔑 Login required, going to LoginScreen");
      Get.offAllNamed(AppRoutes.login);
    }
    else if (isOnboardingCompleted) {
      debugPrint("👋 Onboarding done, going to BottomNav");
      Get.offAllNamed(AppRoutes.bottomNav);
    }
    else {
      debugPrint("🌍 Going to LanguageSelection");
      Get.offAllNamed(AppRoutes.languageSelection);
    }
  }

  @override
  void initState() {
    super.initState();
    loadVersion();
    whereToGo();
    // Removed duplicate fetchAllData() - it's already in main.dart
  }
  void loadVersion() async {
    appVersion = await AppInfo.getCurrentVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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