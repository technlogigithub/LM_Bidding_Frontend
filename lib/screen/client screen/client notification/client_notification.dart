// import 'package:badges/badges.dart' as t;
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:freelancer/screen/app_config/api_config.dart';
// import 'package:nb_utils/nb_utils.dart';

// import '../../widgets/constant.dart';

// class ClientNotification extends StatefulWidget {
//   const ClientNotification({super.key});

//   @override
//   State<ClientNotification> createState() => _ClientNotificationState();
// }

// class _ClientNotificationState extends State<ClientNotification> {
//     List<dynamic> notifications = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifiaction();
//   }
//  Future<void> fetchNotifiaction() async {
//     await _fetchData(
//       endpoint: "notification",
//       onSuccess: (res) => notifications = res["data"] ?? [],
//     );
//   }
//     Future<void> _fetchData({
//     required String endpoint,
//     required Function(dynamic response) onSuccess,
//     String? token,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     try {
//       final headers = token != null
//           ? {
//               'Authorization': 'Bearer $token',
//               'Accept': 'application/json',
//             }
//           : null;

//       final res = await ApiService.getRequest(endpoint, headers: headers);
//       setState(() {
//         onSuccess(res);
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       toast("Error: $e");
//     }
//   }

 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kDarkWhite,
//       appBar: AppBar(
//         backgroundColor: kDarkWhite,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: kNeutralColor),
//         title: Text(
//           'Notifications',
//           style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 15.0),
//         child: Container(
//           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//           width: context.width(),
//           decoration: const BoxDecoration(
//             color: kWhite,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//           ),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 15.0),
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Container(
//                     padding: const EdgeInsets.all(10.0),
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: kDarkWhite),
//                     child: const Icon(FeatherIcons.bell),
//                   ),
//                   title: Text(
//                     'Start left feedback on their order.Rate your experience to view their',
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: kTextStyle.copyWith(color: kNeutralColor),
//                   ),
//                   subtitle: Text(
//                     '2 min ago “New Message”',
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: kTextStyle.copyWith(color: kLightNeutralColor),
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 10,
//                   shrinkWrap: true,
//                   itemBuilder: (_, i) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           visualDensity: const VisualDensity(vertical: -4),
//                           contentPadding: EdgeInsets.zero,
//                           leading: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               Container(
//                                 height: 45,
//                                 width: 45,
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: kDarkWhite,
//                                   image: DecorationImage(image: AssetImage('images/profilepic.png'), fit: BoxFit.cover),
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 5.0),
//                                 child: t.Badge(
//                                   badgeStyle: t.BadgeStyle(
//                                     elevation: 0,
//                                     shape: t.BadgeShape.circle,
//                                     badgeColor: kPrimaryColor,
//                                     borderSide: BorderSide(color: kWhite, width: 1.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           title: Text(
//                             'Leslie Alexander',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           subtitle: Text(
//                             '2 min ago “New Message”',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                         ListTile(
//                           visualDensity: const VisualDensity(vertical: -4),
//                           contentPadding: EdgeInsets.zero,
//                           leading: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               Container(
//                                 height: 45,
//                                 width: 45,
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: kDarkWhite,
//                                   image: DecorationImage(image: AssetImage('images/profilepic.png'), fit: BoxFit.cover),
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 5.0),
//                                 child: t.Badge(
//                                   badgeStyle: t.BadgeStyle(
//                                     elevation: 0,
//                                     shape: t.BadgeShape.circle,
//                                     badgeColor: kPrimaryColor,
//                                     borderSide: BorderSide(color: kWhite, width: 1.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           title: Text(
//                             'Leslie Alexander',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           subtitle: Text(
//                             '7 min ago “New Message”',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                         ListTile(
//                           visualDensity: const VisualDensity(vertical: -4),
//                           contentPadding: EdgeInsets.zero,
//                           leading: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               Container(
//                                 height: 45,
//                                 width: 45,
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: kDarkWhite,
//                                   image: DecorationImage(image: AssetImage('images/profilepic.png'), fit: BoxFit.cover),
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 5.0),
//                                 child: t.Badge(
//                                   badgeStyle: t.BadgeStyle(
//                                     elevation: 0,
//                                     shape: t.BadgeShape.circle,
//                                     badgeColor: kPrimaryColor,
//                                     borderSide: BorderSide(color: kWhite, width: 1.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           title: Text(
//                             'Leslie Alexander',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           subtitle: Text(
//                             '1 day ago “New Message”',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:badges/badges.dart' as t;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/constant.dart';
import 'package:freelancer/screen/model/notification.dart' as custom; // Use alias for custom Notification model

class ClientNotification extends StatefulWidget {
  const ClientNotification({super.key});

  @override
  State<ClientNotification> createState() => _ClientNotificationState();
}

class _ClientNotificationState extends State<ClientNotification> {
  List<custom.NotificationResult> notifications = []; // Use custom.Result to reference the model
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifiaction();
  }

  Future<void> fetchNotifiaction() async {
    await _fetchData(
      endpoint: "notification",
      onSuccess: (res) {
        final notificationModel = custom.Notification.fromJson(res); 
        notifications = notificationModel.result ?? [];
      },
    );
  }

  Future<void> _fetchData({
    required String endpoint,
    required Function(dynamic response) onSuccess,

  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final headers = token != null
          ? {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            }
          : null;

      final res = await ApiService.getRequest(endpoint, headers: headers);
      setState(() {
        onSuccess(res);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  }

  // Shimmer widget for notification list items
  Widget _buildNotificationShimmer() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Placeholder count
      shrinkWrap: true,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            leading: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: t.Badge(
                    badgeStyle: t.BadgeStyle(
                      elevation: 0,
                      shape: t.BadgeShape.circle,
                      badgeColor: kPrimaryColor,
                      borderSide: BorderSide(color: kWhite, width: 1.0),
                    ),
                  ),
                ),
              ],
            ),
            title: Container(
              width: 150,
              height: 16,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 14,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'Notifications',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          width: context.width(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                isLoading
                    ? _buildNotificationShimmer()
                    : notifications.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No notifications available',
                                style: kTextStyle.copyWith(
                                  color: kLightNeutralColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notifications.length,
                            shrinkWrap: true,
                            itemBuilder: (_, i) {
                              final notification = notifications[i];
                              return ListTile(
                                visualDensity: const VisualDensity(vertical: -4),
                                contentPadding: EdgeInsets.zero,
                                leading: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kDarkWhite,
                                        image: notification.image != null
                                            ? DecorationImage(
                                                image: NetworkImage(notification.image!),
                                                fit: BoxFit.cover,
                                                onError: (exception, stackTrace) =>
                                                    const AssetImage('images/profilepic.png'),
                                              )
                                            : const DecorationImage(
                                                image: AssetImage('images/profilepic.png'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: t.Badge(
                                        badgeStyle: t.BadgeStyle(
                                          elevation: 0,
                                          shape: t.BadgeShape.circle,
                                          badgeColor: kPrimaryColor,
                                          borderSide: BorderSide(color: kWhite, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  notification.title ?? 'Notification',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: kTextStyle.copyWith(color: kNeutralColor),
                                ),
                                subtitle: Text(
                                  notification.description ?? 'No description available',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                                onTap: () {
                                  if (notification.redirectUrl != null) {
                                    toast("Opening: ${notification.redirectUrl}");
                                    // Implement URL launching logic here (e.g., using url_launcher)
                                  }
                                },
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}