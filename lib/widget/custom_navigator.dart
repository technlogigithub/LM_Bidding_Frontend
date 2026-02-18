import 'package:get/get.dart';
import 'package:libdding/core/app_routes.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart';


class CustomNavigator {
  static void navigate(String? routeKey, {dynamic arguments}) {
    
    print(" route leu :$routeKey ");
    if (routeKey == null || routeKey.isEmpty) return;
    print(" navigation key :$routeKey ");
    switch (routeKey) {

      case "splash_screen":
        Get.offAllNamed(AppRoutes.splash);
        break;

      case "language_selection_screen":
        Get.toNamed(AppRoutes.languageSelection);
        break;

      case "force_update_screen":
        Get.offAllNamed(AppRoutes.forceUpdate);
        break;

      case "onboard_screen":
        Get.offAllNamed(AppRoutes.onBoarding);
        break;

      case "create_account_screen":
        Get.toNamed(AppRoutes.createAccount);
        break;

      case "login_screen":
        Get.offAllNamed(AppRoutes.login);
        break;

      case "otp_varification_screen":
        if (arguments == null || arguments is! String) {
          print("⚠️ otp_varification_screen requires String mobile");
          return;
        }
        Get.toNamed(AppRoutes.otpVerification, arguments: {'mobile': arguments});
        break;

      case "login_with_mobile_number_screen":
        Get.toNamed(AppRoutes.loginWithMobile);
        break;

      case "home_screen":
        Get.offAllNamed(AppRoutes.home);
        break;

      case "notifications_screen":
        Get.toNamed(AppRoutes.notifications);
        break;

      case "notification_detail_screen":
        if (arguments == null || arguments is! Map) {
          print("⚠️ notification_detail_screen requires Map data");
          return;
        }
        Get.toNamed(AppRoutes.notificationDetail, arguments: arguments);
        break;

      case "recently_post_screen":
        Get.toNamed(AppRoutes.recentlyPost);
        break;

      case "select_categories_screen":
      case "select_category": // Alias
         Get.toNamed(AppRoutes.selectCategories);
        break;

      case "search_filter_screen":
      case "search_page": // Alias
        Get.toNamed(AppRoutes.searchFilter, arguments: {
          'initialFilter': arguments
        });
        break;

      case "search_history_screen":
        // Get.toNamed(AppRoutes.searchHistory); // If route exists
        break;
        
      case "message_screen":
        Get.toNamed(AppRoutes.message);
        break;

      case "post_new_screen":
        Get.toNamed(AppRoutes.postNew, arguments: {
          'categoryName': arguments is AppMenuItem ? arguments.nextPageApiEndpoint : null
        });
        break;

      case "participate_screen":
        Get.toNamed(AppRoutes.participate);
        break;

      case "profile_screen":
        Get.toNamed(AppRoutes.profile);
        break;
        
      case "cart_screen":
        Get.toNamed(AppRoutes.cart);
        break;

      case "cart_preview":
         Get.toNamed(AppRoutes.cartPreview); 
        break;

      case "order_details_screen":
        Get.toNamed(AppRoutes.orderDetails);
        break;

      case "invoice_screen":
        if (arguments is String) {
          Get.toNamed(AppRoutes.invoice, arguments: arguments);
        } else {
          print("⚠️ invoice_screen requires String arguments");
        }
        break;
        
      case "my_profile_screen":
        // Assuming this maps to dynamic profile or profile
        Get.toNamed(AppRoutes.profile); 
        break;

      case "dashboard_screen":
        Get.toNamed(AppRoutes.dashboard);
        break;

      case "my_posts_screen":
        Get.toNamed(AppRoutes.myPosts, arguments: arguments is AppMenuItem ? arguments : null);
        break;

      case "my_orders_screen":
        Get.toNamed(AppRoutes.myOrders, arguments: arguments is AppMenuItem ? arguments : null);
        break;

      case "buyer_requests_screen":
        Get.toNamed(AppRoutes.sellerBuyerRequest);
        break;

      case "deposit_screen":
        Get.toNamed(AppRoutes.depositHistory);
        break;

      case "withdraw_screen":
        Get.toNamed(AppRoutes.sellerWithdrawHistory);
        break;

      case "favorite_screen":
        Get.toNamed(AppRoutes.favorite);
        break;

      case "seller_request_screen":
        Get.toNamed(AppRoutes.sellerReport);
        break;

      case "settings_screen":
        Get.toNamed(AppRoutes.settings, arguments: arguments is AppMenuItem ? arguments : null);
        break;

      case "invite_screen":
        if (arguments is Map) {
           Get.toNamed(AppRoutes.invite, arguments: {
             'referralCode': arguments['referralCode'] ?? "",
             'menuItem': arguments['menuItem'] as AppMenuItem?,
           });
        } else {
           print("⚠️ invite_screen requires Map arguments");
        }
        break;

      case "help_and_support_screen":
        Get.toNamed(AppRoutes.helpSupport, arguments: arguments is AppMenuItem ? arguments : null);
        break;

      case "post_detail_screen":
        String? ukey;
        if (arguments is String) {
          ukey = arguments;
        }
        Get.toNamed(AppRoutes.postDetails, arguments: ukey, parameters: ukey != null ? {'ukey': ukey} : null);
        break;

      default:
        print("⚠️ Unknown navigation key: $routeKey");
    }
  }
}




