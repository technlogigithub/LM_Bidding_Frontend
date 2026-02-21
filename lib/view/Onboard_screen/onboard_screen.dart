import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_routes.dart';
import '../../core/app_textstyle.dart';
import '../Bottom_navigation_screen/Botom_navigation_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  // Local static slides (fallback if API not loaded)
  final List<Map<String, dynamic>> sliderList = [
    {
      "title": AppStrings.findInterestingProjects,
      "description": AppStrings.lorem,
      "icon": AppImage.onBoard1,
    },
    {
      "title": AppStrings.freelanceWorkonDemand,
      "description": AppStrings.lorem,
      "icon": AppImage.onBoard2,
    },
    {
      "title": AppStrings.getStartedFree,
      "description": AppStrings.lorem,
      "icon": AppImage.onBoard3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebLayout();
    }
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final apiSliders = Get.find<AppSettingsController>().introSliders;
                  final bool useFallback = apiSliders.isEmpty;
                  final count = useFallback ? sliderList.length : apiSliders.length;

                  return PageView.builder(
                    itemCount: count,
                    controller: pageController,
                    onPageChanged: (int index) => setState(() => currentIndexPage = index),
                    itemBuilder: (context, i) {
                      final title = useFallback ? sliderList[i]['title'] : apiSliders[i].title;
                      final description = useFallback ? sliderList[i]['description'] : apiSliders[i].description;
                      final image = useFallback ? sliderList[i]['icon'] : apiSliders[i].image;

                      return Column(
                        children: [
                          Expanded(
                            flex: 20,
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: useFallback 
                                ? Image.asset(image, fit: BoxFit.contain, height: 400.h)
                                : Image.network(image ?? "", fit: BoxFit.contain, height: 400.h),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(title ?? "", textAlign: TextAlign.center, style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20.h),
                                  Text(description ?? "", style: AppTextStyle.description(color: AppColors.appDescriptionColor), textAlign: TextAlign.center),
                                  SizedBox(height: 40.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
              _buildControls(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 800 ? 500.0 : screenWidth;

    return Scaffold(
      body: Container(
        height: screenHeight, width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    final apiSliders = Get.find<AppSettingsController>().introSliders;
                    final bool useFallback = apiSliders.isEmpty;
                    final count = useFallback ? sliderList.length : apiSliders.length;

                    return PageView.builder(
                      itemCount: count,
                      controller: pageController,
                      onPageChanged: (int index) => setState(() => currentIndexPage = index),
                      itemBuilder: (context, i) {
                        final title = useFallback ? sliderList[i]['title'] : apiSliders[i].title;
                        final description = useFallback ? sliderList[i]['description'] : apiSliders[i].description;
                        final image = useFallback ? sliderList[i]['icon'] : apiSliders[i].image;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Image Section (Fixed pixels for Web)
                            useFallback
                                ? Image.asset(image, fit: BoxFit.contain, height: 300)
                                : Image.network(image ?? "", fit: BoxFit.contain, height: 300, 
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100)),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              child: Column(
                                children: [
                                  Text(title ?? "", textAlign: TextAlign.center, style: AppTextStyle.title(color: AppColors.appTitleColor, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 15),
                                  Text(description ?? "", style: AppTextStyle.description(color: AppColors.appDescriptionColor), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
                _buildControls(isWeb: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls({bool isWeb = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          final apiSliders = Get.find<AppSettingsController>().introSliders;
          final count = apiSliders.isEmpty ? sliderList.length : apiSliders.length;
          return GestureDetector(
            onTap: () {
              if (currentIndexPage < count - 1) {
                pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              } else {
                navigateToHome();
              }
            },
            child: Container(
              height: isWeb ? 70 : 80.h, 
              width: isWeb ? 70 : 80.w,
              child: Image.asset(AppImage.thumbs, color: AppColors.appColor, fit: BoxFit.contain),
            ),
          );
        }),
        SizedBox(height: isWeb ? 15 : 20.h),
        Obx(() {
          final apiSliders = Get.find<AppSettingsController>().introSliders;
          final count = apiSliders.isEmpty ? sliderList.length : apiSliders.length;
          return SmoothPageIndicator(
            controller: pageController,
            count: count,
            effect: JumpingDotEffect(
              dotHeight: isWeb ? 10 : 8.h, 
              dotWidth: isWeb ? 10 : 8.w, 
              activeDotColor: AppColors.appColor, 
              dotColor: AppColors.appMutedColor
            ),
          );
        }),
      ],
    );
  }

  Future<void> navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_onboarding_completed', true);
    Get.offAllNamed(AppRoutes.bottomNav);
  }
}