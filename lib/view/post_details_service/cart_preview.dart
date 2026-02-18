import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/cart/cart_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../models/Cart/Cart_Item_Model.dart';
import '../../models/Cart/Cart_preview_Model.dart'; // Model for this screen
import '../../widget/button_global.dart';
import '../../widget/custom_navigator.dart';
import '../../widget/custom_payment_radio_button.dart';
import '../../widget/custom_view_widget.dart';
import '../../widget/form_widgets/location_picker.dart';
import '../../widget/dynamic_bottom_sheet.dart';

class CartPreview extends StatefulWidget {
  const CartPreview({super.key});

  @override
  State<CartPreview> createState() => _CartPreviewState();
}

class _CartPreviewState extends State<CartPreview> {
  final controller = Get.find<CartController>();
  Map<String, dynamic>? tempAddress;

  // Selected Payment Method Index
  final RxInt selectedPaymentIndex = (-1).obs;

  // Fetch items state
  final RxList<CartItem> fetchedItems = <CartItem>[].obs;
  final RxBool isFetchingItems = false.obs;
  final RxBool hasFetchedItems = false.obs;
  Worker? _cartWorker;

  @override
  void initState() {
    super.initState();
    _initializeAddress();

    // Listen to cart PREVIEW response changes
    _cartWorker = ever(controller.cartPreviewResponse, (model) {
      if (model?.result != null && model!.result!.isNotEmpty) {
        _handleItemFetch(model!);
        _updateAddress(model);
      }
    });

    // Initial check
    if (controller.cartPreviewResponse.value?.result != null &&
        controller.cartPreviewResponse.value!.result!.isNotEmpty) {
      _handleItemFetch(controller.cartPreviewResponse.value!);
      _updateAddress(controller.cartPreviewResponse.value!);
    }
  }

  void _updateAddress(CartPreviewResponseModel model) {
    if (model.result == null || model.result!.isEmpty) return;
    
    final addressData = model.result!.first.address;
    if (addressData != null) {
      setState(() {
         tempAddress = {
          'label': addressData.label,
          'title': addressData.title,
          'description': addressData.description,
          'address_lat': addressData.addressLat,
          'address_long': addressData.addressLong,
          'edit': addressData.edit == true // ensure boolean
        };
      });
    }
  }

  void _initializeAddress() {
    if (controller.cartPreviewResponse.value?.result != null && 
        controller.cartPreviewResponse.value!.result!.isNotEmpty) {
      _updateAddress(controller.cartPreviewResponse.value!);
    }
  }

  void _handleItemFetch(CartPreviewResponseModel model) {
    if (model.result == null || model.result!.isEmpty) return;
    
    final result = model.result!.first;
    if (result.items != null && result.items!.isNotEmpty) {
      final itemsList = result.items;
      final firstItem = itemsList?.where((e) => e.apiEndpoint?.isNotEmpty == true).firstOrNull ?? itemsList?.firstOrNull;

      if (firstItem?.apiEndpoint != null && firstItem!.apiEndpoint!.isNotEmpty && !hasFetchedItems.value) {
        _fetchItems(firstItem.apiEndpoint!);
      }
    }
  }

  @override
  void dispose() {
    _cartWorker?.dispose();
    super.dispose();
  }

  Future<void> _fetchItems(String endpoint) async {
    if (isFetchingItems.value || hasFetchedItems.value) return;

    debugPrint("🚀 Triggering _fetchItems for endpoint: $endpoint");

    try {
      isFetchingItems.value = true;

      // Extract user_key from endpoint if possible
      String userKey = "";
      if (endpoint.isNotEmpty) {
        final segments = endpoint.split('/');
        if (segments.isNotEmpty) userKey = segments.last;
      }

      // Get Location
      String lat = "";
      String long = "";
      try {
        if (Get.isRegistered<ClientHomeController>()) {
          final homeCtrl = Get.find<ClientHomeController>();
          if (homeCtrl.currentLatLng.value.latitude != 0) {
            lat = homeCtrl.currentLatLng.value.latitude.toString();
            long = homeCtrl.currentLatLng.value.longitude.toString();
          }
        }
      } catch (e) {
        debugPrint("⚠️ Could not get location: $e");
      }

      final body = {"user_key": userKey, "gps_lat": lat, "gps_long": long};
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };
      print(" code >> $endpoint  >> $body");

      final response = await ApiService.postRequest(endpoint, body, headers: headers);

      if (response != null && response['success'] == true && response['result'] != null) {
        final cartItemResponse = CartItemResponseModel.fromJson(response);
        if (cartItemResponse.result?.items != null) {
          fetchedItems.assignAll(cartItemResponse.result!.items!);
        }
      }
      hasFetchedItems.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching items: $e");
    } finally {
      isFetchingItems.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 900) {
      return _buildWebLayout(context);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appbarColor),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Cart Preview", 
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final cartResult = controller.cartPreviewResponse.value?.result?.firstOrNull;
        if (cartResult == null || cartResult.paymentMethods == null || cartResult.paymentMethods!.isEmpty) return const SizedBox.shrink();

