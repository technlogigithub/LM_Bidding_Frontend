import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_config.dart';
import 'package:libdding/service/socket_service.dart';
import 'package:libdding/view/splash_screen/Splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app version first
  await AppInfo.getCurrentVersion();

  // Initialize the AppSettingsController
  final appController = Get.put(AppSettingsController());

  // Fetch API data before running the app
  await appController.fetchAllData();

  final socketService = SocketService();
  await socketService.connect('user_456'); // Set the user id

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
    try {
      appController = Get.find<AppSettingsController>();

      // Detect system brightness initially
      final Brightness systemBrightness = PlatformDispatcher.instance.platformBrightness;
      appController.updateTheme(systemBrightness == Brightness.dark);

      // Listen for runtime changes in system theme
      PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
        final Brightness newBrightness = PlatformDispatcher.instance.platformBrightness;
        appController.updateTheme(newBrightness == Brightness.dark);
      };
    } catch (e) {
      // Fallback if controller not found
      debugPrint('Error initializing theme: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<AppSettingsController>();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: controller.appName.value.isNotEmpty
            ? controller.appName.value
            : 'Lm Bidding',
        theme: ThemeData.light(),  // Fallback light theme
        darkTheme: ThemeData.dark(), // Fallback dark theme
        themeMode:
        controller.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      );
    });
  }
}
