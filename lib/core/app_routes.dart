import 'dart:io';
import 'package:libdding/view/profile_screens/Dashboard_screen.dart';

import 'package:get/get.dart';
import 'package:libdding/bindings/profile_binding.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart';
import 'package:libdding/view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import 'package:libdding/view/Home_screen/home_screen.dart';
import 'package:libdding/view/Home_screen/recently_post_screen.dart';
import 'package:libdding/view/Home_screen/select_categories_screen.dart';
import 'package:libdding/view/Mesaage_screens/Message_screen.dart';
import 'package:libdding/view/Onboard_screen/onboard_screen.dart';
import 'package:libdding/view/Participate_screens/participate_details_screen.dart';
import 'package:libdding/view/Participate_screens/participate_screen.dart';
import 'package:libdding/view/Post_new_screen/post_new_screen.dart';
import 'package:libdding/widget/post_detail_screen.dart';
import 'package:libdding/view/auth/create_account_screen.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:libdding/view/auth/login_with_mobile_number_screen.dart';
import 'package:libdding/view/auth/otp_varification_screen.dart';
import 'package:libdding/view/client%20orders/client_order_details.dart';
import 'package:libdding/view/client%20orders/client_orders.dart';
import 'package:libdding/view/client%20review/client_review.dart';
import 'package:libdding/view/force_update/force_update_screen.dart';
import 'package:libdding/view/image_view_screen/image_view_screen.dart';
import 'package:libdding/view/language_selection/language_selection_screen.dart';
import 'package:libdding/view/notifications/notification_detail_screen.dart';
import 'package:libdding/view/notifications/notifications_screen.dart';
import 'package:libdding/view/post_details_service/cart_preview.dart';
import 'package:libdding/view/post_details_service/cart_screen.dart';
import 'package:libdding/view/post_details_service/client_service_details.dart';
import 'package:libdding/view/profile_screens/Invite_screen.dart';
import 'package:libdding/view/profile_screens/My%20Orders/invoice_screen.dart';
import 'package:libdding/view/profile_screens/My%20Orders/my_orders_screen.dart';
import 'package:libdding/view/profile_screens/My%20Orders/order_details_screen.dart';
import 'package:libdding/view/profile_screens/My%20Posts/my_post_details_screen.dart';
import 'package:libdding/view/profile_screens/My%20Posts/my_post_screen.dart';
import 'package:libdding/view/profile_screens/deposit_history_screen.dart';
import 'package:libdding/view/profile_screens/dynamic_profile_form_screen.dart';
import 'package:libdding/view/profile_screens/favorite_screen.dart';
import 'package:libdding/view/profile_screens/help_support_screen.dart';
import 'package:libdding/view/profile_screens/my_profile_screen.dart';
import 'package:libdding/view/profile_screens/setting_screen.dart';
import 'package:libdding/view/review_screen/review_screen.dart';
import 'package:libdding/view/search_filter_post/search_filter_screen.dart';
import 'package:libdding/view/seller%20screen/seller%20authentication/seller_forgot_password.dart';
import 'package:libdding/view/seller%20screen/seller%20authentication/seller_log_in.dart';
import 'package:libdding/view/seller%20screen/seller%20authentication/seller_sign_up.dart';
import 'package:libdding/view/seller%20screen/seller%20authentication/verification.dart';
import 'package:libdding/view/seller%20screen/seller%20home/seller_home_screen.dart';
import 'package:libdding/view/seller screen/add payment method/seller_add_payment_method.dart';
import 'package:libdding/view/seller screen/buyer request/buyer_request.dart';
import 'package:libdding/view/seller screen/favourite/seller_favourite_list.dart';
import 'package:libdding/view/seller screen/notification/seller_notification.dart';
import 'package:libdding/view/seller screen/orders/seller_orders.dart';
import 'package:libdding/view/seller screen/profile/seller_profile.dart';
import 'package:libdding/view/seller screen/report/seller_report_screen.dart';
import 'package:libdding/view/seller screen/seller messgae/chat_list.dart';
import 'package:libdding/view/seller screen/seller services/create_service.dart';
import 'package:libdding/view/seller screen/setting/seller_setting.dart';
import 'package:libdding/view/seller screen/setup%20seller%20profile/setup_profile.dart';
import 'package:libdding/view/seller screen/transaction/seller_transaction.dart';
import 'package:libdding/view/seller screen/orders/seller_deliver_order.dart';
import 'package:libdding/view/seller screen/orders/seller_order_review.dart';
import 'package:libdding/view/seller screen/seller home/my service/my_service.dart';
import 'package:libdding/view/seller screen/seller home/my service/service_details.dart';
import 'package:libdding/view/seller screen/seller messgae/chat_inbox.dart';
import 'package:libdding/view/seller screen/withdraw_money/seller_withdraw_money.dart';
import 'package:libdding/view/seller screen/orders/seller_order_details.dart';
import 'package:libdding/view/seller screen/buyer request/buyer_request_details.dart';
import 'package:libdding/view/seller screen/seller services/create_new_service.dart';
import 'package:libdding/view/seller screen/profile/seller_profile_details.dart';
import 'package:libdding/view/seller screen/profile/seller_edit_profile_details.dart';
import 'package:libdding/view/seller screen/withdraw_money/withdraw_history.dart';
import 'package:libdding/view/splash_screen/splash_screen.dart';
import 'package:libdding/view/transaction/transaction_screen.dart';
import 'package:libdding/view/video_view_screen/video_view_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String createAccount = '/create_account';
  static const String loginWithMobile = '/login_with_mobile';
  static const String otpVerification = '/otp_verification';
  static const String bottomNav = '/bottom_nav';
  static const String postNew = '/post_new';
  static const String participate = '/participate';
  static const String participateDetails = '/participate_details';
  static const String myOrders = '/my_orders';
  static const String orderDetails = '/order_details';
  static const String myPosts = '/my_posts';
  static const String myPostDetails = '/my_post_details';
  static const String clientOrders = '/client_orders';
  static const String clientOrderDetails = '/client_order_details';
  static const String clientServiceDetails = '/client_service_details';
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notification_detail';
  static const String searchFilter = '/search_filter';
  static const String cart = '/cart';
  static const String cartPreview = '/cart_preview';
  static const String review = '/review';
  static const String clientReview = '/client_review';
  static const String transactions = '/transactions';
  static const String dynamicProfileForm = '/dynamic_profile_form';
  static const String forceUpdate = '/force_update';
  static const String imageView = '/image_view';
  static const String videoView = '/video_view';
  static const String languageSelection = '/language_selection';
  static const String message = '/message';
  static const String recentlyPost = '/recently_post';
  static const String onBoarding = '/on_boarding';
  static const String invoice = '/invoice';
  static const String invite = '/invite';
  static const String settings = '/settings';
  static const String helpSupport = '/help_support';
  static const String depositHistory = '/deposit_history';
  static const String favorite = '/favorite';
  static const String selectCategories = '/select_categories';
  static const String dashboard = '/dashboard';
  static const String postDetails = '/post_details';

  // Seller Routes
  static const String sellerHome = '/seller_home';
  static const String sellerLogin = '/seller_login';
  static const String sellerSignUp = '/seller_sign_up';
  static const String sellerForgotPassword = '/seller_forgot_password';
  static const String sellerOtpVerification = '/seller_otp_verification';
  static const String sellerSetupProfile = '/seller_setup_profile';
  static const String sellerAddPaymentMethod = '/seller_add_payment_method';
  static const String sellerBuyerRequest = '/seller_buyer_request';
  static const String sellerFavList = '/seller_fav_list';
  static const String sellerOrders = '/seller_orders';
  static const String sellerChatList = '/seller_chat_list';
  static const String sellerCreateService = '/seller_create_service';
  static const String sellerSettings = '/seller_settings';
  static const String sellerTransactions = '/seller_transactions';
  static const String sellerWithdrawMoney = '/seller_withdraw_money';
  static const String sellerReport = '/seller_report';
  static const String sellerNotifications = '/seller_notifications';
  static const String sellerProfile = '/seller_profile';
  static const String sellerOrderDetails = '/seller_order_details';
  static const String sellerBuyerRequestDetails = '/seller_buyer_request_details';
  static const String sellerCreateNewService = '/seller_create_new_service';
  static const String sellerProfileDetails = '/seller_profile_details';
  static const String sellerEditProfile = '/seller_edit_profile';
  static const String sellerWithdrawHistory = '/seller_withdraw_history';
  static const String sellerChatInbox = '/seller_chat_inbox';
  static const String sellerMyServices = '/seller_my_services';
  static const String sellerServiceDetails = '/seller_service_details';
  static const String sellerDeliverOrder = '/seller_deliver_order';
  static const String sellerOrderReview = '/seller_order_review';
}

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const MyProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.createAccount,
      page: () => CreateAccountScreen(),
    ),
    GetPage(
      name: AppRoutes.loginWithMobile,
      page: () => LoginWithMobileNoScreen(),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () {
        final args = Get.arguments ?? {};
        return OtpVarificationScreen(
          mobile: args['mobile'] ?? '',
          otp: args['otp'],
        );
      },
    ),
    GetPage(
      name: AppRoutes.bottomNav,
      page: () => const BottomNavigationScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.postNew,
      page: () => const PostNewScreen(),
    ),
    GetPage(
      name: AppRoutes.participate,
      page: () => const ParticipateScreen(),
    ),
    GetPage(
      name: AppRoutes.participateDetails,
      page: () => const ParticipateDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.myOrders,
      page: () => const MyOrdersScreen(),
    ),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => const OrderDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.myPosts,
      page: () => const MyPostScreen(),
    ),
    GetPage(
      name: AppRoutes.myPostDetails,
      page: () => const MyPostDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.clientOrders,
      page: () => const ClientOrderList(),
    ),
    GetPage(
      name: AppRoutes.clientOrderDetails,
      page: () => const ClientOrderDetails(),
    ),
    GetPage(
      name: AppRoutes.clientServiceDetails,
      page: () => const ClientServiceDetails(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.notificationDetail,
      page: () => NotificationDetailScreen(
        notification: Get.arguments?['notificationData'],
      ),
    ),
    GetPage(
      name: AppRoutes.searchFilter,
      page: () {
        final args = Get.arguments ?? {};
        return SearchFilterScreen(
          initialFilter: args['initialFilter'],
        );
      },
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: AppRoutes.cartPreview,
      page: () => const CartPreview(),
    ),
    GetPage(
      name: AppRoutes.review,
      page: () => const ReviewScreen(),
    ),
    GetPage(
      name: AppRoutes.clientReview,
      page: () => const ClientOrderReview(),
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => TransactionScreen(),
    ),
    GetPage(
      name: AppRoutes.selectCategories,
      page: () => const SelectCategoriesScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashBoardScreen(),
    ),
    GetPage(
      name: AppRoutes.dynamicProfileForm,
      page: () => const DynamicProfileFormScreen(),
    ),
    GetPage(
      name: AppRoutes.postDetails,
      page: () => PostDetailScreen(ukey: Get.arguments),
    ),
    GetPage(
      name: AppRoutes.forceUpdate,
      page: () => const ForceUpdateScreen(),
    ),
    GetPage(
      name: AppRoutes.imageView,
      page: () {
        final args = Get.arguments ?? {};
        return ImageViewScreen(
          imageUrl: args['imageUrl'],
          imageFile: args['imageFile'] as File,
        );
      },
    ),
    GetPage(
      name: AppRoutes.videoView,
      page: () {
        final args = Get.arguments ?? {};
        return VideoViewScreen(
          videoUrl: args['videoUrl'],
          videoFile: args['videoFile'] as File?,
        );
      },
    ),
    GetPage(
      name: AppRoutes.languageSelection,
      page: () => const LanguageSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.message,
      page: () => const MessageScreen(),
    ),
    GetPage(
        name: AppRoutes.recentlyPost,
        page: () => const RecentlyPost()
    ),
    GetPage(
      name: AppRoutes.onBoarding,
      page: () => const OnBoard(),
    ),
    GetPage(
      name: AppRoutes.invoice,
      page: () => InvoiceScreen(htmlContent: Get.arguments ?? ''),
    ),
    GetPage(
      name: AppRoutes.invite,
      page: () {
        final args = Get.arguments ?? {};
        return InviteScreen(
          referralCode: args['referralCode'] ?? '',
          menuItem: args['menuItem'] as AppMenuItem?,
        );
      },
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingScreen(menuItem: Get.arguments as AppMenuItem?),
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => HelpSupportScreen(menuItem: Get.arguments as AppMenuItem?),
    ),
    GetPage(
      name: AppRoutes.depositHistory,
      page: () => const DepositHistory(),
    ),
    GetPage(
      name: AppRoutes.favorite,
      page: () => const FavoriteScreen(),
    ),


    // Seller Pages
    GetPage(
      name: AppRoutes.sellerHome,
      page: () => const SellerHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerLogin,
      page: () => const SellerLogIn(),
    ),
    GetPage(
      name: AppRoutes.sellerSignUp,
      page: () => const SellerSignUp(),
    ),
    GetPage(
      name: AppRoutes.sellerForgotPassword,
      page: () => const SellerForgotPassword(),
    ),
    GetPage(
      name: AppRoutes.sellerOtpVerification,
      page: () => const OtpVerification(),
    ),
    GetPage(
      name: AppRoutes.sellerSetupProfile,
      page: () => const SetupSellerProfile(),
    ),
    GetPage(
      name: AppRoutes.sellerAddPaymentMethod,
      page: () => const SellerAddPaymentMethod(),
    ),
    GetPage(
      name: AppRoutes.sellerBuyerRequest,
      page: () => const BuyerRequestScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerFavList,
      page: () => const SellerFavList(),
    ),
    GetPage(
      name: AppRoutes.sellerOrders,
      page: () => const SellerOrderList(),
    ),
    GetPage(
      name: AppRoutes.sellerChatList,
      page: () => const ChatListScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerCreateService,
      page: () => const CreateService(),
    ),
    GetPage(
      name: AppRoutes.sellerSettings,
      page: () => const SellerSetting(),
    ),
    GetPage(
      name: AppRoutes.sellerTransactions,
      page: () => const SellerTransaction(),
    ),
    GetPage(
      name: AppRoutes.sellerWithdrawMoney,
      page: () => const SellerWithdrawMoney(),
    ),
    GetPage(
      name: AppRoutes.sellerReport,
      page: () => const SellerReportScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerNotifications,
      page: () => const SellerNotification(),
    ),
    GetPage(
      name: AppRoutes.sellerProfile,
      page: () => const SellerProfile(),
    ),
    GetPage(
      name: AppRoutes.sellerOrderDetails,
      page: () => const SellerOrderDetails(),
    ),
    GetPage(
      name: AppRoutes.sellerBuyerRequestDetails,
      page: () => const BuyerRequestDetails(),
    ),
    GetPage(
      name: AppRoutes.sellerCreateNewService,
      page: () => const CreateNewService(),
    ),
    GetPage(
      name: AppRoutes.sellerProfileDetails,
      page: () => const SellerProfileDetails(),
    ),
    GetPage(
      name: AppRoutes.sellerEditProfile,
      page: () => const SellerEditProfile(),
    ),
    GetPage(
      name: AppRoutes.sellerWithdrawHistory,
      page: () => const WithDrawHistory(),
    ),
    GetPage(
      name: AppRoutes.sellerChatInbox,
      page: () {
        final args = Get.arguments ?? {};
        return ChatInbox(
          img: args['img'],
          name: args['name'],
        );
      },
    ),
    GetPage(
      name: AppRoutes.sellerMyServices,
      page: () => const MyServices(),
    ),
    GetPage(
      name: AppRoutes.sellerServiceDetails,
      page: () => const ServiceDetails(),
    ),
    GetPage(
      name: AppRoutes.sellerDeliverOrder,
      page: () => const SellerDeliverOrder(),
    ),
    GetPage(
      name: AppRoutes.sellerOrderReview,
      page: () => const SellerOrderReview(),
    ),
  ];
}
