import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_color.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_textstyle.dart';
import '../../../widget/app_social_icons.dart';
import '../../../widget/form_widgets/app_button.dart';
import '../seller popUp/seller_popup.dart';
import 'buyer_request_details.dart';

class BuyerRequestScreen extends StatefulWidget {
  const BuyerRequestScreen({super.key});

  @override
  State<BuyerRequestScreen> createState() => _BuyerRequestScreenState();
}

class _BuyerRequestScreenState extends State<BuyerRequestScreen> {

  //__________send_Offer_PopUp________________________________________________
  void sendOfferPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              backgroundColor: Colors.transparent, // ✅ Required for gradient
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor, // ✅ Your page gradient here
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const SendOfferPopUp(),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
             'Requested Post',
            style:  AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
      ),
      // appBar: AppBar(
      //   backgroundColor: kDarkWhite,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: kNeutralColor),
      //   title: Text(
      //     'Requested Post',
      //     style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () => const BuyerRequestDetails().launch(context),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: AppColors.appPagecolor,
                            // border: Border.all(color: kBorderColorTextField),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.appMutedColor,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(0, 10),
                                // blurRadius: 1,
                                // spreadRadius: 1,
                                // offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 44.h,
                                  width: 44.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/profilepic2.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Shaidul Islam',
                                  style:AppTextStyle.title(),
                                ),
                                subtitle: Text(
                                  '28 Jun 2023',
                                  style:AppTextStyle.description(),
                                ),
                              ),
                               Divider(
                                height: 0,
                                thickness: 1.0,
                                color: AppColors.appMutedColor,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                'I Need UI UX Designer',
                                style: AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5.0),
                              ReadMoreText(
                                'Lorem ipsum dolor sit amet consectetur. Elementum nulla quis nunc Lorem ipsum dolor sit amet consectetur. O rci pulvinar sit nec donec pellentesque ve nenatis nunc vel pretium. Dictumst bib en dum pharetra hendrerit tortor nisl. Nulla accumsan ',
                                style: AppTextStyle.body(color: AppColors.appDescriptionColor),
                                trimLines: 2,
                                colorClickableText: AppColors.appColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '..Read more',
                                trimExpandedText: '..Read less',
                              ),
                              const SizedBox(height: 10.0),
                              RichText(
                                text: TextSpan(text: 'Category: ', style: AppTextStyle.description(), children: [
                                  TextSpan(
                                    text: 'UI UX Designer',
                                    style:AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                                  )
                                ]),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Cancel Offer',
                                      backgroundColor: AppColors.appButtonColor,
                                      onTap: () {
                                        // same as old onPressed
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Send Offer',
                                      backgroundColor: AppColors.appButtonColor,
                                      onTap: () {
                                        sendOfferPopUp(); // no need for setState here
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
