import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/network.dart';
import '../app_main/App_main_controller.dart';

class NotificationsController extends GetxController {
  static NotificationsController get to => Get.find();

  // Reactive state variables
  final notifications = <dynamic>[].obs;
  final isLoading = true.obs;

  // Get AppSettingsController instance
  final AppSettingsController appController = Get.find<AppSettingsController>();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final token = await appController.getAuthToken();

      final homePage = appController.homePage.value; // <-- HomePage? model
      final headerConfig =
          homePage?.design?.headerMenu; // <-- HeaderMenuSection?
      final apiEndPoints = headerConfig?.headerMenu?[0].apiEndpoint;

      print(" End Points is :$apiEndPoints");

      if (token == null || token.isEmpty) {
        notifications.clear();
        isLoading.value = false;
        toast("Please login to view notifications");
        return;
      }

      final res = await ApiServices().makeRequestRaw(
        endPoint: "notification",
        method: "GET",
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (res['success'] == true && res['result'] != null) {
        notifications.value = res['result'] is List ? res['result'] : [];
      } else {
        notifications.clear();
      }

      // Debug print
      print("Notifications fetched: ${notifications.length}");
      if (notifications.isNotEmpty) {
        print("First notification: ${notifications[0]}");
      }
    } catch (e) {
      notifications.clear();
      toast("Error loading notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
