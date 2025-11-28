import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:libdding/core/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_images.dart';
import '../../core/app_textstyle.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<AppSettingsController>();
    final support = controller.support.value;

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
            iconTheme:  IconThemeData(color: AppColors.appTextColor),
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
              support?.label ?? 'Help & Support',
              style:  AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),

          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(

                color: AppColors.appColor.withValues(alpha: 0.15),
              ),
              clipBehavior: Clip.antiAlias,
              child: (support?.pageImage != null &&
                  support!.pageImage!.isNotEmpty)
                  ? CachedNetworkImage(
                imageUrl: support.pageImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.appWhite,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.help_outline,
                  size: screenHeight * 0.1,
                  color: AppColors.appIconColor,
                ),
              )
                  : Icon(
                Icons.help_outline,
                size: screenHeight * 0.1,
                color: AppColors.appIconColor,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  // ✔ Big Circle Avatar with page_image


                  SizedBox(height: screenHeight * 0.02),

                  // Title from support.title
                  Text(
                    support?.title ?? "",
                    style: AppTextStyle.title(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Description from support.description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      support?.description ?? "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.description(
                        color: AppColors.appDescriptionColor,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // ✔ First Row (Call, WhatsApp, Email)
                  if (support?.design != null)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
              if (support!.design!.call != null)
                helpBoxWithIcon(
                  screenHeight,
                  screenWidth,
                  support.design!.call!.icon,
                      () {
                    makePhoneCall(support.design!.call!.detail!);
                  },
                ),

              if (support.design!.whatsapp != null)
                helpBoxWithIcon(
                  screenHeight,
                  screenWidth,
                  support.design!.whatsapp!.icon,
                      () {
                    openWhatsApp(support.design!.whatsapp!.detail!);
                  },
                ),

              if (support.design!.email != null)
                helpBoxWithIcon(
                  screenHeight,
                  screenWidth,
                  support.design!.email!.icon,
                      () {
                    sendEmail(support.design!.email!.detail!);
                  },
                ),
                    ],
                  ),

                    SizedBox(height: screenHeight * 0.03),

                  // ✔ OR Divider
                  Row(
                    children:  [
                      Expanded(child: Divider(thickness: 1,color: AppColors.appDescriptionColor,)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("OR",style:AppTextStyle.description(color: AppColors.appDescriptionColor),),
                      ),
                      Expanded(child: Divider(thickness: 1,color:AppColors.appDescriptionColor)),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // ✔ Second Row (Social Media)
                  if (support?.design?.socialMedia != null)
                    Wrap(
                      spacing: 9,
                      alignment: WrapAlignment.center,
                      children: [
                        if (support!.design!.socialMedia!.facebook != null)
                          helpBoxWithImage(
                            screenHeight,
                            screenWidth,
                            support.design!.socialMedia!.facebook!.icon,
                                () {
                              openSocialUrl(support.design!.socialMedia!.facebook!.url!);
                            },
                          ),

                        if (support.design!.socialMedia!.instagram != null)
                          helpBoxWithImage(
                            screenHeight,
                            screenWidth,
                            support.design!.socialMedia!.instagram!.icon,
                                () {
                              openSocialUrl(support.design!.socialMedia!.instagram!.url!);
                            },
                          ),

                        if (support.design!.socialMedia!.youtube != null)
                          helpBoxWithImage(
                            screenHeight,
                            screenWidth,
                            support.design!.socialMedia!.youtube!.icon,
                                () {
                              openSocialUrl(support.design!.socialMedia!.youtube!.url!);
                            },
                          ),

                        if (support.design!.socialMedia!.twitter != null)
                          helpBoxWithImage(
                            screenHeight,
                            screenWidth,
                            support.design!.socialMedia!.twitter!.icon,
                                () {
                              openSocialUrl(support.design!.socialMedia!.twitter!.url!);
                            },
                          ),

                        if (support.design!.socialMedia!.linkedin != null)
                          helpBoxWithImage(
                            screenHeight,
                            screenWidth,
                            support.design!.socialMedia!.linkedin!.icon,
                                () {
                              openSocialUrl(support.design!.socialMedia!.linkedin!.url!);
                            },
                          ),
                      ],
                    ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }


  Widget helpBoxWithIcon(
      double screenHeight, double screenWidth, String? iconUrl, VoidCallback onTap) {
    bool hasUrl = iconUrl != null &&
        iconUrl.isNotEmpty &&
        (iconUrl.startsWith("http://") || iconUrl.startsWith("https://"));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.08,
        width: screenWidth * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        gradient: AppColors.appPagecolor,
          border: Border.all(
            color: AppColors.appDescriptionColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: hasUrl ? iconUrl! : AppImage.placeholder,
            fit: BoxFit.contain,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.simmerColor,
              highlightColor: AppColors.appWhite,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.appWhite,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              AppImage.placeholder,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

// ⭐ Reusable Box Widget with Image (for social media)
  Widget helpBoxWithImage(
      double screenHeight, double screenWidth, String? iconUrl, VoidCallback onTap) {
    bool hasUrl = iconUrl != null && iconUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: screenHeight * 0.08,
          width: screenWidth * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),gradient: AppColors.appPagecolor,
            border: Border.all(
              color: AppColors.appDescriptionColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: hasUrl ? iconUrl! : AppImage.placeholder,
              fit: BoxFit.contain,
              placeholder: (context, url) => Image.asset(
                AppImage.placeholder,
                fit: BoxFit.contain,
              ),
              errorWidget: (context, url, error) => Image.asset(
                AppImage.placeholder,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Cannot launch phone dialer");
    }
  }
  Future<void> openWhatsApp(String phone) async {
    // Remove + if exists
    String cleaned = phone.replaceAll('+', '');

    final Uri uri = Uri.parse("https://wa.me/$cleaned");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Cannot open WhatsApp");
    }
  }
  Future<void> sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Cannot open Email app");
    }
  }

  Future<void> openSocialUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Try to launch in native app
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback → open in browser
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint("Error opening social URL: $e");
    }
  }







}
