import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_images.dart';
import '../../core/app_textstyle.dart';
import '../../core/utils.dart';
import '../../models/App_moduls/AppResponseModel.dart';

class InviteScreen extends StatelessWidget {
  final String referralCode;  // <-- Your referral code from previous screen
  final AppMenuItem? menuItem;

  InviteScreen({super.key, required this.referralCode, this.menuItem});

  @override
  Widget build(BuildContext context) {
    print(" refer code : $referralCode");
    final profilecontroller = Get.put(ProfileController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<AppSettingsController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme:  IconThemeData(color: AppColors.appTextColor,),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(50.0),
                //   bottomRight: Radius.circular(50.0),
                // ),
              ),
            ),
            toolbarHeight: 80,
            centerTitle: true,
            title: Text(
              menuItem?.label ?? '',
              style:  AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),

          body: actualUI(
            screenHeight,
            screenWidth,
            menuItem != null ? ReferralMenuItem.fromJson(menuItem!.toJson()) : null,
            referralCode,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ SHIMMER UI
  // ---------------------------------------------------------------------------
  Widget shimmerLoadingUI(double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.03),
          shimmerBox(screenHeight * 0.2, screenHeight * 0.2),
          SizedBox(height: 20),
          shimmerBox(20, screenWidth * 0.5),
          SizedBox(height: 10),
          shimmerBox(15, screenWidth * 0.7),
        ],
      ),
    );
  }

  Widget shimmerBox(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor,
      highlightColor: AppColors.appMutedTextColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ FINAL UI
  // ---------------------------------------------------------------------------
  Widget actualUI(double screenHeight, double screenWidth, referral, String referralCode) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(height: screenHeight * 0.03),
          Container(
            decoration: BoxDecoration(

              color: AppColors.appColor.withOpacity(0.15),
            ),
            clipBehavior: Clip.antiAlias,
            child: (referral?.pageImage != null &&
                referral!.pageImage!.isNotEmpty)
                ? CachedNetworkImage(
              imageUrl: referral.pageImage!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.appMutedColor,
                highlightColor: AppColors.appMutedTextColor,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.appWhite,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.group_add_outlined,
                size: screenHeight * 0.1,
                color: AppColors.appColor,
              ),
            )
                : Icon(
              Icons.group_add_outlined,
              size: screenHeight * 0.1,
              color: AppColors.appColor,
            ),
          ),


          // Page Icon
          // CircleAvatar(
          //   radius: screenHeight * 0.1,
          //   backgroundColor: AppColors.appColor.withOpacity(0.15),
          //   backgroundImage: referral?.pageImage != null &&
          //       referral!.pageImage!.isNotEmpty
          //       ? NetworkImage(referral.pageImage!)
          //       : null,
          //   child: (referral?.pageImage == null ||
          //       (referral?.pageImage?.isEmpty ?? true))
          //       ? Icon(
          //     Icons.group_add_outlined,
          //     size: screenHeight * 0.1,
          //     color: AppColors.appColor,
          //   )
          //       : null,
          // ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(height: 20),

                Text(
                  referral?.title ?? "Invite & Earn",
                  style:  AppTextStyle.title(
                    fontWeight: FontWeight.bold,
                    color: AppColors.appTitleColor,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  referral?.description ??
                      "",
                  textAlign: TextAlign.center,
                  style:  AppTextStyle.description(

                    color: AppColors.appDescriptionColor,
                  ),
                ),

                SizedBox(height: 30),

                // -----------------------------------------------------------------
                // ⭐ REFERRAL CODE UI
                // -----------------------------------------------------------------
                if (referralCode.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        "Your Referral Code",
                        style:  AppTextStyle.title(
                          fontWeight: FontWeight.w600,
                          color: AppColors.appBodyTextColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.appPagecolor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.appDescriptionColor
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              referralCode,
                              style:  AppTextStyle.title(
                                fontWeight: FontWeight.bold,
                                color: AppColors.appDescriptionColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                copyToClipboard(referralCode);
                              },
                              child:  Icon(
                                Icons.copy,
                                size: 22,
                                color: AppColors.appIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 35),

                Row(
                  children:  [
                    Expanded(child: Divider(color: AppColors.appDescriptionColor,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("OR",style:AppTextStyle.title(),),
                    ),
                    Expanded(child: Divider(color: AppColors.appDescriptionColor,)),
                  ],
                ),

                SizedBox(height: 30),

                // -----------------------------------------------------------------
                // ⭐ SOCIAL ICONS
                // -----------------------------------------------------------------
                if (referral?.design?.socialMedia != null)
                  Wrap(
                    spacing: 9,
                    alignment: WrapAlignment.center,
                    children: buildSocialIcons(screenHeight, screenWidth, referral),
                  ),
              ],
            ),
          )


        ],
      ),
    );
  }

  List<Widget> buildSocialIcons(double sh, double sw, referral) {
    final social = referral.design.socialMedia;
    List<Widget> icons = [];

    void addIcon(model) {
      if (model != null) {
        icons.add(helpBoxWithImage(sh, sw, model.icon, () {
          openSocialUrl(model.url!);
        }));
      }
    }

    addIcon(social.facebook);
    addIcon(social.instagram);
    addIcon(social.youtube);
    addIcon(social.twitter);
    addIcon(social.linkedin);

    return icons;
  }

  // ---------------------------------------------------------------------------
  // ⭐ SOCIAL ICON BOX
  // ---------------------------------------------------------------------------
  Widget helpBoxWithImage(double sh, double sw, String? iconUrl, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: sh * 0.08,
          width: sw * 0.17,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.appDescriptionColor
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: iconUrl ?? AppImage.placeholder,
              fit: BoxFit.contain,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.appMutedColor,
                highlightColor: AppColors.appMutedTextColor,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.appWhite,
                ),
              ),
              errorWidget: (_, __, ___) =>
                  Image.asset(AppImage.placeholder, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ UTILITIES
  // ---------------------------------------------------------------------------
  Future<void> openSocialUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Utils.showSnackbar(
      isSuccess: true,
      title: "Copied!",
      message: "Referral code copied to clipboard.",
    );
  }
}
