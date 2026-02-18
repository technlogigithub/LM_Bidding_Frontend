import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/controller/network_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_color.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppSettingsController>();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appController.isDarkMode.value 
                  ? const Color(0xFF1A1A2E) 
                  : const Color(0xFFF8F9FA),
              appController.isDarkMode.value 
                  ? const Color(0xFF16213E) 
                  : const Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Animation Effect using TweenAnimationBuilder
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 10),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              onEnd: () {}, // Handled by repeating logic if needed, or just one time
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (appController.isDarkMode.value 
                      ? Colors.white 
                      : Colors.black).withOpacity(0.05),
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 100,
                  color: appController.isDarkMode.value 
                      ? Colors.white70 
                      : Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "No Connection",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: appController.isDarkMode.value 
                    ? Colors.white 
                    : Colors.black,
                fontFamily: appController.fontFamily.value,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your internet connection is currently unavailable. Please check your settings.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: appController.isDarkMode.value 
                      ? Colors.white70 
                      : Colors.black45,
                  fontFamily: appController.fontFamily.value,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Premium Retry Button
            GestureDetector(
              onTap: () {
                // Manually trigger a check
                Get.find<NetworkController>().checkInitialConnection();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.appButtonColor
                  // gradient: const LinearGradient(
                  //   colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  // ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: const Color(0xFF2575FC).withOpacity(0.4),
                  //     blurRadius: 20,
                  //     offset: const Offset(0, 10),
                  //   ),
                  // ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Try Again",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
