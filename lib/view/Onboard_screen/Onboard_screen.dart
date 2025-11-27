import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/app_main/App_main_controller.dart';
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
    // Initialize ScreenUtil with a reference design size (375x812 for mobile)
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Define max width for web/large screens
    final maxContentWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      final sliders = Get.find<AppSettingsController>().introSliders;

                      if (sliders.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return PageView.builder(
                        itemCount: sliders.length,
                        controller: pageController,
                        onPageChanged: (int index) {
                          setState(() => currentIndexPage = index);
                        },
                        itemBuilder: (context, i) {
                          final slider = sliders[i];
                          return Column(
                            children: [
                              /// Top image
                              Expanded(
                                flex: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Image.network(
                                    slider.image ?? "",
                                    fit: BoxFit.contain,
                                    width: maxContentWidth,
                                    height: 400.h, // Scaled height for image
                                    errorBuilder: (ctx, err, _) => Icon(
                                      Icons.image_not_supported,
                                      size: 50.sp,

                                    ),
                                  ),
                                ),
                              ),

                              /// Bottom container with clip
                              Expanded(
                                flex: 5,
                                child: ClipPath(
                                  clipper: BottomShapeClipper(),
                                  child: Container(
                                    width: maxContentWidth,
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          slider.title ?? "",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.kTextStyle.copyWith(
                                            color: AppColors.appTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp, // Responsive font size
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          slider.description ?? "",
                                          style: AppTextStyle.kTextStyle.copyWith(
                                            color: AppColors.appDescriptionColor,
                                            fontSize: 16.sp, // Responsive font size
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 40.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),

                  /// Next / Finish button
                  Obx(() {
                    final sliders = Get.find<AppSettingsController>().introSliders;
                    final sliderCount = sliders.isNotEmpty ? sliders.length : sliderList.length;
                    
                    return GestureDetector(
                      onTap: () {
                        if (currentIndexPage < sliderCount - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          navigateToHome();
                        }
                      },
                      child: Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Image.asset(AppImage.thumbs,color: AppColors.appColor,fit: BoxFit.contain,)),
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),

                  /// Page indicator
                  Obx(() {
                    final sliders = Get.find<AppSettingsController>().introSliders;
                    final sliderCount = sliders.isNotEmpty ? sliders.length : sliderList.length;
                    
                    return SmoothPageIndicator(
                      controller: pageController,
                      count: sliderCount,
                      effect: JumpingDotEffect(
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        verticalOffset: 10.h,
                        activeDotColor: AppColors.appColor,
                        dotColor: AppColors.appMutedColor,
                      ),
                    );
                  }),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToHome () async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_onboarding_completed', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
    );
  }
}

/// Custom clipper for bottom container
class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50.h); // Scaled height for curve

    // Quadratic Bezier curve for responsive shape
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50.h,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}