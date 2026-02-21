import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_config.dart';
import 'package:libdding/service/socket_service_interface.dart';
import 'package:libdding/service/socket_service.dart';
import 'package:libdding/view/splash_screen/splash_screen.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'Notifications Services/notifications_services.dart';
import 'package:libdding/controller/network_controller.dart';
import 'package:libdding/view/widgets/no_internet_widget.dart';
import 'package:libdding/core/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 📦 App version
  await AppInfo.getCurrentVersion();

  // 🎨 App settings controller
  final appController = Get.put(AppSettingsController());
  await appController.fetchAllData();
  
  final prefsMain = await SharedPreferences.getInstance();
  final isLanguageSelectedMain = prefsMain.getBool('is_language_selected') ?? false;
  if (isLanguageSelectedMain) {
    await appController.fetchAppContent();
  }

  if (!kIsWeb) {
    // 🔥 Firebase (Mobile Only)
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 🔔 Notifications
      NotificationServices notificationServices = NotificationServices();
      await notificationServices.requestNotificationPermission();
      notificationServices.initLocalNotifications();
      notificationServices.firebaseInit();
      String? token = await notificationServices.getDeviceToken();
      debugPrint('📲 FCM Token: $token');
    } catch (e) {
      debugPrint("❌ Firebase Init Failed: $e");
    }
  } else {
    debugPrint("⚠️ Firebase & Notifications skipped on Web (Configuration missing)");
  }

  // 🔌 SOCKET INIT (LOCAL + GLOBAL)
  final socketService = Get.put<SocketService>(
    SocketServiceImpl(),
    permanent: true,
  );

  final prefs = await SharedPreferences.getInstance();
  final ukey = prefs.getString('ukey');
  
  if (ukey != null) {
    debugPrint("🔌 Connected with ukey: $ukey");
    socketService.connect(ukey);
  } else {
    debugPrint("⚠️ No ukey found, skipping WebSocket connection on start");
  }

  socketService.onMessageReceived((data) {
    debugPrint("📩 Socket Data: $data");
  });

  // 🌐 Network Controller
  Get.put(NetworkController(), permanent: true);


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppSettingsController appController;

  @override
  void initState() {
    super.initState();

    appController = Get.find<AppSettingsController>();

    // Detect system theme on start
    final brightness = PlatformDispatcher.instance.platformBrightness;
    appController.updateTheme(brightness == Brightness.dark);

    // Detect theme change at runtime
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      final newBrightness = PlatformDispatcher.instance.platformBrightness;
      appController.updateTheme(newBrightness == Brightness.dark);
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => _buildApp(),
    );
  }

  Widget _buildApp() {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appController.appName.value.isNotEmpty
            ? appController.appName.value
            : "",
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: appController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        builder: (context, materialChild) {
          return Stack(
            children: [
              materialChild!,
              Obx(() {
                final networkController = Get.find<NetworkController>();
                if (!networkController.isConnected.value) {
                  return const NoInternetWidget();
                }
                return const SizedBox.shrink();
              }),
            ],
          );
        },
      );
    });
  }
}
