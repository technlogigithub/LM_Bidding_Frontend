import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:libdding/view/transaction/transaction_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../controller/post/My_Post_controller.dart';
import '../../controller/my_orders/my_orders_controller.dart';
import '../../widget/app_appbar.dart';
import '../seller screen/buyer request/buyer_request.dart';
import '../seller screen/report/seller_report_screen.dart';
import '../seller screen/withdraw_money/withdraw_history.dart';
import 'Dashboard_screen.dart';
import 'My Orders/my_orders_screen.dart';
import 'deposit_history_screen.dart';
import 'Invite_screen.dart';
import 'My Posts/my_post_screen.dart';
import 'setting_screen.dart';
import 'favorite_screen.dart';
import 'help_support_screen.dart';
import 'my_profile_screen.dart';
import '../../widget/custom_navigator.dart';
import '../../widget/app_image_handle.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final appController = Get.find<AppSettingsController>();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = kIsWeb || screenWidth > 800;

    final Color text = AppColors.appTitleColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isWeb ? AppColors.appPagecolor : AppColors.appbarColor,
        ),
        child: Column(
          children: [
            if (!isWeb) SizedBox(height: screenHeight * 0.04),

            /// ---------------- HEADER WITH OBX  ----------------
            if (!isWeb)
            Obx(() {
              if (controller.isLoading.value) {
                return _buildHeaderShimmer();
              }

              return CustomHeader(
                username: controller.profileDetailsResponeModel.value?.result?.basicInfo?.name ?? "User",
                balance: double.tryParse(
                    controller.profileDetailsResponeModel.value?.result?.hidden?.walletBalance ?? "0") ??
                    0.0,
                images: controller.profileDetailsResponeModel.value?.result?.dp?.dp ?? "",
              );
            }),

            Expanded(
              child: SingleChildScrollView(
                // physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      gradient: AppColors.appPagecolor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        /// ---------------- DYNAMIC MENU LIST ----------------
                        Obx(() {
                          final menuList = appController.appMenu;
                          
                          // Filter out config items (no label) and inactive items
                          final visibleItems = menuList.where((item) {
                            return item.label != null && 
                                   item.label!.isNotEmpty && 
                                   item.isActive == true;
                          }).toList();

                          return Column(
                            children: visibleItems.map((item) {
                              return ListTile(
                                onTap: () => _handleItemClick(context, item),
                                visualDensity: const VisualDensity(vertical: -3),
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.only(bottom: 20),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: _buildDecoration(item.bgColor),
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: UniversalImage(
                                      url: item.bgImg ?? "",
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain,
                                      // color: item.bgImg!.endsWith(".svg") ? null :  null, // Optional: Apply tint if needed, but usually images are full color
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.label ?? "", 
                                  maxLines: 1, 
                                  style: AppTextStyle.description(color: text)
                                ),
                                trailing: Icon(FeatherIcons.chevronRight, color: text),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.darkWhite,
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Container(
              height: 50,
              width: 50,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColors.appWhite),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.appMutedColor,
                  highlightColor: AppColors.appMutedTextColor,
                  child: Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.appMutedColor,
                  highlightColor: AppColors.appMutedTextColor,
                  child: Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return  BoxDecoration(
        shape: BoxShape.circle, 
        gradient: AppColors.appPagecolor
      );
    }
    
    // Check for gradient
    if (colorString.toLowerCase().contains("linear-gradient")) {
       try {
         final regex = RegExp(r'#(?:[0-9a-fA-F]{3,8})');
         final matches = regex.allMatches(colorString);
         List<Color> colors = [];
         for (final match in matches) {
           String hex = match.group(0)!;
           colors.add(_parseColor(hex));
         }
         if (colors.length >= 2) {
           return BoxDecoration(
             shape: BoxShape.circle,
             gradient: LinearGradient(
               colors: colors,
               begin: Alignment.centerLeft,
               end: Alignment.centerRight,
             ),
           );
         } else if (colors.isNotEmpty) {
           return BoxDecoration(shape: BoxShape.circle, color: colors.first);
         }
       } catch (e) {
         print("Error parsing gradient: $e");
       }
    }

    // Try parsing as single color
    try {
      return BoxDecoration(
        shape: BoxShape.circle,
        color: _parseColor(colorString),
      );
    } catch (e) {
      return  BoxDecoration(shape: BoxShape.circle, gradient: AppColors.appPagecolor);
    }
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll("#", "");
    hex = hex.replaceAll(")", ""); // Remove cleanup
    hex = hex.replaceAll(" ", "");
    
    if (hex.length == 6) {
      hex = "FF$hex"; // Add Alpha
    } else if (hex.length == 8) {
       // CSS likes #RRGGBBAA but usually Flutter wants 0xAARRGGBB
       // If backend sends standard Hex 8 digit, it depends on their format.
       // Assuming CSS Format #RRGGBBAA -> Flutter need to move AA to front.
       // However, often backend just sends ARGB or RGBA.
       // If I simply use int.parse, it assumes AARRGGBB.
       // Let's assume the string is already compatible or standard hex.
       // The user prompt showed #ffffffff which is White. 
       // If it is RRGGBBAA -> FF FF FF FF -> White. 
       // If it is AARRGGBB -> FF FF FF FF -> White.
       // So for white it doesn't matter.
    }
    return Color(int.parse("0x$hex"));
  }

  // void _handleItemClick(BuildContext context, dynamic item) async {
  //   // Check for logout
  //   if (item.nextPageName == "log_out_screen" || item.label == "Log Out") {
  //     _showLogoutDialog(context);
  //     return;
  //   }
  //
  //   // Check for login requirement
  //   if (item.loginRequired == true) {
  //     final prefs = await SharedPreferences.getInstance();
  //     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //     if (!isLoggedIn) {
  //       Get.to(() => LoginScreen());
  //       return;
  //     }
  //   }
  //
  //
  //
  //   // Navigate using CustomNavigator with Arguments
  //   if (item.nextPageName != null && item.nextPageName!.isNotEmpty) {
  //
  //     // Override viewType if nextPageViewType is provided
  //     if (item.nextPageViewType != null && item.nextPageViewType!.isNotEmpty) {
  //       item.viewType = item.nextPageViewType;
  //     }
  //
  //     dynamic arguments = item;
  //
  //     // Special handling for Invite Screen to pass Referral Code
  //     if (item.nextPageName == "invite_screen") {
  //        // Need to fetch latest referral code if possible, or use from profileDetails
  //       final controller = Get.find<ProfileController>();
  //        String code = controller.profileDetailsResponeModel.value?.result?.hidden?.referralCode ?? "";
  //        arguments = {
  //          'menuItem': item,
  //          'referralCode': code
  //        };
  //     }
  //
  //     CustomNavigator.navigate(item.nextPageName, arguments: arguments);
  //   }
  // }

  void _handleItemClick(BuildContext context, AppMenuItem item) async {
    // 🔴 Logout Check
    if (item.nextPageName == "log_out_screen" || item.label == "Log Out") {
      _showLogoutDialog(context, title: item.title, description: item.description);
      return;
    }

    // 🔐 Login Required Check
    if (item.loginRequired == true) {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!isLoggedIn) {
        Get.to(() => LoginScreen());
        return;
      }
    }

    // ❌ Condition 3:
    // No nextPageName AND no nextPageApiEndpoint
    if ((item.nextPageName == null || item.nextPageName!.isEmpty) &&
        (item.nextPageApiEndpoint == null ||
            item.nextPageApiEndpoint!.isEmpty)) {
      _showLogoutDialog(context, title: item.title, description: item.description);
      return;
    }

    // ✅ Condition 2:
    // nextPageName AND nextPageApiEndpoint both exist
    if (item.nextPageName != null &&
        item.nextPageName!.isNotEmpty &&
        item.nextPageApiEndpoint != null &&
        item.nextPageApiEndpoint!.isNotEmpty) {

      switch (item.nextPageName) {
        case 'profile_screen':
          final controller = Get.put(ProfileController());
          controller.dynamicEndpoint.value = item.nextPageApiEndpoint!;
          await controller.fetchProfileDetails();
          CustomNavigator.navigate(item.nextPageName!, arguments: item);
          break;

        case 'my_posts_screen':
          final controller = Get.put(MyPostController());
          controller.dynamicEndpoint.value = item.nextPageApiEndpoint!;
          await controller.getPostList();
          CustomNavigator.navigate(item.nextPageName!, arguments: item);
          break;

        case 'my_orders_screen':
          Get.delete<MyOrdersController>(); // Ensure fresh instance to avoid stale status
          final controller = Get.put(MyOrdersController());
          controller.dynamicEndpoint.value = item.nextPageApiEndpoint!;
          // await controller.fetchMyOrderList(); // Removed: Screen handles fetch based on tabs
          CustomNavigator.navigate(item.nextPageName!, arguments: item);
          break;

        default:
          CustomNavigator.navigate(item.nextPageName!, arguments: item);
          break;
      }

      return;
    }

    // ✅ Condition 1:
    // nextPageName exists but no API
    if (item.nextPageName != null && item.nextPageName!.isNotEmpty) {
      CustomNavigator.navigate(item.nextPageName!, arguments: item);
    }
  }


  void _showLogoutDialog(BuildContext context, {String? title, String? description}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Obx(() => Text(
              title != null && title.isNotEmpty ? title : "",
              style: AppTextStyle.title())),
          content: Obx(() => Text(
              description != null && description.isNotEmpty
                  ? description
                  : "",
              style: AppTextStyle.description())),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Obx(() => Text("Cancel",
                  style: AppTextStyle.description(
                      color: AppColors.appBodyTextColor))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Obx(() => Text(
                    "Yes, Logout",
                    style:
                        AppTextStyle.description(color: AppColors.appTextColor),
                  )),
            ),
          ],
        );
      },
    );
  }
}
