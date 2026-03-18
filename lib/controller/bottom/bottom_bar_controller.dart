import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_main/App_main_controller.dart';
import '../home/home_controller.dart';
import '../../core/app_routes.dart';

class BottomBarController extends GetxController {
  var currentPage = 0.obs;
  var isLoggedIn = false.obs;

  final List navItems = [
    {"icon": "home", "label": AppStrings.home},
    {"icon": "chat", "label": AppStrings.message},
    {"icon": "post", "label": AppStrings.postNow},
    {"icon": "doc", "label": AppStrings.participate},
    {"icon": "profile", "label": AppStrings.profile},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    debugPrint("Login Status Loaded: ${isLoggedIn.value}");
  }

  Future<void> onItemTapped(int index) async {
    final appSettingsController = Get.find<AppSettingsController>();
    final homeController = Get.find<ClientHomeController>();
    final menuList = appSettingsController.bottomAppMenu;

    debugPrint("🔘 BottomBar Tap: Index $index");

    if (index < menuList.length) {
      final item = menuList[index];
      debugPrint("📄 Item: ${item.label}, loginRequired: ${item.loginRequired}");

      // Direct check of SharedPreferences to be absolutely sure
      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.getString('auth_token')?.isNotEmpty ?? false;
      final isLogged = homeController.isLoggedIn.value || hasToken;

      debugPrint("🔑 Login Status -> Controller: ${homeController.isLoggedIn.value}, Token: $hasToken");

      if (item.loginRequired == true && !isLogged) {
        debugPrint("🚫 Auth Required! Redirecting to Login.");
        // Redirect to login screen if login is required but user is not logged in
        Get.toNamed(AppRoutes.login);
        return;
      }
    }

    currentPage.value = index;
  }
}