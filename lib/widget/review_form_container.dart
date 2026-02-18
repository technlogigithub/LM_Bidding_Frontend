import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_color.dart';
import '../controller/review/review_controller.dart';
import '../core/app_textstyle.dart';
import 'form_widgets/custom_file_picker.dart';
import 'form_widgets/custom_textarea.dart';

class ReviewFormContainer extends StatelessWidget {
  final VoidCallback? onSubmit;

  const ReviewFormContainer({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmer(screenHeight, screenWidth);
      }

      return Container(
        padding: const EdgeInsets.all(10),
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(30.0),
          //   topRight: Radius.circular(30.0),
          // ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Text(
                'Review your experience',
                style: AppTextStyle.title(

                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                'How would you rate your overall experience with this buyer?',
                style: AppTextStyle.description(color: AppColors.appDescriptionColor),
              ),
              const SizedBox(height: 20.0),

              // Profile Section
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 90.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20), // stronger shadow
                            blurRadius: 12,     // soft glow
                            spreadRadius: 5,    // outer spread
                            offset: Offset(0, 4), // down shadow
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8), // top highlight
                            blurRadius: 6,
                            spreadRadius: -2,
                            offset: Offset(0, -2),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(controller.reviewData.profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      controller.reviewData.name,
                      style: AppTextStyle.title(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      controller.reviewData.level,
                      style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),
              Text(
                'Select Rating',
                style: AppTextStyle.title(),
              ),
              const SizedBox(height: 5.0),
              RatingBarWidget(
                itemCount: 5,
                activeColor: Colors.amber,
                inActiveColor:  Colors.amber,
                rating: controller.rating.value,
                onRatingChanged: (rating) => controller.updateRating(rating),
              ),

              const SizedBox(height: 20.0),
              CustomTextarea(
                label: 'Write a Comment',
                hintText: 'Share your experience...',
                minLines: 3,
                maxLines: 3,
                // controller: commentController, // optional
              ),


              const SizedBox(height: 20.0),
              Text(
                'Upload Image (Optional)',
                style: AppTextStyle.title(),
              ),
              const SizedBox(height: 10.0),

              // Image Upload Box
              Obx(
                    () => CustomFilePicker(
                  label: '', // no top label (since your old UI had no text)
                  isImageFile: true,
                  category: 'image',
                  value: controller.uploadedImage.value != null
                      ? File(controller.uploadedImage.value!)
                      : null,
                  onPicked: (file) {
                    controller.uploadedImage.value = file?.path;
                  },
                ),
              ),


              const SizedBox(height: 30.0),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor,
      highlightColor: AppColors.appMutedTextColor,
      child: Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _shimmerBox(200, 16),
            const SizedBox(height: 5),
            _shimmerBox(300, 14),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  _shimmerBox(100, 100, shape: BoxShape.circle),
                  const SizedBox(height: 10),
                  _shimmerBox(120, 16),
                  const SizedBox(height: 5),
                  _shimmerBox(100, 14),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _shimmerBox(100, 16),
            const SizedBox(height: 5),
            _shimmerBox(200, 20),
            const SizedBox(height: 20),
            _shimmerBox(double.infinity, 80), // TextField
            const SizedBox(height: 20),
            _shimmerBox(150, 16),
            const SizedBox(height: 10),
            _shimmerBox(93, 65),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {BoxShape shape = BoxShape.rectangle}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(4) : null,
        shape: shape,
      ),
    );
  }
}