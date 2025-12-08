import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import '../../controller/review/review_controller.dart';
import '../../core/app_color.dart';

import '../../core/app_textstyle.dart';
import '../../core/utils.dart';
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
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme:  IconThemeData(color: AppColors.appTextColor,),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
              // borderRadius: const BorderRadius.only(
              //   bottomLeft: Radius.circular(50.0),
              //   bottomRight: Radius.circular(50.0),
              // ),
            ),
          ),
          toolbarHeight: 80,
          centerTitle: true,
          title: Obx(() {
            return Text(
              'Write A Review',
              style:  AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,

              ),
            );
          }),

        ),
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(color: AppTextStyle.kNeutralColor),
        //   title: Text(
        //     "Write A Review",
        //     style: AppTextStyle.kTextStyle.copyWith(
        //       color: AppColors.appTextColor,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: AppColors.appWhite,
        // ),
        body: const ReviewFormContainer(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor
          ),
          child: Padding(
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
                  Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Please add rating and comment');
                }
              },
              text: 'Published Review',
            ),
          ),
        ),
      ),
    );
  }
}