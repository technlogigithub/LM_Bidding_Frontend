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

  @override
  void initState() {
    super.initState();
    _initializeAddress();
  }

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
          // physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Section
                if (tempAddress != null)
                  _buildAddressCard(tempAddress!, 0),
                const SizedBox(height: 15.0),

                Obx(() {
                  final cartResult = controller.cartResponseModel.value?.result?.firstOrNull;
                  final item = cartResult?.items;
                  final info = cartResult?.info;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item != null)
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
                                offset: const Offset(0, 10),
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
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
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
                                          item.title ?? '',
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
                                    if (info?.netPayable != null)
                                      RichText(
                                        text: TextSpan(
                                          text: 'Price: ',
                                          style: AppTextStyle.description(),
                                          children: [
                                            TextSpan(
                                                text: '${AppStrings.currencySign}${info?.netPayable}',
                                                style: AppTextStyle.description(
                                                    color: AppColors.appColor, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 15.0),


                      const SizedBox(height: 20.0),
                      Text('Payment Method', style: AppTextStyle.title()),
                      const SizedBox(height: 20.0),
                      ListView.builder(
                        itemCount: paymentMethod.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, i) {
                          return CustomPaymentRadioButton(
                            title: paymentMethod[i],
                            image: imageList[i],
                            isSelected: selectedPaymentMethod == paymentMethod[i],
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = paymentMethod[i];
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text('Order Summary', style: AppTextStyle.title()),
                      const SizedBox(height: 20.0),
                      if (info?.rawData != null)
                        ...info!.rawData!.entries.map((entry) {
                          return Column(
                            children: [
                              customrow(entry.key, "${AppStrings.currencySign}${entry.value}"),
                              const SizedBox(height: 10.0),
                            ],
                          );
                        }).toList()
                      else ...[
                        // customrow("Subtotal", "${AppStrings.currencySign}${30}"),
                        // const SizedBox(height: 10.0),
                        // customrow("Service Fee", "${AppStrings.currencySign}${5.50}"),
                        // const SizedBox(height: 10.0),
                        // customrow("Total", "${AppStrings.currencySign}${35.50}"),
                        const SizedBox(height: 10.0),
                      ],
                      const SizedBox(height: 10.0),
                    ],
                  );
                }),
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
