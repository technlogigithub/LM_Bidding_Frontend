import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/app_constant.dart';
import '../../models/static models/participation_detail_model.dart';
import '../../widget/app_social_icons.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/app_textfield.dart';

class ParticipationDetailController extends GetxController {
  var isLoading = true.obs;
  var detail = Rxn<ParticipationDetailModel>();

  @override
  void onInit() {
    super.onInit();
    loadStaticData();
  }

  void loadStaticData() {
    Future.delayed(const Duration(seconds: 2), () {
      detail.value = ParticipationDetailModel(
        orderId: 'F025E15',
        sellerName: 'Shaidul Islam',
        orderDate: '24 Jun 2023',
        title: 'Mobile UI UX design or app UI UX design',
        serviceInfo: 'Lorem ipsum dolor sit amet consectetur. Tortor sapien aliquam amet elit. Quis varius amet grav ida molestie rhoncus. Lorem ipsum dolor sit amet consectetur. Tortor sapien aliquam amet elit. Quis varius amet grav ida molestie rhoncus.',
        duration: '3 Days',
        amount: '5.00',
        status: 'Active',
        countdownDuration: const Duration(days: 3),
        revisions: 'Unlimited Revisions',
        fileTypes: 'Source file, JPG, PNG, ZIP',
        resolution: 'High resolution',
        package: 'Basic',
        subtotal: '5.00',
        serviceFee: '2.00',
        total: '7.00',
        deliveryDate: 'Thursday, 24 Jun 2023',
        deliveryFileName: 'UI UX Design Mobile app...',
        deliveryFileSubtitle: 'Figma file 23564 25452...',
        deliveryImagePath: 'assets/images/file.png',
        showDeliverySection: true,
      );
      isLoading.value = false;
    });
  }

  void cancelOrderPopUp(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.transparent, // IMPORTANT for gradient
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor, // ✅ Your gradient here
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const CancelOrderPopUp(),
              ),
            );

          },
        );
      },
    );
  }
}
class CancelOrderPopUp extends StatefulWidget {
  const CancelOrderPopUp({super.key});

  @override
  State<CancelOrderPopUp> createState() => _CancelOrderPopUpState();
}

class _CancelOrderPopUpState extends State<CancelOrderPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you Cancelling?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.title( fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
             Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.appMutedColor,
            ),
            const SizedBox(height: 20.0),
            CustomTextfield(
              label: 'Enter Reason',
              hintText: 'Lorem ipsum dolor sit amet, cons lecture adipiscing elit.',
              keyboardType: TextInputType.multiline,
              lines: 2, // same as maxLines: 2
              textInputAction: TextInputAction.next,
              // controller: yourController, // optional
              onChanged: (value) {
                // handle change
              },
            ),
            //
            // TextFormField(
            //   keyboardType: TextInputType.multiline,
            //   maxLines: 2,
            //   cursorColor: kNeutralColor,
            //   textInputAction: TextInputAction.next,
            //   decoration: kInputDecoration.copyWith(
            //       labelText: 'Enter Reason',
            //       labelStyle: kTextStyle.copyWith(color: kNeutralColor),
            //       hintText: 'Lorem ipsum dolor sit amet, cons lecture adipiscing elit.',
            //       hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
            //       focusColor: kNeutralColor,
            //       border: const OutlineInputBorder(),
            //       floatingLabelBehavior: FloatingLabelBehavior.always
            //   ),
            // ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    backgroundColor: AppColors.appButtonColor,
                    onTap: () {
                      finish(context);
                    },
                  ),
                ),
                const SizedBox(width: 12), // spacing between buttons
                Expanded(
                  child: CustomButton(
                    text: 'Confirm',
                    backgroundColor:  AppColors.appButtonColor,
                    onTap: () {
                      finish(context);
                    },
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}