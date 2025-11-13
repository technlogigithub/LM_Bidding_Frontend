import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../controller/review/review_controller.dart';

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
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Text(
                'Review your experience',
                style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.neutralColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                'How would you rate your overall experience with this buyer?',
                style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor),
              ),
              const SizedBox(height: 20.0),

              // Profile Section
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
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
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.neutralColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      controller.reviewData.level,
                      style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),
              Text(
                'Select Rating',
                style: AppTextStyle.kTextStyle.copyWith(color: AppColors.neutralColor),
              ),
              const SizedBox(height: 5.0),
              RatingBarWidget(
                itemCount: 5,
                activeColor: AppTextStyle.ratingBarColor,
                inActiveColor: AppColors.kBorderColorTextField,
                rating: controller.rating.value,
                onRatingChanged: (rating) => controller.updateRating(rating),
              ),

              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                cursorColor: AppColors.neutralColor,
                maxLines: 3,
                onChanged: controller.updateComment,
                decoration: AppTextStyle.kInputDecoration.copyWith(
                  labelText: 'Write a Comment',
                  labelStyle: AppTextStyle.kTextStyle.copyWith(color: AppColors.neutralColor),
                  hintText: 'Share your experience...',
                  hintStyle: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kLightNeutralColor),
                  focusColor: AppColors.neutralColor,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 20.0),
              Text(
                'Upload Image (Optional)',
                style: AppTextStyle.kTextStyle.copyWith(color: AppColors.neutralColor),
              ),
              const SizedBox(height: 10.0),

              // Image Upload Box
              Obx(() => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: 93,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.appWhite,
                    border: Border.all(color: AppColors.kBorderColorTextField),
                    image: controller.uploadedImage.value != null
                        ? DecorationImage(
                      image: FileImage(File(controller.uploadedImage.value!)),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.uploadedImage.value == null
                      ? const Center(
                    child: Icon(
                      IconlyBold.camera,
                      color: AppTextStyle.kLightNeutralColor,
                    ),
                  )
                      : null,
                ),
              )),

              const SizedBox(height: 30.0),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
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