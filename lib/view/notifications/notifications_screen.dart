import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/network.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../controller/app_main/App_main_controller.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  final AppSettingsController appController = Get.find<AppSettingsController>();

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      setState(() => isLoading = true);
      final token = await appController.getAuthToken();
      
      if (token == null || token.isEmpty) {
        setState(() {
          isLoading = false;
          notifications = [];
        });
        toast("Please login to view notifications");
        return;
      }

      final res = await ApiServices().makeRequestRaw(
        endPoint: "notification",
        method: "GET",
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      setState(() {
        if (res['success'] == true && res['result'] != null) {
          notifications = res['result'] is List ? res['result'] : [];
        } else {
          notifications = [];
        }
        isLoading = false;
      });
      
      // Debug print
      print("Notifications fetched: ${notifications.length}");
      if (notifications.isNotEmpty) {
        print("First notification: ${notifications[0]}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        notifications = [];
      });
      toast("Error loading notifications: $e");
    }
  }

  Widget _buildNotificationIcon(dynamic notification) {
    // Try to get icon/image from notification
    String? iconUrl = notification['icon'] ?? notification['image'];
    
    // If no icon, create a default gradient circle
    if (iconUrl == null || iconUrl.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.appColor,
              AppColors.appColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          Icons.notifications,
          color: AppColors.appWhite,
          size: 24,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                AppColors.appColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              iconUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appWhite,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.notifications,
                  color: AppColors.appWhite,
                  size: 24,
                );
              },
            ),
          ),
        ),
        // Green dot indicator (always show for now since API doesn't provide is_read)
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.appWhite, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          'Notifications',
          style: TextStyle(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor,
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(30.0),
                  //   topRight: Radius.circular(30.0),
                  // ),
                ),
                child: isLoading
                    ? _buildShimmerLoading()
                    : notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 64,
                                  color: AppColors.appDescriptionColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No notifications yet',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.appDescriptionColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: fetchNotifications,
                            color: AppColors.appColor,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(15.0),
                              physics: const BouncingScrollPhysics(),
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      NotificationDetailScreen(
                                        notification: notification,
                                      ).launch(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.appWhite,
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: AppColors.kBorderColorTextField,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.darkWhite,
                                            blurRadius: 5.0,
                                            spreadRadius: 1.0,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildNotificationIcon(notification),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notification['title'] ?? 'Notification Title',
                                                  style: AppTextStyle.kTextStyle.copyWith(
                                                    color: AppColors.appTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  notification['description'] ?? 
                                                  'Notification description will be shown...',
                                                  style: AppTextStyle.kTextStyle.copyWith(
                                                    color: AppColors.appMutedTextColor,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppColors.kBorderColorTextField,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appWhite,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 200,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 14,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

