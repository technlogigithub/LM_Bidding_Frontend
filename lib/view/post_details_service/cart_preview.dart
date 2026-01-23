import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../core/app_color.dart';
import '../../core/app_constant.dart' as AppStrings;
import '../../core/app_images.dart';
import '../../core/app_textstyle.dart';
class CartPreview extends StatefulWidget {
  const CartPreview({super.key});

  @override
  State<CartPreview> createState() => _CartPreviewState();
}

class _CartPreviewState extends State<CartPreview> {
  List<String> paymentMethod = [
    'Credit or Debit Card',
    'Paypal',
    'bkash',
  ];

  String selectedPaymentMethod = 'Credit or Debit Card';
  bool isFavorite = false;
  List<String> imageList = [
    '${AppImage.creditcard}',
    '${AppImage.paypal2}',
    '${AppImage.bkash2}',

  ];
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }
  // Future<void> fetchOrders() async {
  //   try {
  //     final res = await  ApiService.getRequest("ordersApi");
  //     setState(() {
  //       notifications = res["data"] ?? []; // <-- API response structure ke hisaab se adjust karna
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     toast("Error: $e");
  //   }
  //
  // }
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
            'Cart Preview ',
            // controller.referral.value?.label ?? '',
            style:  AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
      ),

      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(gradient: AppColors.appPagecolor),
      //   child: ButtonGlobalWithoutIcon(
      //     buttontext: 'Continue',
      //     buttonDecoration: kButtonDecoration.copyWith(
      //       color: AppColors.appButtonColor,
      //       borderRadius: BorderRadius.circular(30.0),
      //     ),
      //     onPressed: () {
      //       setState(() {
      //         const AddNewCardScreen().launch(context);
      //       });
      //     },
      //     buttonTextColor: AppColors.appButtonTextColor,
      //   ),
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: AppColors.appPagecolor
        ),
        child: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),

                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 10),
                      ),
                    ],

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                    '${AppImage.shot}',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   isFavorite = !isFavorite;
                              // });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isFavorite
                                    ? const Center(
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 16.0,
                                  ),
                                )
                                    : Center(
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: AppColors.neutralColor,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 190,
                                child: Text(
                                  'Mobile UI UX design or app UI UX design.',
                                  style: AppTextStyle.title(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  IconlyBold.star,
                                  color: Colors.amber,
                                  size: 18.0,
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  '5.0',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.appTitleColor,
                                  ),
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  '(520)',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.textgrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                text: 'Price: ',
                                style: AppTextStyle.kTextStyle.copyWith(
                                  color: AppColors.textgrey,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${AppStrings.currencySign}${30}',
                                    style: AppTextStyle.kTextStyle.copyWith(
                                      color: AppColors.appColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                Text(
                    'Order Details',
                    style: AppTextStyle.title()
                ),
                const SizedBox(height: 15.0),
                customrow('Delivery days','2 days'),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Revisions included',
                      style: AppTextStyle.description(),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appDescriptionColor,
                    ),
                  ],
                ),
                // customrow('Revisions','Unlimited'),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                        '3 Page/Screen',
                        style: AppTextStyle.description()
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appDescriptionColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Responsive design',
                      style: AppTextStyle.description(),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appDescriptionColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Source file',
                      style: AppTextStyle.description(),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appDescriptionColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),

                // Text(
                //   'Payment Method',
                //   style: AppTextStyle.title(),
                // ),
                // const SizedBox(height: 20.0),
                // ListView.builder(
                //   itemCount: paymentMethod.length,
                //   shrinkWrap: true,
                //   padding: EdgeInsets.zero,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemBuilder: (_, i) {
                //     return CustomPaymentRadioButton(
                //       title: paymentMethod[i],
                //       image: imageList[i],
                //       isSelected: selectedPaymentMethod == paymentMethod[i],
                //       onTap: () {
                //         setState(() {
                //           selectedPaymentMethod = paymentMethod[i];
                //         });
                //       },
                //     );
                //   },
                // ),
                //
                // const SizedBox(height: 20.0),
                // Text(
                //   'Order Summary',
                //   style: AppTextStyle.title(),
                // ),
                // const SizedBox(height: 20.0),
                // customrow("Subtotal", "${AppStrings.currencySign}${30}"),
                // const SizedBox(height: 10.0),
                // customrow("Service Fee", "${AppStrings.currencySign}${5.50}"),
                // const SizedBox(height: 10.0),
                customrow("Total", "${AppStrings.currencySign}${35.50}"),
                const SizedBox(height: 20.0),
                // customrow("Delivery Date", "Thursday, 14 July 2023"),
                // const SizedBox(height: 10.0),



                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   horizontalTitleGap: 10.0,
                //   leading: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: AppColors.appButtonColor.withOpacity(0.1),
                //       // color: kPrimaryColor.withOpacity(0.1),
                //     ),
                //     child:  Icon(
                //       IconlyBold.document,
                //       color:AppColors.appButtonColor,
                //     ),
                //   ),
                //   title: Text(
                //     'Source file Name',
                //     style: AppTextStyle.description(color: AppColors.appBodyTextColor),
                //   ),
                //   // subtitle: StepProgressIndicator(
                //   //   totalSteps: 100,
                //   //   currentStep: 60,
                //   //   size: 8,
                //   //   padding: 0,
                //   //   selectedColor: AppColors.appButtonColor,
                //   //   unselectedColor: AppColors.appMutedColor ,
                //   //   roundedEdges: const Radius.circular(10),
                //   // ),
                //   trailing: Icon(Icons.remove_red_eye,color: AppColors.appIconColor,),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget customrow( String title, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.description(),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyle.description(color: AppColors.appBodyTextColor),
          ),
        ],
      ),
    );
  }
}