        // Ensure index is valid & something is selected
        if (selectedPaymentIndex.value == -1 || selectedPaymentIndex.value >= cartResult.paymentMethods!.length) {
           return const SizedBox.shrink();
        }

        final selectedMethod = cartResult.paymentMethods![selectedPaymentIndex.value];
        final btn = selectedMethod.button;

        if (btn == null) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: ButtonGlobalWithoutIcon(
            buttontext: btn.label ?? '',
            buttonDecoration: kButtonDecoration.copyWith(color: AppColors.appButtonColor, borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
               if (btn.apiEndpoint?.isNotEmpty == true) {
                 controller.paymentMethodCall(endpoint: btn.apiEndpoint!,nextpagename: btn.nextPageName!, nextpageapiendpoint: btn.nextPageApiEndpoint!);
               }
            },
            buttonTextColor: AppColors.appButtonTextColor,
          ),
        );
      }),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              final cartResult = controller.cartPreviewResponse.value?.result?.firstOrNull;
              if (cartResult == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Address Section
                   if (cartResult.address != null)
                      _buildAddressCard({
                        'label': cartResult.address!.label,
                        'title': cartResult.address!.title,
                        'address_lat': cartResult.address!.addressLat,
                        'address_long': cartResult.address!.addressLong,
                        'description': tempAddress?['description'] ?? cartResult.address!.description,
                        'edit': cartResult.address!.edit
                      }, 0),
                   
                   // Items Section
                   if (cartResult.items != null && cartResult.items!.isNotEmpty)
                      ...cartResult.items!.map((item) => _buildItemsSection(item)).toList(),

                   // Info Section
                    if (cartResult.info != null)
                      _buildInfoSection(cartResult.info!),
                   
                   // Payment Method Section
                   if (cartResult.paymentMethods != null && cartResult.paymentMethods!.isNotEmpty)
                      _buildPaymentMethodsSection(cartResult.paymentMethods!)

                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ================= WEB LAYOUT =================

  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        title: Text(
          "Cart Preview",
          style: AppTextStyle.title(
              color: AppColors.appWhite, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() {
                 final cartResult = controller.cartPreviewResponse.value?.result?.firstOrNull;
                 if (cartResult == null) {
                   if (isFetchingItems.value) {
                     return const Center(child: CircularProgressIndicator());
                   }
                   return const SizedBox.shrink(); 
                 }

                 return Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // LEFT COLUMN (Items & Address)
                     Expanded(
                       flex: 7,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           // Address Section
                           if (cartResult.address != null)
                             _buildAddressCard({
                               'label': cartResult.address!.label,
                               'title': cartResult.address!.title,
                               'address_lat': cartResult.address!.addressLat,
                               'address_long': cartResult.address!.addressLong,
                               'description': tempAddress?['description'] ?? cartResult.address!.description,
                               'edit': cartResult.address!.edit
                             }, 0),
                           
                           const SizedBox(height: 24),
                           
                           // Items Section
                           if (cartResult.items != null && cartResult.items!.isNotEmpty)
                             ...cartResult.items!.map((item) => _buildItemsSection(item)).toList(),
                         ],
                       ),
                     ),
                     const SizedBox(width: 32),
                     
                     // RIGHT COLUMN (Summary & Payment)
                     Expanded(
                       flex: 5,
                       child: Column(
                         children: [
                           Container(
                             padding: const EdgeInsets.all(24),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(16),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.black.withOpacity(0.05),
                                   blurRadius: 20,
                                   offset: const Offset(0, 10),
                                 ),
                               ],
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Order Summary", style: AppTextStyle.title(fontWeight: FontWeight.bold).copyWith(fontSize: 20)),
                                 const SizedBox(height: 24),
                                 
                                 // Pricing Info
                                 if (cartResult.info != null) _buildInfoSection(cartResult.info!),
                                 
                                 const SizedBox(height: 24),

                                 // Payment Method Section
                                 if (cartResult.paymentMethods != null && cartResult.paymentMethods!.isNotEmpty)
                                    _buildPaymentMethodsSection(cartResult.paymentMethods!),

                                 const SizedBox(height: 32),
                                 
                                 // Submit Button Logic for Web
                                 _buildWebSubmitButton(cartResult),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebSubmitButton(Result cartResult) {
    if (cartResult.paymentMethods == null || cartResult.paymentMethods!.isEmpty) return const SizedBox.shrink();

    // Ensure index is valid & something is selected
    if (selectedPaymentIndex.value == -1 || selectedPaymentIndex.value >= cartResult.paymentMethods!.length) {
       return const SizedBox.shrink();
    }

    final selectedMethod = cartResult.paymentMethods![selectedPaymentIndex.value];
    final btn = selectedMethod.button;

    if (btn == null) return const SizedBox.shrink();

    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appButtonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
             if (btn.apiEndpoint?.isNotEmpty == true) {
               controller.paymentMethodCall(endpoint: btn.apiEndpoint!,nextpagename: btn.nextPageName!, nextpageapiendpoint: btn.nextPageApiEndpoint!);
             }
          },
          child: Text(
            btn.label ?? 'Place Order',
            style: AppTextStyle.title(color: AppColors.appButtonTextColor, fontWeight: FontWeight.bold),
          ),
        ),
    );
  }

  Widget customrow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(title, style: AppTextStyle.description()),
          const Spacer(),
          Text(value, style: AppTextStyle.description(color: AppColors.appBodyTextColor)),
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
        boxShadow: [BoxShadow(color: AppColors.appMutedColor, blurRadius: 5, spreadRadius: 1, offset: const Offset(0, 10))],
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
                        Text(address['label'] ?? '', style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                        Text(
                          " : ${address['title'] ?? ''}",
                          style: AppTextStyle.title(fontWeight: FontWeight.bold, color: AppColors.appTitleColor),
                        ),
                      ],
                    ),
                     SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20),
                         SizedBox(width: 10.w),
                        Expanded(
                          child: Text(address['description'] ?? '', style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // if (address['edit'] == true)
              //   Row(
              //     children: [
              //       const SizedBox(width: 12),
              //       GestureDetector(
              //         onTap: () {
              //            double targetLat = double.tryParse(address['address_lat']?.toString() ?? '0.0') ?? 0.0;
              //           double targetLng = double.tryParse(address['address_long']?.toString() ?? '0.0') ?? 0.0;
              //
              //           Get.to(
              //             () => LocationPickerScreen(
              //               initialLat: targetLat,
              //               initialLng: targetLng,
              //               onLocationSelected: (LatLng location, String addressName) {
              //                 setState(() {
              //                   if (tempAddress == null) {
              //                     tempAddress = {};
              //                   }
              //                   tempAddress!['description'] = addressName;
              //                 });
              //               },
              //             ),
              //           );
              //         },
              //         child: Icon(FeatherIcons.edit, color: AppColors.appButtonColor, size: 21),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Info info) {
    if (info.rawData == null || info.rawData!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        ...info.rawData!.entries.map((entry) {
          return customrow(
            entry.key.toString(),
            "${AppStrings.currencySign}${entry.value}",
          );
        }).toList(),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildItemsSection(Items item) {
    return Obx(() {
      final shouldShowShimmer = !hasFetchedItems.value || 
                                (fetchedItems.isEmpty && (isFetchingItems.value));
      
      if (shouldShowShimmer) {
        return _buildItemsShimmer();
      }

      if (fetchedItems.isEmpty) return const SizedBox.shrink();

      final listTypes = {'custom_vertical_listview_list', 'custom_horizontal_listview_list', 'custom_vertical_gridview_list', 'custom_horizontal_gridview_list'};

      if (item.viewType != null && listTypes.contains(item.viewType)) {
        return CustomViewWidget(
          type: item.viewType!,
          itemDataList: fetchedItems.map((e) => e.toJson()).toList(),
          isFromCartScreen: false,
          onActionTap: (btn, userKey) async {
             // Handle action taps
          },
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildItemsShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appTextColor.withOpacity(0.1),
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection(List<PaymentMethods> paymentMethods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Text("Payment Methods", style: AppTextStyle.title()),
        // const SizedBox(height: 15),
        ListView.builder(
          itemCount: paymentMethods.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
             final method = paymentMethods[i];
             return Obx(() => CustomPaymentRadioButton(
                title: method.label ?? '',
                image: method.icon ?? '', 
                isSelected: selectedPaymentIndex.value == i,
                onTap: () {
                   selectedPaymentIndex.value = i;
                },
             ));
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
