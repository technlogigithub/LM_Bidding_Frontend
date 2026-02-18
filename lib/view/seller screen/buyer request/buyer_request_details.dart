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

class BuyerRequestDetails extends StatefulWidget {
  const BuyerRequestDetails({super.key});

  @override
  State<BuyerRequestDetails> createState() => _BuyerRequestDetailsState();
}

class _BuyerRequestDetailsState extends State<BuyerRequestDetails> {
  //__________send_Offer_PopUp________________________________________________
  void sendOfferPopUp() {
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
              child: const SendOfferPopUp(),
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
            'Buyer Request Details ',
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
      //     'Buyer Request',
      //     style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      bottomNavigationBar: Container(
        decoration:  BoxDecoration(gradient: AppColors.appPagecolor),
        // padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel Offer',
                  backgroundColor: AppColors.appButtonColor,
                  onTap: () {
                    // same as your old Cancel button
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
        ),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: AppColors.appPagecolor,
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
                          style: AppTextStyle.description(),
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
                        style:AppTextStyle.title(),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur. Elementum nulla quis nunc Lorem ipsum dolor sit amet consectetur. O rci pulvinar sit nec donec pellentesque ve nenatis nunc vel pretium. Dictumst bib en dum pharetra hendrerit tortor nisl. Nulla accumsan ',
                        style: AppTextStyle.description(),
                      ),
                      const SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(text: 'Category: ', style:AppTextStyle.description(), children: [
                          TextSpan(
                            text: 'UI UX Designer',
                            style: AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(text: 'Duration: ', style: AppTextStyle.description(), children: [
                          TextSpan(
                            text: '3 Days',
                            style:  AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(text: 'Price: ', style: AppTextStyle.description(), children: [
                          TextSpan(
                            text: '$currencySign 50',
                            style:  AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          text: 'Offer Sent: ',
                          style:  AppTextStyle.description(),
                          children: [
                            TextSpan(
                              text: '17',
                              style:  AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
