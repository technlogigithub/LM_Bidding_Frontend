import 'package:get/get.dart';
import 'package:libdding/widget/post_detail_screen.dart';
import '../view/Participate_screens/participate_screen.dart';
import '../view/Post_new_screen/post_new_screen.dart';
import '../view/post_details_service/cart_preview.dart';
import '../view/post_details_service/cart_screen.dart';
import '../view/Onboard_screen/onboard_screen.dart';
import '../view/profile_screens/Dashboard_screen.dart';
import '../view/profile_screens/Invite_screen.dart';
import '../view/profile_screens/My Orders/my_orders_screen.dart';
import '../view/profile_screens/My Orders/order_details_screen.dart';
import '../view/profile_screens/My Orders/invoice_screen.dart';
import '../view/profile_screens/My Posts/my_post_screen.dart';
import '../view/profile_screens/deposit_history_screen.dart';
import '../view/profile_screens/favorite_screen.dart';
import '../view/profile_screens/help_support_screen.dart';
import '../view/profile_screens/my_profile_screen.dart';
import '../view/profile_screens/profile_screen.dart';
import '../view/profile_screens/setting_screen.dart';
import '../view/seller screen/buyer request/buyer_request.dart';
import '../view/seller screen/report/seller_report_screen.dart';
import '../view/seller screen/seller messgae/chat_list.dart';
import '../view/seller screen/withdraw_money/withdraw_history.dart';
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
import '../models/App_moduls/AppResponseModel.dart';

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
      case "message_screen":
        Get.to(() => const ChatListScreen());
        break;

      case "post_new_screen":
        Get.to(() => PostNewScreen(
            apiEndpoint: arguments is AppMenuItem ? arguments.nextPageApiEndpoint : null
        ));
        break;

      case "participate_screen":
        Get.to(() => const ParticipateScreen());
        break;

      case "profile_screen":
        Get.to(() =>  ProfileScreen());
        break;
      case "cart_screen":
        Get.to(() => const CartScreen());
        break;

      case "cart_preview":
        Get.to(() => const CartPreview());
        break;

      case "order_details_screen":
        Get.to(() => const OrderDetailsScreen());
        break;

      case "invoice_screen":
        if (arguments is String) {
          Get.to(() => InvoiceScreen(htmlContent: arguments));
        } else {
          print("⚠️ invoice_screen requires String arguments");
        }
        break;
        case "my_profile_screen":
        Get.to(() => const MyProfileScreen());
        break;

      case "dashboard_screen":
        Get.to(() => const DashBoardScreen());
        break;

      case "my_posts_screen":
        Get.to(() => MyPostScreen(menuItem: arguments is AppMenuItem ? arguments : null));
        break;

      case "my_orders_screen":
        Get.to(() => MyOrdersScreen(menuItem: arguments is AppMenuItem ? arguments : null));
        break;

      case "buyer_requests_screen":
        Get.to(() => const BuyerRequestScreen());
        break;

      case "deposit_screen":
        Get.to(() => const DepositHistory());
        break;

      case "withdraw_screen":
        Get.to(() => const WithDrawHistory());
        break;

      case "favorite_screen":
        Get.to(() => const FavoriteScreen());
        break;

      case "seller_request_screen":
        Get.to(() => const SellerReportScreen());
        break;

      case "settings_screen":
        Get.to(() => SettingScreen(menuItem: arguments is AppMenuItem ? arguments : null));
        break;

      case "invite_screen":
        if (arguments is Map) {
           Get.to(() => InviteScreen(
             referralCode: arguments['referralCode'] ?? "",
             menuItem: arguments['menuItem'] as AppMenuItem?,
           ));
        } else {
           print("⚠️ invite_screen requires Map arguments");
        }
        break;

      case "help_and_support_screen":
        Get.to(() => HelpSupportScreen(menuItem: arguments is AppMenuItem ? arguments : null));
        break;

      //
      // case "log_out_screen":
      //   logoutUser(); // apna logout function call karo
      //   break;

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




