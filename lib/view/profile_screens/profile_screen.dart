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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color text = AppColors.appTitleColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),

              /// ---------------- HEADER WITH OBX  ----------------
              Obx(() {
                if (controller.isLoading.value) {
                  return _buildHeaderShimmer();
                }

                return CustomHeader(
                  username: controller.profileDetailsResponeModel.value?.result?.basicInfo?.name ?? "",
                  balance: double.tryParse(
                      controller.profileDetailsResponeModel.value?.result?.hidden?.walletBalance ?? "0") ??
                      0.0,
                  images: controller.profileDetailsResponeModel.value?.result?.dp?.dp ?? "",
                  userInfo: controller.userInfo.value,
                );
              }),

              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      ///------------- MY PROFILE (NO OBX required) ----------
                      ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final bool isLoginRequired =
                              prefs.getBool('profile_form_login_required') ?? true;
                          final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                          if (isLoginRequired && !isLoggedIn) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SetupClientProfileView()));
                          }
                        },
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFE2EED8)),
                          child: Icon(IconlyBold.profile, color: AppColors.appColor),
                        ),
                        title: Obx(() => Text(AppStrings.myProfile, maxLines: 1, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- DASHBOARD ----------------
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFE3EDFF)),
                          child: const Icon(IconlyBold.chart, color: Color(0xFF144BD6)),
                        ),
                        title: Obx(() => Text(AppStrings.dashboard, maxLines: 1, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- BUYER REQUEST ----------------
                      ListTile(
                        onTap: () => Get.to(SellerBuyerReq()),
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFD0F1FF)),
                          child: const Icon(IconlyBold.paper, color: Color(0xFF06AEF3)),
                        ),
                        title: Obx(() => Text(AppStrings.BuyerRequest, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- DEPOSIT (STATIC) --------------
                      Theme(
                        data: ThemeData(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          tilePadding: const EdgeInsets.only(bottom: 10),
                          collapsedIconColor: text,
                          iconColor: text,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFFFFEFE0)),
                            child: const Icon(IconlyBold.wallet, color: Color(0xFFFF7A00)),
                          ),
                          title: Obx(() => Text(AppStrings.Deposit, style: AppTextStyle.description(color: text))),
                          trailing: Icon(FeatherIcons.chevronDown, color: text),
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 60),
                              title: Obx(() => Text(AppStrings.addDeposit, maxLines: 1, style: AppTextStyle.description(color: text))),
                              trailing: Icon(FeatherIcons.chevronRight, color: text),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 60),
                              title: Obx(() => Text(AppStrings.depositHistory,
                                  maxLines: 1, style: AppTextStyle.description(color: text))),
                              trailing: Icon(FeatherIcons.chevronRight, color: text),
                            ),
                          ],
                        ),
                      ),

                      /// ---------------- WITHDRAW --------------
                      Theme(
                        data: ThemeData(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          tilePadding: const EdgeInsets.only(bottom: 10),
                          collapsedIconColor: text,
                          iconColor: text,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFFE2EED8)),
                            child: Icon(IconlyBold.wallet, color: AppColors.appColor),
                          ),
                          title: Obx(() => Text(AppStrings.withdraw, style: AppTextStyle.description(color: text))),
                          trailing: Icon(FeatherIcons.chevronDown, color: text),
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 60),
                              title: Obx(() => Text(AppStrings.withdrawAmount, style: AppTextStyle.description(color: text))),
                              trailing: Icon(FeatherIcons.chevronRight, color: text),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 60),
                              title: Obx(() => Text(AppStrings.withdrawalHistory, style: AppTextStyle.description(color: text))),
                              trailing: Icon(FeatherIcons.chevronRight, color: text),
                            ),
                          ],
                        ),
                      ),

                      /// ---------------- TRANSACTION ----------------
                      ListTile(
                        onTap: () => Get.to(TransactionScreen()),
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFE8E1FF)),
                          child: const Icon(IconlyBold.ticketStar, color: Color(0xFF7E5BFF)),
                        ),
                        title: Obx(() => Text(AppStrings.Transaction, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- FAVORITE ----------------
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 15),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFFFE5E3)),
                          child: const Icon(IconlyBold.heart, color: Color(0xFFFF3B30)),
                        ),
                        title: Obx(() => Text(AppStrings.Favorite, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- SELLER REPORT ----------------
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        contentPadding: const EdgeInsets.only(bottom: 15),
                        horizontalTitleGap: 10,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFD0F1FF)),
                          child: const Icon(IconlyBold.document, color: Color(0xFF06AEF3)),
                        ),
                        title: Obx(() => Text(AppStrings.SellerReport, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                      ),

                      /// ---------------- SETTING (OBX) ----------------
                      Obx(() {
                        final setting = appController.settings.value;
                        final referral = appController.referral.value;

                        if (setting == null || referral?.isActive != true) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final bool isLoginRequired =
                                prefs.getBool('setting_login_required') ?? true;
                            final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                            if (isLoginRequired && !isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingScreen()));
                            }
                          },
                          visualDensity: const VisualDensity(vertical: -3),
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.only(bottom: 15),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFFFFDDED)),
                            child: const Icon(IconlyBold.setting, color: Color(0xFFFF298C)),
                          ),
                          title: Obx(() => Text(AppStrings.Setting, style: AppTextStyle.description(color: text))),
                          trailing: Icon(FeatherIcons.chevronRight, color: text),
                        );
                      }),

                      /// ---------------- INVITE FRIENDS (OBX) ----------------
                      Obx(() {
                        final referral = appController.referral.value;

                        if (referral == null || referral.isActive != true) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final bool isLoginRequired =
                                prefs.getBool('invite_login_required') ?? true;
                            final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                            if (isLoginRequired && !isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Invitescreen(
                                    referralCode: controller
                                        .profileDetailsResponeModel
                                        .value
                                        ?.result
                                        ?.hidden
                                        ?.referralCode ??
                                        "",
                                  ),
                                ),
                              );
                            }
                          },
                          visualDensity: const VisualDensity(vertical: -3),
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.only(bottom: 15),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFFE2EED8)),
                            child: Icon(IconlyBold.addUser, color: AppColors.appColor),
                          ),
                          title: Obx(() => Text(AppStrings.inviteFriends, style: AppTextStyle.description(color: text))),
                          trailing: Icon(FeatherIcons.chevronRight, color: text),
                        );
                      }),

                      /// ---------------- HELP SUPPORT (OBX) ----------------
                      Obx(() {
                        final support = appController.support.value;

                        if (support == null || support.isActive != true) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final bool isLoginRequired = support.loginRequired ?? true;
                            final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                            if (isLoginRequired && !isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HelpSupport()));
                            }
                          },
                          visualDensity: const VisualDensity(vertical: -3),
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.only(bottom: 15),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFFE3EDFF)),
                            child: const Icon(IconlyBold.danger, color: Color(0xFF144BD6)),
                          ),
                          title: Obx(() => Text(AppStrings.helpSupport, style: AppTextStyle.description(color: text))),
                          trailing: Icon(FeatherIcons.chevronRight, color: text),
                        );
                      }),

                      /// ---------------- LOGOUT ----------------
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(bottom: 15),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFFFEFE0)),
                          child: const Icon(IconlyBold.logout, color: Color(0xFFFF7A00)),
                        ),
                        title: Obx(() => Text(AppStrings.logOut, style: AppTextStyle.description(color: text))),
                        trailing: Icon(FeatherIcons.chevronRight, color: text),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Obx(() => Text("Confirm Logout",
                                    style: AppTextStyle.title())),
                                content: Obx(() => Text("Are you sure you want to log out?",
                                    style: AppTextStyle.description())),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Obx(() => Text("Cancel",
                                        style: AppTextStyle.description(
                                            color: AppColors.appBodyTextColor))),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.appColor,
                                    ),
                                    onPressed: () async {
                                      final prefs =
                                      await SharedPreferences.getInstance();
                                      await prefs.setBool('isLoggedIn', false);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => LoginScreen()),
                                      );
                                    },
                                    child: Obx(() => Text(
                                      "Yes, Logout",
                                      style: AppTextStyle.description(
                                          color: AppColors.appTextColor),
                                    )),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.darkWhite,
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 50,
              width: 50,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColors.appWhite),
            ),
          ),
          SizedBox(width: 12),
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
                SizedBox(height: 8),
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
