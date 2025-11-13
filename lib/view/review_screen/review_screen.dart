import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import '../../controller/review/review_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../../widget/review_form_container.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppTextStyle.kNeutralColor),
          title: Text(
            "Write A Review",
            style: AppTextStyle.kTextStyle.copyWith(
              color: AppColors.appTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appWhite,
        ),
        body: const ReviewFormContainer(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.010,
          ),
          child: CustomButton(
            onTap: () {
              // Optional: Validate
              if (controller.rating.value > 0 && controller.comment.value.isNotEmpty) {
                controller.showSuccessDialog();
              } else {
                Get.snackbar('Error', 'Please add rating and comment');
              }
            },
            text: 'Published Review',
          ),
        ),
      ),
    );
  }
}