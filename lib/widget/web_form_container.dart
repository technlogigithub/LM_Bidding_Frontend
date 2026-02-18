import 'package:flutter/material.dart';
import '../core/app_color.dart';
import '../widget/custom_html_viewer.dart';

class WebFormContainer extends StatelessWidget {
  final Widget child;
  final String htmlContent;
  final Widget? footer;
  final double widthFactor;
  final double heightFactor;

  const WebFormContainer({
    super.key,
    required this.child,
    required this.htmlContent,
    this.footer,
    this.widthFactor = 0.9,
    this.heightFactor = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * widthFactor,
        height: screenHeight * heightFactor,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          boxShadow: [
            BoxShadow(
              color: AppColors.appMutedColor,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 60% Left side - Form
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: child,
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 20),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
            // Divider
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.appMutedColor.withOpacity(0.5),
            ),
            // 40% Right side - HTML/Preview
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.appMutedColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preview & Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomHtmlViewer(htmlContent: htmlContent),
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
