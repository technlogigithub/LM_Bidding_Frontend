import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_config.dart';
import 'package:libdding/view/splash_screen/Splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load version
  await AppInfo.getCurrentVersion();

  // Initialize App Settings Controller
  final appController = Get.put(AppSettingsController());

  // Fetch all server data (font sizes, colors, theme)
  await appController.fetchAllData();

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
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appController.appName.value.isNotEmpty
            ? appController.appName.value
            : "LM Bidding",
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: appController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: const SplashScreen(),
      );
    });
  }
}
