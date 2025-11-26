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
import '../force_update/ForceUpdateScreen.dart';
import '../language_selection/LanguageSelectionScreen.dart';

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ForceUpdateScreen()),
      );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
      );
    }
    else if(loginRequired)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    else if (isOnboardingCompleted)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
        );
      }
    // else if (!isLanguageSelected) {
    //   // Show language selection screen first
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
    //   );
    // }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
        // MaterialPageRoute(builder: (context) => BotomNavigationScreen()),
      );
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
                  baseColor: Colors.grey.shade300.withValues(alpha: 0.6),
                  highlightColor: Colors.grey.shade100.withValues(alpha: 0.6),
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
                              style: AppTextStyle.kTextStyle.copyWith(
                                color: AppColors.appTextColor,
                                fontSize: 14.sp, // Responsive font size
                              ),
                            ),
                            Text(
                              appVersion,
                              style: AppTextStyle.kTextStyle.copyWith(
                                color: AppColors.appTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp, // Responsive font size
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