import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
    if (kIsWeb) {
      return _buildWebLayout(context);
    }
    
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
                                copyToClipboard(referralCode, referral != null ? ReferralMenuItem.fromJson(referral!.toJson()) : null);
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
  // ---------------------------------------------------------------------------
  // ⭐ WEB UI
  // ---------------------------------------------------------------------------
  Widget _buildWebLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    ReferralMenuItem? referral;
    if (menuItem != null) {
      referral = ReferralMenuItem.fromJson(menuItem!.toJson());
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.appWhite),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Column(
          children: [
            // Hero Section: Premium Banner
            Container(
              width: double.infinity,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
              ),
              child: Stack(
                children: [
                  // Banner Background Image
                  if (referral?.pageImage != null && (referral?.pageImage?.isNotEmpty ?? false))
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.2,
                        child: CachedNetworkImage(
                          imageUrl: referral!.pageImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  
                  // Banner Text
                  Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 800),
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            referral?.title ?? "",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.title(
                              color: AppColors.appWhite,
                              fontWeight: FontWeight.bold,
                            ).copyWith(fontSize: screenWidth < 800 ? 32 : 44, letterSpacing: -1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            referral?.description ?? "",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.description(
                              color: AppColors.appWhite.withOpacity(0.9),
                            ).copyWith(fontSize: 18, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Area: Focused Sharing Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Referral Code Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.appMutedColor.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.appMutedColor.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                referral?.design?.code?.detail ?? "",
                                style: AppTextStyle.description(
                                  color: AppColors.appMutedTextColor,
                                  fontWeight: FontWeight.bold,
                                ).copyWith(fontSize: 14, letterSpacing: 1),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.appColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.appColor.withOpacity(0.1)),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        referralCode,
                                        style: AppTextStyle.title(
                                          color: AppColors.appColor,
                                          fontWeight: FontWeight.bold,
                                        ).copyWith(fontSize: 24, letterSpacing: 2),
                                      ),
                                      const SizedBox(width: 20),
                                      VerticalDivider(color: AppColors.appColor.withOpacity(0.2), width: 1, indent: 5, endIndent: 5),
                                      const SizedBox(width: 20),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () => copyToClipboard(referralCode, referral),
                                          child: Icon(
                                            Icons.copy_rounded,
                                            color: AppColors.appColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Social Sharing Section
                        if (referral?.design?.socialMedia != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Divider(color: AppColors.appMutedColor.withOpacity(0.5))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(color: AppColors.appMutedColor, shape: BoxShape.circle),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: AppColors.appMutedColor.withOpacity(0.5))),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children: buildWebSocialIcons(referral),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildWebSocialIcons(referral) {
    final social = referral.design.socialMedia;
    List<Widget> icons = [];

    void addIcon(model) {
      if (model != null) {
        icons.add(_webSocialIcon(model.icon, () {
          openSocialUrl(model.url!);
        }));
      }
    }

    if (social != null) {
      addIcon(social.facebook);
      addIcon(social.instagram);
      addIcon(social.youtube);
      addIcon(social.twitter);
      addIcon(social.linkedin);
    }

    return icons;
  }

  Widget _webSocialIcon(String? iconUrl, VoidCallback onTap) {
    bool hasUrl = iconUrl != null && iconUrl.isNotEmpty;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 54,
          width: 54,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.appMutedColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.appMutedColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CachedNetworkImage(
            imageUrl: hasUrl ? iconUrl! : '',
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => Icon(
              Icons.link_rounded,
              color: AppColors.appColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openSocialUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> copyToClipboard(String text, ReferralMenuItem? referral) async {
    await Clipboard.setData(ClipboardData(text: text));
    Utils.showSnackbar(
      isSuccess: true,
      title: referral?.label ?? "Copied!",
      message: referral?.design?.code?.message ?? "Referral code copied to clipboard.",
    );
  }
}
