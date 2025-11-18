import 'package:get/get.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_config.dart';
import '../../core/network.dart';
import '../../models/Profile/profile_response_model.dart';

class ProfileController extends GetxController {
  var notifications = [].obs;
  var isLoading = true.obs;
  var isLoggedIn = false.obs;
  var username = "User Name".obs;
  var balance = 500.00.obs;


  Rx<ProfileDetailsResponeModel?> profileDetailsResponeModel = Rx<ProfileDetailsResponeModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    loadLoginStatus();
    fetchProfileDetails();
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


  Future<void> fetchProfileDetails() async {
    try {
      isLoading.value = true;

      final token = await getAuthToken();

      final res = await ApiServices().makeRequestRaw(
        endPoint: "/profile/details",
        method: "GET",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      // Store response into model variable
      profileDetailsResponeModel.value = ProfileDetailsResponeModel.fromJson(res);

      print("📌 Saved Profile: ${profileDetailsResponeModel.value}");

    } catch (e) {
      print("❌ Profile fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

}
