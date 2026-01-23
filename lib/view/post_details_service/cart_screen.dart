import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_payment_radio_button.dart';
import '../../widget/custom_view_widget.dart';
import '../../widget/form_widgets/custom_toggle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/post/get_post_details_controller.dart';
import '../../widget/form_widgets/location_picker.dart';
import 'cart_preview.dart';
import 'post_order_add_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
  final controller = Get.find<GetPostDetailsController>();
  Map<String, dynamic>? tempAddress;


  void _initializeAddress() {
    final addressData = controller.cartResponseModel.value?.result?.first.address;
    if (addressData != null) {
      tempAddress = {
        'label': addressData.label,
        'title': addressData.title,
        'description': addressData.description,
        'edit': addressData.edit,
      };
    }
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
            'Cart',
            // controller.referral.value?.label ?? '',
            style:  AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
      ),
      // appBar: AppBar(
      //
      //   elevation: 0.0,
      //   backgroundColor: AppColors.appWhite,
      //   centerTitle: true,
      //   iconTheme: IconThemeData(color: AppColors.neutralColor),
      //   title: Text(
      //     'Order',
      //     style: AppTextStyle.kTextStyle.copyWith(
      //       color: AppColors.appTextColor,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Obx(() {
        final submitButton = controller.cartResponseModel.value?.result?.firstOrNull?.submitButton?.firstOrNull;
        if (submitButton == null) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: ButtonGlobalWithoutIcon(
            buttontext: submitButton.label ?? 'Continue',
            buttonDecoration: kButtonDecoration.copyWith(
              color: AppColors.appButtonColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              if (submitButton.nextPageName == 'cart_preview') {
                const CartPreview().launch(context);
              } else if (submitButton.apiEndpoint?.isNotEmpty == true) {
                controller.executeApiAction(submitButton.apiEndpoint!);
              }
            },
            buttonTextColor: AppColors.appButtonTextColor,
          ),
        );
      }),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
               final cartResult = controller.cartResponseModel.value?.result?.firstOrNull;

               return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                   

                     return Column(
                       children: [
                       ],
                     );
               );
            }),
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

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        boxShadow: [
          BoxShadow(
            color: AppColors.appMutedColor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address['label'] ?? '',
                          style: AppTextStyle.description(
                            color: AppColors.appDescriptionColor,
                          ),
                        ),
                        Text(
                          " : ${address['title'] ?? ''}",
                          style: AppTextStyle.title(
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTitleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            address['description'] ?? '',
                            style: AppTextStyle.description(
                              color: AppColors.appDescriptionColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (address['edit'] == true)
                Row(
                  children: [
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => LocationPickerScreen(
                              initialLat: 22.7196, // Default coords
                              initialLng: 75.8577,
                              onLocationSelected: (LatLng location, String addressName) {
                                setState(() {
                                  tempAddress?['description'] = addressName;
                                });
                              },
                            ));
                      },
                      child: Icon(
                        FeatherIcons.edit,
                        color: AppColors.appButtonColor,
                        size: 21,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
