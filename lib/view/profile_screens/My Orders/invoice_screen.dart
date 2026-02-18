import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/custom_html_viewer.dart';

class InvoiceScreen extends StatelessWidget {
  final String htmlContent;

  const InvoiceScreen({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appbarColor),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Invoice",
          style: AppTextStyle.title(
              color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: CustomHtmlViewer(htmlContent: htmlContent),
        ),
      ),
    );
  }
}
