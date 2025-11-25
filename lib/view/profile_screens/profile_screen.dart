import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:libdding/view/transaction/transaction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../widget/app_appbar.dart';
import '../seller screen/buyer request/seller_buyer_request.dart';
import 'Invitescreen.dart';
import 'Setting_screen.dart';
import 'help_support.dart';
import 'my_profile_screen.dart';
class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {


    final controller = Get.put(ProfileController());
    final appController = Get.find<AppSettingsController>();
    final support = appController.support.value;
    final referral = appController.referral.value;
    final setting = appController.settings.value;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final Color text=AppColors.textgrey;
    final TextStyle style= AppTextStyle.kTextStyle.copyWith(color: AppColors.appBlack);

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,   // ⬅ HERE
          ),
          child: Column(
          children: [
            SizedBox(height: screenHeight*0.04,),
            Obx(() {
              if (controller.isLoading.value) {
                return _buildHeaderShimmer();
              }
              return CustomHeader(
                username: controller.profileDetailsResponeModel.value?.result?.basicInfo?.name ?? "",

                balance: double.tryParse(
                    controller.profileDetailsResponeModel.value?.result?.hidden?.walletBalance ?? "0"
                ) ?? 0.0,

                images: controller.profileDetailsResponeModel.value?.result?.dp?.dp ?? "",

                userInfo: controller.userInfo.value,
              );
            }),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight*0.01),
              child: Container(
                padding:  EdgeInsets.only(left: 20.0, right: 20.0),
                width: screenWidth,
                // width: context.width,
                decoration:  BoxDecoration(
                  gradient: AppColors.appPagecolor
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(30.0),
                  //   topRight: Radius.circular(30.0),
                  // ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                  ListTile(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();

                        final bool isLoginRequired = prefs.getBool('profile_form_login_required') ?? true;
                      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                      if (isLoginRequired && !isLoggedIn) {
                        // 🔒 Go to Login Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        // 🚀 Go directly to Profile Setup
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SetupClientProfileView()),
                        );
                      }
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 20),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE2EED8),
                      ),
                      child: Icon(
                        IconlyBold.profile,
                        color: AppColors.appColor,
                      ),
                    ),
                    title: Text(
                      AppStrings.myProfile,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: style,
                    ),
                    trailing: Icon(
                      FeatherIcons.chevronRight,
                      color: text,
                    ),
                  ),


                  ListTile(
                      // onTap: () => const ClientDashBoard().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 20),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE3EDFF),
                        ),
                        child: const Icon(
                          IconlyBold.chart,
                          color: Color(0xFF144BD6),
                        ),
                      ),
                      title: Text(
                          AppStrings.dashboard,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: AppColors.textgrey,
                      ),
                    ),
                    ListTile(
                      onTap: () => Get.to(SellerBuyerReq()),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 20),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD0F1FF),
                        ),
                        child: const Icon(
                          IconlyBold.paper,
                          color: Color(0xFF06AEF3),
                        ),
                      ),
                      title: Text(
                          AppStrings.BuyerRequest,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color:text
                      ),
                    ),
                    ListTile(
                      // onTap: () => const SellerAddPaymentMethod().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFE5E3),
                        ),
                        child: const Icon(
                          IconlyBold.ticketStar,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                      title: Text(
                          AppStrings.addPaymentmethod,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text
                      ),
                    ),
                    Theme(
                      data: ThemeData(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        tilePadding: const EdgeInsets.only(bottom: 10),
                        collapsedIconColor: text,
                        iconColor: text,
                        title: Text(
                            AppStrings.Deposit,
                          style:style
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFEFE0),
                          ),
                          child: const Icon(
                            IconlyBold.wallet,
                            color: Color(0xFFFF7A00),
                          ),
                        ),
                        trailing:  Icon(
                          FeatherIcons.chevronDown,
                          color:text ,
                        ),
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.only(left: 60),
                            title: Text(
                                AppStrings.addDeposit,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:style
                            ),
                            trailing:  Icon(
                              FeatherIcons.chevronRight,
                              color:text ,
                            ),
                            // onTap: () => const AddDeposit().launch(context),
                          ),
                          ListTile(
                            // onTap: () => const DepositHistory().launch(context),
                            visualDensity: const VisualDensity(vertical: -3),
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.only(left: 60),
                            title: Text(
                                AppStrings.depositHistory,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: style
                            ),
                            trailing:  Icon(
                              FeatherIcons.chevronRight,
                              color: text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: ThemeData(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        tilePadding: const EdgeInsets.only(bottom: 10),
                        collapsedIconColor: text,
                        iconColor: text,
                        title: Text(
                          AppStrings.withdraw,
                          style: style,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE2EED8),
                          ),
                          child: Icon(
                            IconlyBold.wallet,
                            color: AppColors.appColor,
                          ),
                        ),
                        trailing:  Icon(
                          FeatherIcons.chevronDown,
                          color: text,
                        ),
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(vertical: -3),
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.only(left: 60),
                            title: Text(
                                AppStrings.withdrawAmount,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: style
                            ),
                            trailing:  Icon(
                              FeatherIcons.chevronRight,
                              color: text,
                            ),
                            // onTap: () =>
                            //     const SellerWithdrawMoney().launch(context),
                          ),
                          ListTile(
                            // onTap: () =>
                            //     const SellerWithDrawHistory().launch(context),
                            visualDensity: const VisualDensity(vertical: -3),
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.only(left: 60),
                            title: Text(
                                AppStrings.withdrawalHistory,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: style
                            ),
                            trailing:  Icon(
                              FeatherIcons.chevronRight,
                              color: text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () => Get.to(TransactionScreen()),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE8E1FF),
                        ),
                        child: const Icon(
                          IconlyBold.ticketStar,
                          color: Color(0xFF7E5BFF),
                        ),
                      ),
                      title: Text(
                          AppStrings.Transaction,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text,
                      ),
                    ),
                    ListTile(
                      // onTap: () => const ClientFavList().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFE5E3),
                        ),
                        child: const Icon(
                          IconlyBold.heart,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                      title: Text(
                        AppStrings.Favorite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:style,
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text,
                      ),
                    ),
                    ListTile(
                      // onTap: () => const ClientReport().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD0F1FF),
                        ),
                        child: const Icon(
                          IconlyBold.document,
                          color: Color(0xFF06AEF3),
                        ),
                      ),
                      title: Text(
                        AppStrings.SellerReport,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text,
                      ),
                    ),
                    setting != null && referral?.isActive == true
                        ?ListTile(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        final bool isLoginRequired = prefs.getBool('setting_login_required') ?? true;
                        final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                        if (isLoginRequired && !isLoggedIn) {
                          // 🔒 Go to Login Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>SettingScreen(),
                            ),
                          );


                        }
                      },
                      // onTap: () => const ClientSetting().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFDDED),
                        ),
                        child: const Icon(
                          IconlyBold.setting,
                          color: Color(0xFFFF298C),
                        ),
                      ),
                      title: Text(
                          AppStrings.Setting  ,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text,
                      ),
                    ):const SizedBox.shrink(),

                    referral != null && referral.isActive == true
                        ? ListTile(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        final bool isLoginRequired = prefs.getBool('invite_login_required') ?? true;
                        final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                        if (isLoginRequired && !isLoggedIn) {
                          // 🔒 Go to Login Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Invitescreen(
                                referralCode: controller.profileDetailsResponeModel.value?.result?.hidden?.referralCode ?? "",
                              ),
                            ),
                          );


                        }
                      },
                      // onTap: () => const ClientInvite().launch(context),
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE2EED8),
                        ),
                        child:  Icon(
                          IconlyBold.addUser,
                          color: AppColors.appColor,
                        ),
                      ),
                      title: Text(
                          AppStrings.inviteFriends,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color: text,
                      ),
                    ):const SizedBox.shrink(),

                  support != null && support.isActive == true
                      ? ListTile(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();

                      final bool isLoginRequired =
                          support.loginRequired ?? true; // from API
                      final bool isLoggedIn =
                          prefs.getBool('isLoggedIn') ?? false;

                      if (isLoginRequired && !isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpSupport()),
                        );
                      }
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE3EDFF),
                      ),
                      child: const Icon(
                        IconlyBold.danger,
                        color: Color(0xFF144BD6),
                      ),
                    ),
                    title: Text(AppStrings.helpSupport,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: style,
                    ),
                    trailing: Icon(
                      FeatherIcons.chevronRight,
                      color: text,
                    ),
                  )
                      : const SizedBox.shrink(),

              ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      leading: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFEFE0),
                        ),
                        child: const Icon(
                          IconlyBold.logout,
                          color: Color(0xFFFF7A00),
                        ),
                      ),
                      title: Text(
                          AppStrings.logOut,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: style
                      ),
                      trailing:  Icon(
                        FeatherIcons.chevronRight,
                        color:text ,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text("Confirm Logout"),
                              content:
                              const Text("Are you sure you want to log out?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // dialog close
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appColor,
                                  ),
                                  onPressed: () async {
                                    final prefs =
                                    await SharedPreferences.getInstance();
                                    await prefs.setBool('isLoggedIn', false);

                                    // replace current page with login page and pass the current page as redirect
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child:  Text(
                                    "Yes, Logout",
                                    style: TextStyle(color: AppColors.darkWhite),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
                ),
        ),)
    );
  }

  Widget _buildHeaderShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.darkWhite,
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 50,
              width: 50,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appWhite,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
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


}
