import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/bottom/bottom_bar_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_navigator.dart'; // Added import
import '../../widget/custom_view_widget.dart';
import '../Home_screen/home_screen.dart';
import '../Participate_screens/participate_screen.dart';
import '../Post_new_screen/post_new_screen.dart';
import '../profile_screens/My Orders/my_orders_screen.dart';
import '../profile_screens/My Posts/my_post_screen.dart';
import '../profile_screens/profile_screen.dart';
import '../seller screen/seller messgae/chat_list.dart';
import '../../widget/app_image_handle.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  /// Helper to map `nextPageName` to the corresponding Widget.
  /// Matches logic from CustomNavigator where possible.
  Widget _getWidget(AppMenuItem item) {
    final routeKey = item.nextPageName;
    switch (routeKey) {
      case "home_screen":
        return HomeScreen();
      case "message_screen":
        return const ChatListScreen();
      case "post_new_screen":
        return PostNewScreen(apiEndpoint: item.nextPageApiEndpoint);
      case "participate_screen":
        return ParticipateScreen(apiEndpoint: item.nextPageApiEndpoint, menuItem: item);
      case "profile_screen":
        return ProfileScreen();
      case "my_orders_screen":
        return MyOrdersScreen(menuItem: item);
      case "my_posts_screen":
        return MyPostScreen(menuItem: item);
      // Add other cases as needed matching CustomNavigator...
      default:
        return HomeScreen(); // Fallback
    }
  }

  /// Helper to build the icon widget (SVG or Network Image)
  Widget _buildIcon(String? imageUrl, bool isActive) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Fallback icon if no image provided
      return const Icon(Icons.error); 
    }

    // Check file extension (basic check)
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: 24,
        height: 24,
        placeholderBuilder: (BuildContext context) => const UnconstrainedBox(
          child: SizedBox(
             width: 20, 
             height: 20, 
             child: CircularProgressIndicator(strokeWidth: 2)
          ),
        ),
      );
    } else {
      // Login for other images (png, jpg, etc.)
      return Image.network(
        imageUrl,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomBarController());
    final ClientHomeController homeController = Get.put(ClientHomeController());
    final appSettingsController = Get.find<AppSettingsController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Widget shimmerCircle(double size) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.simmerColor,
        ),
      );
    }
    
    // Check for large screen/web
    bool isWeb = kIsWeb || MediaQuery.of(context).size.width > 800;

    return Obx(() {
      // 1. Get the dynamic menu list
      final menuList = appSettingsController.bottomAppMenu;
      final homePage = appSettingsController.homePage.value;
      final headerConfig = homePage?.design?.headerMenu;

      // Safety check: if list is empty, return loader
      if (menuList.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Ensure current page index is valid
      if (controller.currentPage.value >= menuList.length) {
         controller.currentPage.value = 0;
      }
      
      // Get current view widget
      final currentItem = menuList[controller.currentPage.value];
      Widget bodyContent = _getWidget(currentItem);

      if (isWeb) {
        // --- WEB / DESKTOP HEADER LAYOUT ---
        return Scaffold(
          // appBar: AppBar(
          //   toolbarHeight: 200,
          //   automaticallyImplyLeading: false,
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   flexibleSpace: Container(
          //     decoration: BoxDecoration(
          //       gradient: AppColors.appbarColor,
          //     ),
          //   ),
          //   titleSpacing: 0,
          //
          //   // Left Side: App Icon
          //   leadingWidth: 100, // Adjust as needed
          //   leading: Padding(
          //     padding: const EdgeInsets.only(left: 20.0),
          //     child: Row(
          //       children: [
          //         UniversalImage(
          //                     url: appSettingsController.logoNameWhite.toString(),
          //                     height: MediaQuery.of(context).size.height * 0.1,
          //                     width: MediaQuery.of(context).size.width * 0.7,
          //                     fit: BoxFit.contain,
          //                   ),
          //         SizedBox(width: screenWidth * 0.010),
          //         GestureDetector(
          //           onTap: () => homeController.changeLocation(),
          //           child: headerConfig?.currentLocation == true
          //               ? Row(
          //             children: [
          //               Icon(
          //                 Icons.place_outlined,
          //                 color: AppColors.appTextColor,
          //               ),
          //               Obx(
          //                     () => SizedBox(
          //                   width: screenWidth * 0.05,
          //                   child: Marquee(
          //                     child: Text(
          //                       homeController
          //                           .currentLocation
          //                           .value
          //                           .isEmpty
          //                           ? 'Fetching location...'
          //                           : homeController
          //                           .currentLocation
          //                           .value,
          //                       style: AppTextStyle.description(
          //                         color: AppColors.appTextColor,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           )
          //               : SizedBox.shrink(),
          //         ),
          //       ],
          //     ),
          //   ),
          //
          //   // Center: Menu Items
          //   title: Column(
          //     children: [
          //       // 🔎 Dynamic Search Bar
          //       Builder(
          //         builder: (context) {
          //           final bodySections = homePage?.design?.body;
          //
          //           if (bodySections == null || bodySections.isEmpty) {
          //             return const SizedBox.shrink();
          //           }
          //
          //           final searchSection = bodySections.firstWhereOrNull(
          //                 (section) => section.viewType == 'search_bar',
          //           );
          //
          //           if (searchSection == null) {
          //             return const SizedBox.shrink();
          //           }
          //
          //           return SizedBox(
          //             width: 250,
          //             child: CustomViewWidget(
          //               type: 'search_bar',
          //               title: searchSection.title,
          //               bgColor: searchSection.bgColor,
          //               // bgImg: searchSection.bgImg,
          //               nextPageName: searchSection.nextPageName,
          //             ),
          //           );
          //         },
          //       ),
          //       Wrap(
          //         alignment: WrapAlignment.center,
          //         spacing: 25,
          //         children: menuList.asMap().entries.map((entry) {
          //           int index = entry.key;
          //           AppMenuItem item = entry.value;
          //           bool isActive = controller.currentPage.value == index;
          //
          //           return MouseRegion(
          //             cursor: SystemMouseCursors.click,
          //             child: GestureDetector(
          //               onTap: () => controller.onItemTapped(index),
          //               child: AnimatedContainer(
          //                 duration: const Duration(milliseconds: 200),
          //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(6),
          //                   color: isActive
          //                       ? Colors.white.withOpacity(0.15)
          //                       : Colors.transparent,
          //                 ),
          //                 child: Text(
          //                   item.label ?? "",
          //                   style: AppTextStyle.description(
          //                     color: AppColors.appTextColor,
          //                   ).copyWith(
          //                     fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         }).toList(),
          //       ),
          //
          //     ],
          //   ),
          //
          //   // Right Side: Menu Dropdown
          //   actions: [
          //     if (headerConfig?.headerMenu != null)
          //       ...headerConfig!.headerMenu!
          //           .where((item) => item.isActive == true)
          //           .map((item) {
          //         final String label = (item.label?.isNotEmpty == true)
          //             ? item.label!
          //             : (item.title?.isNotEmpty == true
          //             ? item.title!
          //             : "Menu");
          //
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: InkWell(
          //             onTap: () {
          //               if (item.nextPageName == "invite_screen") {
          //                 final controller = Get.put(ProfileController());
          //                 String code = controller.profileDetailsResponeModel.value
          //                     ?.result?.hidden?.referralCode ??
          //                     "";
          //
          //                 CustomNavigator.navigate(
          //                   "invite_screen",
          //                   arguments: {
          //                     'menuItem': item,
          //                     'referralCode': code,
          //                   },
          //                 );
          //               } else {
          //                 CustomNavigator.navigate(
          //                   item.nextPageName,
          //                   arguments: item,
          //                 );
          //               }
          //             },
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 if (item.icon != null && item.icon!.isNotEmpty)
          //                   UniversalImage(
          //                     url: item.icon!,
          //                     height: 22,
          //                     width: 22,
          //                     fit: BoxFit.contain,
          //                   )
          //                 else
          //                   Icon(
          //                     Icons.circle,
          //                     size: 8,
          //                     color: AppColors.appTextColor,
          //                   ),
          //                 const SizedBox(height: 4),
          //                 Text(
          //                   label,
          //                   style: AppTextStyle.description(
          //                     color: AppColors.appTextColor,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       }).toList(),
          //     const SizedBox(width: 20),
          //   ],
          //
          // ),
          body: Column(
            children: [
              /// =========================
              /// 🔵 TOP HEADER SECTION
              /// =========================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  gradient: AppColors.appbarColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [

                    /// -------- TOP ROW (Logo + Location + Search + Right Icons) -------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        /// LOGO
                        UniversalImage(
                          url: appSettingsController.logoNameWhite.toString(),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(width: 25),

                        /// LOCATION
                        if (headerConfig?.currentLocation == true)
                          GestureDetector(
                            onTap: () => homeController.changeLocation(),
                            child: headerConfig?.currentLocation == true
                                ? Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: AppColors.appTextColor,
                                ),
                                Obx(
                                      () => SizedBox(
                                    width: screenWidth * 0.16,
                                    child: Marquee(
                                      child: Text(
                                        homeController
                                            .currentLocation
                                            .value
                                            .isEmpty
                                            ? 'Fetching location...'
                                            : homeController
                                            .currentLocation
                                            .value,
                                        style: AppTextStyle.description(
                                          color: AppColors.appTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : SizedBox.shrink(),
                          ),

                        const Spacer(),

                        /// SEARCH BAR (Responsive)
                        SizedBox(
                          width: screenWidth * 0.35,
                          child: Builder(
                            builder: (context) {
                              final bodySections = homePage?.design?.body;

                              if (bodySections == null || bodySections.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final searchSection = bodySections.firstWhereOrNull(
                                    (section) => section.viewType == 'search_bar',
                              );

                              if (searchSection == null) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(
                                width: 250,
                                child: CustomViewWidget(
                                  type: 'search_bar',
                                  title: searchSection.title,
                                  bgColor: searchSection.bgColor,
                                  // bgImg: searchSection.bgImg,
                                  nextPageName: searchSection.nextPageName,
                                ),
                              );
                            },
                          ),
                        ),

                        const Spacer(),

                        /// RIGHT SIDE HEADER ICONS
                        if (headerConfig?.headerMenu != null)
                          ...headerConfig!.headerMenu!
                              .where((item) => item.isActive == true)
                              .map((item) {
                            final String label = (item.label?.isNotEmpty == true)
                                ? item.label!
                                : (item.title?.isNotEmpty == true
                                ? item.title!
                                : "Menu");

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: InkWell(
                                onTap: () {
                                  if (item.nextPageName == "invite_screen") {
                                    final controller = Get.put(ProfileController());
                                    String code = controller.profileDetailsResponeModel.value
                                        ?.result?.hidden?.referralCode ??
                                        "";

                                    CustomNavigator.navigate(
                                      "invite_screen",
                                      arguments: {
                                        'menuItem': item,
                                        'referralCode': code,
                                      },
                                    );
                                  } else {
                                    CustomNavigator.navigate(
                                      item.nextPageName,
                                      arguments: item,
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (item.icon != null && item.icon!.isNotEmpty)
                                      UniversalImage(
                                        url: item.icon!,
                                        height: 22,
                                        width: 22,
                                        fit: BoxFit.contain,
                                      )
                                    else
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: AppColors.appTextColor,
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      label,
                                      style: AppTextStyle.description(
                                        color: AppColors.appTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// -------- MENU ITEMS ROW --------
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 30,
                      children: menuList.asMap().entries.map((entry) {
                        int index = entry.key;
                        AppMenuItem item = entry.value;
                        bool isActive =
                            controller.currentPage.value == index;

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () =>
                                controller.onItemTapped(index),
                            child: AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(6),
                                color: isActive
                                    ? Colors.white.withOpacity(0.15)
                                    : Colors.transparent,
                              ),
                              child: Text(
                                item.label ?? "",
                                style:
                                AppTextStyle.description(
                                  color:
                                  AppColors.appTextColor,
                                ).copyWith(
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// =========================
              /// 🔘 BODY CONTENT
              /// =========================
              Expanded(
                child: bodyContent,
              ),
            ],
          ),
        );
      } else {
        // --- MOBILE BOTTOM NAV LAYOUT ---
        return Scaffold(
          body: bodyContent,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: BottomNavigationBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentPage.value,
              onTap: controller.onItemTapped,
              selectedItemColor: AppColors.appColor,
              unselectedItemColor: AppColors.textgrey,
              selectedLabelStyle: AppTextStyle.description(color: AppColors.appColor),
              unselectedLabelStyle: AppTextStyle.description(color: AppColors.textgrey),
              showUnselectedLabels: true,
              items: menuList.map((item) {
                // Determine active state for icon if needed, though usually handled by mapped index 
                // but here for simplified item creation
                return BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: _buildIcon(item.bgImg, false),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: _buildIcon(item.bgImg, true), // Could add color filter if needed
                  ),
                  label: item.label ?? "",
                );
              }).toList(),
            ),
          ),
        );
      }
    });
  }
}
