import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_color.dart';
import '../../models/static models/review_model.dart';
import '../../widget/success_dialog.dart';

class ReviewController extends GetxController {
  var isLoading = true.obs;
  var rating = 0.0.obs;
  var comment = ''.obs;
  var uploadedImage = Rxn<String>();

  late ReviewModel reviewData;

  @override
  void onInit() {
    super.onInit();
    loadStaticData();
  }

  void loadStaticData() {
    Future.delayed(const Duration(seconds: 1), () {
      reviewData = ReviewModel(
        profileImage: 'assets/images/profilepic2.png',
        name: 'William Liam',
        level: 'Seller Level - 1',
        initialRating: 4.5,
      );
      rating.value = reviewData.initialRating;
      isLoading.value = false;
    });
  }

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  void updateComment(String text) {
    comment.value = text;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uploadedImage.value = pickedFile.path;
    }
  }

  // Reusable Success Dialog
  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.appWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: const SuccessDialog(),
      ),
      barrierDismissible: false,
    );
  }
}