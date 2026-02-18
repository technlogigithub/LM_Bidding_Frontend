import 'package:flutter/material.dart';
import '../core/app_color.dart';
import '../widget/app_image_handle.dart';

class WebCardContainerLayout extends StatelessWidget {
  final Widget child;
  final String logoUrl;
  final String? imagePath;
  final Widget? footer;

  const WebCardContainerLayout({
    super.key,
    required this.child,
    required this.logoUrl,
    this.imagePath,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Center(
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.85,
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.appMutedColor,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 50% Left side - Image
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/onboard2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // 50% Right side - Form
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Fixed Top Logo
                        UniversalImage(
                          url: logoUrl,
                          height: 80,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 25),
                        // Scrollable Content
                        Expanded(
                          child: SingleChildScrollView(
                            child: child,
                          ),
                        ),
                        // Optional Fixed Footer
                        if (footer != null) ...[
                          const SizedBox(height: 15),
                          footer!,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
