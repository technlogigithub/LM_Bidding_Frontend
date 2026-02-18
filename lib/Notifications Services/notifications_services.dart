import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:libdding/view/Home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle background notification action
  if (kDebugMode) {
    print('Background Notification Action: ${notificationResponse.actionId}');
    print('Payload: ${notificationResponse.payload}');
    print('Input: ${notificationResponse.input}');
  }
  // Implement background task here (e.g., API calls) without UI references
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }

  // NOTE: If you want to show custom buttons when app is killed,
  // the server MUST send a "Data Message" (without 'notification' block).
  // If the server sends a 'notification' block, the System Tray handles it
  // and we CANNOT override it easily to show buttons.

  // However, we can try to force show a local notification here if it is a Data message.
  // If it's a notification message, this handler might run but the system already showed a notification.
  // To avoid duplicate notifications, only show here if it is PURELY a data message or you want to override.

  // Given your requirement for Buttons, we will try to show our custom notification.
  // WARNING: This might cause double notifications if the payload also has a 'notification' key.

  // Initialize Local Notifications for background (required to show)
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
       // This handles tap when app opens from this background notification
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Re-use the show logic? We can't access instance methods easily.
  // We have to duplicate the "show" logic roughly or make it static/top-level.
  // For simplicity, let's just copy the critical part for buttons.

  // ... (Code to show notification similar to showNotification method) ...
  // Actually, to avoid code duplication and complexity, calling the service class might be tricky
  // because of contexts. But we can instantiate it.

  NotificationServices notificationServices = NotificationServices();
  // We can't use 'showNotification' directly comfortably if it depends on context or other things,
  // but yours looks safe.
  await notificationServices.showNotification(message);
}

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User Granted Permission');
      }
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional)
    {
      if (kDebugMode) {
        print('User Granted Provisional Permission');
      }
    }
    else
    {
      if (kDebugMode) {
        print('User Denied Permission');
      }
    }
  }

  void initLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {

        // Handle foreground/UI open notification action
        if (kDebugMode) {
          print('Foreground Notification Action: ${notificationResponse.actionId}');
        }
        print(" Notification response > $notificationResponse");
        handleNotificationAction(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    
    // Check if app was launched via notification action
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
        
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      if (notificationAppLaunchDetails?.notificationResponse != null) {
         handleNotificationAction(notificationAppLaunchDetails!.notificationResponse!);
      }
    }
  }

  // Central place to handle logic when user taps a button or the notification itself
  void handleNotificationAction(NotificationResponse response) {
    final String? actionId = response.actionId;
    final String? payload = response.payload;

    // Switch case for different Action IDs
    switch (actionId) {
      case 'id_like':
        print("User pressed LIKE");
        // Call API to like post
        break;
      case 'id_reply':
        print("User pressed REPLY with input: ${response.input}");
        // Send reply to API
        break;
      case 'id_cancel':
        print("User pressed CANCEL");
        Get.offAll(() => HomeScreen());
        break;
      default:
        print("User pressed notification itself or unknown action");
        // Navigate to screen
        break;
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {

      if (kDebugMode) {
        print('Message received. Title: ${message.notification?.title}, Body: ${message.notification?.body}');
      }
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('Message clicked!');
      }
      // Handle message click event
    });
  }

  Future<void> showNotification(RemoteMessage message) async {

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // ID
      'High Importance Notifications', // Name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    // Image Logic
    BigPictureStyleInformation? bigPictureStyleInformation;

    try {
      if (message.notification?.android?.imageUrl != null) {
        final String imageUrl = message.notification!.android!.imageUrl!;
        final http.Response response = await http.get(Uri.parse(imageUrl));

        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
          htmlFormatContent: true,
          htmlFormatContentTitle: true
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error downloading notification image: $e");
      }
    }

    // Define Actions
    final List<AndroidNotificationAction> actions = [
      const AndroidNotificationAction(
        'id_like',
        'Like',
        titleColor: Color.fromARGB(255, 0, 150, 255),
        showsUserInterface: false,
        cancelNotification: false
      ),
      const AndroidNotificationAction(
        'id_reply',
        'Reply',
        inputs: [AndroidNotificationActionInput(label: 'Type your reply...')],
      ),
      const AndroidNotificationAction(
        'id_cancel',
        'Cancel',
        showsUserInterface: true,
        cancelNotification: true
      ),
    ];

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      actions: actions,
      styleInformation: bigPictureStyleInformation, // Attach Image Style
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(100000), // Unique ID for each notification
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(), // Pass data as payload
    );
  }


  Future<String?> getDeviceToken() async {
    try {
      final token = await messaging.getToken();
      if (kDebugMode) {
        print('Device Token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
      return null;
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      if (kDebugMode) {
        print('Token refreshed: $event');
      }
    });
  }

}
