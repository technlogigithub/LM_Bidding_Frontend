import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/view/review_screen/review_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../controller/participation/participation_detail_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../../models/static models/participation_detail_model.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/participation_detail_card.dart';
import '../seller screen/seller messgae/chat_list.dart';

class ParticipateDetailsScreen extends StatelessWidget {
  const ParticipateDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ParticipationDetailController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppTextStyle.kNeutralColor),
          title: Text(
            "Participation Details",
            style: AppTextStyle.kTextStyle.copyWith(
              color: AppColors.appTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.zero,
              color: AppColors.appWhite,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(IconlyBold.chat, color: AppTextStyle.kPrimaryColor),
                      const SizedBox(width: 5.0),
                      Text('Message', style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kNeutralColor))
                          .onTap(() => const ChatScreen().launch(context)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(IconlyBold.document, color: Colors.red),
                      SizedBox(width: 5.0),
                      Text('Report', style: TextStyle(color: AppTextStyle.kNeutralColor)),
                    ],
                  ),
                ),
              ],
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.more_vert_rounded, color: AppTextStyle.kNeutralColor),
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: AppColors.appWhite,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.050,vertical: screenHeight * 0.010),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomButton(onTap: () {
                  controller.cancelOrderPopUp(context);
                }, text: 'Cancel',),
              ),
              SizedBox(width: screenWidth * 0.030),
              Expanded(
                child: CustomButton(onTap: () { const ReviewScreen().launch(context); }, text: 'Deliver Work',),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.050),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.010),
              Obx(() {
                if (controller.detail.value == null) {
                  return ParticipationDetailCard(
                    data: ParticipationDetailModel(
                      orderId: '',
                      sellerName: '',
                      orderDate: '',
                      title: '',
                      serviceInfo: '',
                      duration: '',
                      amount: '',
                      status: '',
                      countdownDuration: const Duration(days: 0),
                      revisions: '',
                      fileTypes: '',
                      resolution: '',
                      package: '',
                      subtotal: '',
                      serviceFee: '',
                      total: '',
                      deliveryDate: '',
                      deliveryFileName: '',
                      deliveryFileSubtitle: '',
                      deliveryImagePath: '',
                      showDeliverySection: false,
                    ),
                    isLoading: true,
                  );
                }
                return ParticipationDetailCard(
                  data: controller.detail.value!,
                  isLoading: controller.isLoading.value,
                );
              }),
              SizedBox(height: screenHeight * 0.010),
            ],
          ),
        ),
      ),
    );
  }
}