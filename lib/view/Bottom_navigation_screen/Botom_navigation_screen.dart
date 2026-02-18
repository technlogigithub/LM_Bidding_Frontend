import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/bottom/bottom_bar_controller.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_navigator.dart'; // Added import
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
    final appSettingsController = Get.find<AppSettingsController>();
    
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
              ),
            ),
            titleSpacing: 0,
            
            // Left Side: App Icon
            leadingWidth: 100, // Adjust as needed
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: UniversalImage(
                          url: appSettingsController.logoNameWhite.toString(),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.contain,
                        ),
            ),
            
            // Center: Menu Items
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: menuList.asMap().entries.map((entry) {
                int index = entry.key;
                AppMenuItem item = entry.value;
                bool isActive = controller.currentPage.value == index;

                return InkWell(
                  onTap: () => controller.onItemTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Text(
                      item.label ?? "",
                      style: AppTextStyle.description(
                        color: AppColors.appTextColor,
                      ).copyWith(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            // Right Side: Menu Dropdown
            actions: [
              PopupMenuButton<dynamic>(
                icon: Icon(Icons.menu, color: AppColors.appTextColor),
                offset: const Offset(0, 50),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  if (value == 'search') {
                    // Handle search action
                    print("Search Tapped");
                  } else {
                    // Handle dynamic item navigation
                    final item = value; // Type is inferred dynamically
                    if (item != null) {
                      CustomNavigator.navigate(item.nextPageName);
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<dynamic>> items = [];

                  // 1. Fixed Search Item
                  items.add(
                    PopupMenuItem<dynamic>(
                      value: 'search',
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.black54, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "Search",
                            style: AppTextStyle.description(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );

                  // 2. Dynamic Items
                  if (headerConfig?.headerMenu != null) {
                    for (var item in headerConfig!.headerMenu!) {
                      if (item.isActive == false) continue;

                      final String label = (item.label?.isNotEmpty == true)
                          ? item.label!
                          : (item.title?.isNotEmpty == true ? item.title! : "Menu Item");

                      items.add(
                        PopupMenuItem<dynamic>(
                          value: item,
                          child: Row(
                            children: [
                              if (item.icon != null && item.icon!.isNotEmpty) ...[
                                UniversalImage(
                                  url: item.icon!,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 12),
                              ] else ...[
                                const Icon(Icons.circle, size: 8, color: Colors.black26),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Text(
                                  label,
                                  style: AppTextStyle.description(color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  return items;
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: bodyContent,
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
