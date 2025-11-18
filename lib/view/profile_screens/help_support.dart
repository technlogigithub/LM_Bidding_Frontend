import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:libdding/core/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_images.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<AppSettingsController>();
    final support = controller.support.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
        backgroundColor: const Color(0xFFF5F5F5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          support?.label ?? 'Help & Support',
          style: const TextStyle(
            color: Color(0xFF1D1D1D),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),

              // ✔ Big Circle Avatar with page_image
              CircleAvatar(
                radius: screenHeight * 0.1,
                backgroundColor: AppColors.appColor.withOpacity(0.15),
                backgroundImage: (support?.pageImage != null && support!.pageImage!.isNotEmpty)
                    ? NetworkImage(support.pageImage!)
                    : null,
                child: (support?.pageImage == null || (support?.pageImage?.isEmpty ?? true))
                    ? Icon(
                        Icons.help_outline,
                        size: screenHeight * 0.1,
                        color: AppColors.appColor,
                      )
                    : null,
              ),

              SizedBox(height: screenHeight * 0.02),

              // Title from support.title
              Text(
                support?.title ?? "Contact Us",
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  color: AppColors.appTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              // Description from support.description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  support?.description ?? "If you need any help or facing any issue, feel free to contact us. "
                      "We are always here to help you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: AppColors.subTitleColor,
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
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
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
      ),
    );
  }

  // ⭐ Reusable Box Widget with Icon (for call, whatsapp, email)
// ⭐ Reusable Box Widget with Icon (for call, whatsapp, email)
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
          color: AppColors.appWhite,
          border: Border.all(
            color: AppColors.subTitleColor.withOpacity(0.6),
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
    );
  }

// ⭐ Reusable Box Widget with Image (for social media)
  Widget helpBoxWithImage(
      double screenHeight, double screenWidth, String? iconUrl, VoidCallback onTap) {
    bool hasUrl = iconUrl != null && iconUrl.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.08,
        width: screenWidth * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.appWhite,
          border: Border.all(
            color: AppColors.subTitleColor.withOpacity(0.6),
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
