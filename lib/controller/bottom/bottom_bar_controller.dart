import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void onItemTapped(int index) {
    currentPage.value = index;
  }
}