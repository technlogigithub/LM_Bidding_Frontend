import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../widget/form_widgets/app_button.dart';

class NotificationDetailScreen extends StatelessWidget {
  final dynamic notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  Widget _buildNotificationIcon(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String? iconUrl = notification['icon'] ?? notification['image'];
    
    if (iconUrl == null || iconUrl.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.appColor,
              AppColors.appColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          Icons.notifications,
          color: AppColors.appWhite,
          size: 40,
        ),
      );
    }

    return Container(
      width: screenWidth ,
      height: screenWidth * 1,
      decoration: BoxDecoration(
        color: AppColors.appColor.withValues(alpha: 0.15),
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: iconUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.appMutedColor,
          highlightColor: AppColors.appMutedTextColor,
          child: Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            color: AppColors.appWhite,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.group_add_outlined,
          size: screenHeight * 0.1,
          color: AppColors.appColor,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final title = notification['title'] ?? 'Notification Title';
    final message = notification['description'] ?? 'No description available';
    final redirectUrl = notification['redirect_url'] ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        backgroundColor: Colors.transparent, // MUST be transparent
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(50.0),
        //     bottomRight: Radius.circular(50.0),
        //   ),
        // ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor, // <-- Your gradient here
            // borderRadius: const BorderRadius.only(
            //   bottomLeft: Radius.circular(50.0),
            //   bottomRight: Radius.circular(50.0),
            // ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title:  Text(
          'Notification Details ',
          style: AppTextStyle.title(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Column(
          children: [
            // const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor,
                  // color: AppColors.appWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  // physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 20),
                      _buildNotificationIcon(context),
                      const SizedBox(height: 24),
                      Text(
                        title,
                        style: AppTextStyle.title(
                          color: AppColors.appTitleColor,
                          fontWeight: FontWeight.bold,

                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: AppColors.appPagecolor,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.appMutedColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                              // blurRadius: 1,
                              // spreadRadius: 1,
                              // offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          message,
                          style: AppTextStyle.description(
                            color: AppColors.appDescriptionColor  ,

                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (redirectUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomButton(
                            onTap: () async {
                              if (redirectUrl.isNotEmpty) {
                                try {
                                  final uri = Uri.parse(redirectUrl);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    toast("Cannot open URL");
                                  }
                                } catch (e) {
                                  toast("Error opening URL: $e");
                                }
                              }
                            },
                            text: 'Redirect',
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

