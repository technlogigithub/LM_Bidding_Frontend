import 'package:get/get.dart';
import 'package:libdding/widget/post_detail_screen.dart';
import '../view/Post_new_screen/post_new_screen.dart';
import '../view/post_details_service/cart_screen.dart';
import '../view/Onboard_screen/onboard_screen.dart';
import '../view/splash_screen/splash_screen.dart';
import '../view/language_selection/language_selection_screen.dart';
import '../view/force_update/force_update_screen.dart';
import '../view/auth/create_account_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/auth/otp_varification_screen.dart';
import '../view/auth/login_with_mobile_number_screen.dart';
import '../view/Home_screen/home_screen.dart';
import '../view/Home_screen/recently_post_screen.dart';
import '../view/Home_screen/select_categories_screen.dart';
import '../view/notifications/notifications_screen.dart';
import '../view/notifications/notification_detail_screen.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import '../view/Home_screen/search_history_screen.dart';

class CustomNavigator {
  static void navigate(String? routeKey, {dynamic arguments}) {
    
    print(" route leu :$routeKey ");
    if (routeKey == null || routeKey.isEmpty) return;
    print(" route leu :$routeKey ");
    switch (routeKey) {

      case "splash_screen":
        Get.offAll(() => const SplashScreen());
        break;

      case "language_selection_screen":
        Get.to(() => const LanguageSelectionScreen());
        break;

      case "force_update_screen":
        Get.offAll(() => const ForceUpdateScreen());
        break;

      case "onboard_screen":
        Get.offAll(() => const OnBoard());
        break;

      case "create_account_screen":
        Get.to(() =>  CreateAccountScreen());
        break;

      case "login_screen":
        Get.offAll(() =>  LoginScreen());
        break;

      case "otp_varification_screen":
        if (arguments == null || arguments is! String) {
          print("⚠️ otp_varification_screen requires String mobile");
          return;
        }
        Get.to(() => OtpVarificationScreen(mobile: arguments));
        break;

      case "login_with_mobile_number_screen":
        Get.to(() =>  LoginWithMobileNoScreen());
        break;

      case "home_screen":
        Get.offAll(() =>  HomeScreen());
        break;

      case "notifications_screen":
        Get.to(() => const NotificationsScreen());
        break;

      case "notification_detail_screen":
        if (arguments == null || arguments is! Map) {
          print("⚠️ notification_detail_screen requires Map data");
          return;
        }
        Get.to(() => NotificationDetailScreen(notification: arguments));
        break;

      case "recently_post_screen":
        Get.to(() => const RecentlyPost());
        break;

      case "select_categories_screen":
      case "select_category": // Alias
        Get.to(() => const SelectCategoriesScreen());
        break;

      case "search_filter_screen":
      case "search_page": // Alias
        Get.to(() => SearchFilterScreen(initialFilter: arguments), arguments: arguments);
        break;

      case "search_history_screen":
        Get.to(() => const SearchHistoryScreen());
        break;

      case "post_new_screen":
        Get.to(() => const PostNewScreen());
        break;

      case "cart_screen":
        Get.to(() => const CartScreen());
        break;

      case "post_detail_screen":
        String? ukey;
        if (arguments is String) {
          ukey = arguments;
        }
        Get.to(() => PostDetailScreen(
          ukey: ukey,
        ));
        break;



      default:
        print("⚠️ Unknown navigation key: $routeKey");
    }
  }
}




