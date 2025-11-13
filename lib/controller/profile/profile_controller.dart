import 'package:get/get.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_config.dart';

class ProfileController extends GetxController {
  var notifications = [].obs;
  var isLoading = true.obs;
  var isLoggedIn = false.obs;
  var username = "User Name".obs;
  var balance = 500.00.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    loadLoginStatus();
  }

  Future<void> fetchOrders() async {
    try {
      final res = await ApiService.getRequest("ordersApi");
      notifications.value = res["data"] ?? [];
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    isLoggedIn.value = false;
    // navigate to login
    Get.offAll(() =>  LoginScreen());
  }
}
