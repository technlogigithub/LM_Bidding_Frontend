import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/notifications/notifications_controller.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          gradient: AppColors.appPagecolor,
        ),
        child: Icon(
          Icons.notifications,
          color: AppColors.appIconColor,
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
            gradient: AppColors.appPagecolor,
          ),
          child: ClipOval(
            child: Image.network(
              iconUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: AppColors.appMutedColor,
                  highlightColor: AppColors.appMutedTextColor,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appMutedColor,
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
    // Initialize controller
    final NotificationsController controller = Get.put(
      NotificationsController(),
    );
    final AppSettingsController appController =
        Get.find<AppSettingsController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final homePage = appController.homePage.value; // <-- HomePage? model
    final headerConfig = homePage?.design?.headerMenu; // <-- HeaderMenuSection?
    final appbartitle = headerConfig?.headerMenu?[0].title;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        backgroundColor: Colors.transparent, // MUST be transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor, // <-- Your gradient here
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          appbartitle ?? '',
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
            const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(gradient: AppColors.appPagecolor),
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Refresh all data - shimmer will show automatically via isLoading
                    await controller.fetchNotifications();
                  },
                  color: AppColors.appButtonColor,
                  child: Obx(() {
                    // Show shimmer during loading (initial load or refresh)
                    if (controller.isLoading.value) {
                      return _buildShimmerLoading();
                    }

                    // Show empty state when no notifications
                    if (controller.notifications.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
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
                                  style: AppTextStyle.description(
                                    color: AppColors.appDescriptionColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Show notifications list
                    return ListView.builder(
                      padding: const EdgeInsets.all(15.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
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
                                gradient: AppColors.appPagecolor,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.appMutedColor,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification['title'] ??
                                              'Notification Title',
                                          style: AppTextStyle.description(
                                            color: AppColors.appTitleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification['description'] ??
                                              'Notification description will be shown...',
                                          style: AppTextStyle.body(
                                            color: AppColors.appMutedTextColor,
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
                    );
                  }),
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
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
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
