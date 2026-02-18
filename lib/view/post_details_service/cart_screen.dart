import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/home/home_controller.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_coupon_apply_field.dart';
import '../../widget/custom_navigator.dart';
import '../../widget/custom_payment_radio_button.dart';
import '../../widget/custom_view_widget.dart';
import '../../widget/form_widgets/custom_toggle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/cart/cart_controller.dart';
import '../../widget/form_widgets/location_picker.dart';
import '../../widget/dynamic_bottom_sheet.dart';
import 'cart_preview.dart';
import 'coupon_custom_bottom_sheet.dart';
import 'post_order_add_card.dart';
import '../../models/Cart/Cart_Model.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Cart/Cart_Item_Model.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';
import '../../models/Post/Get_coupons_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> paymentMethod = ['Credit or Debit Card', 'Paypal', 'bkash'];

  String selectedPaymentMethod = 'Credit or Debit Card';
  bool isFavorite = false;
  List<String> imageList = ['${AppImage.creditcard}', '${AppImage.paypal2}', '${AppImage.bkash2}'];
  bool isWalletUse = false;
  final controller = Get.put(CartController());
  Map<String, dynamic>? tempAddress;
  final RxMap<String, dynamic> couponFormData = <String, dynamic>{}.obs;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeAddress();
  // }

  void _initializeAddress() {
    final addressData = controller.cartResponseModel.value?.result?.first.address;
    if (addressData != null) {
      tempAddress = {'label': addressData.label, 'title': addressData.title, 'description': addressData.description, 'address_lat': addressData.addressLat, 'address_long': addressData.addressLong, 'edit': addressData.edit};
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
    if (MediaQuery.of(context).size.width > 900) {
      return _buildWebLayout(context);
    }
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Obx(() {
          return Text(
            controller.cartTitle.value,
            style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final submitButton = controller.cartResponseModel.value?.result?.firstOrNull?.submitButton?.firstOrNull;
        if (submitButton == null) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: ButtonGlobalWithoutIcon(
            buttontext: submitButton.label ?? '',
            buttonDecoration: kButtonDecoration.copyWith(color: AppColors.appButtonColor, borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
              if (submitButton.apiEndpoint?.isNotEmpty == true) {
                // 1. Collect Basic Data
                String userKey = "";
                final prefs = await SharedPreferences.getInstance();
                userKey = prefs.getString('ukey') ?? "";

                // Get Location
                String lat = "";
                String long = "";
                if (Get.isRegistered<ClientHomeController>()) {
                   final homeCtrl = Get.find<ClientHomeController>();
                   if (homeCtrl.currentLatLng.value.latitude != 0) {
                      lat = homeCtrl.currentLatLng.value.latitude.toString();
                      long = homeCtrl.currentLatLng.value.longitude.toString();
                   }
                }
                
                // 2. Construct Body
                final Map<String, dynamic> body = {
                   "user_key": userKey,
                   "gps_lat": lat,
                   "gps_long": long,
                   ...walletFormData, // Add wallet data
                   ...couponFormData, // Add coupon data
                };

                // 3. Add Shipping/Address Data (Mapping tempAddress to ship_ params as per request)
                 if (tempAddress != null) {
                    body['ship_location'] = tempAddress!['title']; // Example mapping
                    body['ship_address'] = tempAddress!['description'];
                    body['ship_lat'] = tempAddress!['address_lat'];
                    body['ship_long'] = tempAddress!['address_long'];
                    // Add other ship params if available in tempAddress or leave for backed to validate
                 }

                 // 4. Submit
                 await controller.submitCart(
                    apiEndpoint: submitButton.apiEndpoint!,
                    body: body,
                    nextPageName: submitButton.nextPageName,
                    nextPageApiEndpoint: submitButton.nextPageApiEndpoint,
                 );
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
        child: RefreshIndicator(
          color: AppColors.appButtonColor,

          onRefresh: () async {
            final prefs = await SharedPreferences.getInstance();
            final apiEndpoint = prefs.getString('cart_details_endpoint');
            print("cart refresh end points :$apiEndpoint");
            if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
              await controller.fetchCartDetails(cartEndpoint: apiEndpoint);
            } else {
              debugPrint("⚠️ Cart refresh endpoint not found");
            }
          },
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              final cartResult = controller.cartResponseModel.value?.result?.firstOrNull;
              if (cartResult == null || cartResult.rawData == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cartResult.rawData!.keys.map((key) {
                  if (key == 'hidden') return const SizedBox.shrink();

                  if (key == 'address' && cartResult.address != null) {
                    return _buildAddressCard({'label': cartResult.address!.label, 'title': cartResult.address!.title, 'address_lat': cartResult.address!.addressLat, 'address_long': cartResult.address!.addressLong, 'description': tempAddress?['description'] ?? cartResult.address!.description, 'edit': cartResult.address!.edit}, 0);
                  }

                  if (key == 'items' && cartResult.items != null && cartResult.items!.isNotEmpty) {
                    // Usually there's only one items configuration, but we loop just in case
                    return Column(children: cartResult.items!.map((item) => _buildItemsSection(item)).toList());
                  }

                  if (key == 'wallet_use' && cartResult.walletUse != null) {
                    return _buildWalletUseSection(cartResult.walletUse!);
                  }

                  if (key == 'coupon' && cartResult.coupon != null) {
                    return Column(
                      children: [
                        SizedBox(height: 10.h),
                        _buildCouponSection(cartResult.coupon!),
                      ],
                    );
                  }

                  if (key == 'info' && cartResult.info != null) {
                    return _buildInfoSection(cartResult.info!);
                  }

                  return const SizedBox.shrink();
                }).toList(),
              );
            }),
          ),
        ),
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
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(address['description'] ?? '', style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
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
                      onTap: () async {
                        double targetLat = double.tryParse(address['address_lat']?.toString() ?? '0.0') ?? 0.0; // Fallback
                        double targetLng = double.tryParse(address['address_long']?.toString() ?? '0.0') ?? 0.0;
                        bool locationFound = false;
                        print(" backend side to lat and long :$targetLng + $targetLat");

                        // String addressToGeocode = tempAddress?['description'] ?? address['description'] ?? "";
                        //
                        // // 1. Try Geocoding the address string
                        // if (addressToGeocode.isNotEmpty) {
                        //   try {
                        //     List<Location> locations = await locationFromAddress(addressToGeocode);
                        //     if (locations.isNotEmpty) {
                        //       targetLat = locations.first.latitude;
                        //       targetLng = locations.first.longitude;
                        //       locationFound = true;
                        //       debugPrint("📍 Geocoded address to: $targetLat, $targetLng");
                        //     }
                        //   } catch (e) {
                        //     debugPrint("⚠️ Geocoding failed for '$addressToGeocode': $e");
                        //   }
                        // }
                        //
                        // // 2. Fallback to Live Location if geocoding failed
                        // if (!locationFound) {
                        //   try {
                        //     if (Get.isRegistered<ClientHomeController>()) {
                        //       final homeCtrl = Get.find<ClientHomeController>();
                        //       if (homeCtrl.currentLatLng.value.latitude == 0) {
                        //         await homeCtrl.getCurrentLocation();
                        //       }
                        //       if (homeCtrl.currentLatLng.value.latitude != 0) {
                        //         targetLat = homeCtrl.currentLatLng.value.latitude;
                        //         targetLng = homeCtrl.currentLatLng.value.longitude;
                        //         locationFound = true;
                        //       }
                        //     }
                        //   } catch (e) {
                        //     debugPrint("⚠️ Could not get live location: $e");
                        //   }
                        // }

                        Get.to(
                          () => LocationPickerScreen(
                            initialLat: targetLat,
                            initialLng: targetLng,
                            onLocationSelected: (LatLng location, String addressName) {
                              setState(() {
                                tempAddress?['description'] = addressName;
                              });
                            },
                          ),
                        );
                      },
                      child: Icon(FeatherIcons.edit, color: AppColors.appButtonColor, size: 21),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // State maps for Dynamic Forms
  final RxMap<String, dynamic> walletFormData = <String, dynamic>{}.obs;

  Widget _buildWalletUseSection(Items walletUse) {
    if (walletUse.viewType == 'toggle') {
      final toggleInput = walletUse.design?.inputs?.toggle;
      final name = toggleInput?.name ?? 'wallet_use';

      return Obx(() {
        bool boolValue = controller.isWalletUse.value;
        // bool boolValue = walletFormData[name] ?? false;
        debugPrint("✏️ Field Changed → name: $name | view_type: ${walletUse.viewType} | value: $boolValue");
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomToggle(
            label: walletUse.label ?? toggleInput?.label ?? 'Wallet Balance',
            value: boolValue,
            onChanged: (value) {
              controller.isWalletUse.value = value;
              walletFormData[name] = value;
              // walletFormData[name] = value;
              if (toggleInput?.apiEndpoint?.isNotEmpty == true) {
                controller.fetchCartDetails(cartEndpoint: toggleInput!.apiEndpoint!);
              }
            },
          ),
        );
      });
    }
    return const SizedBox.shrink();
  }
  Widget _buildCouponSection(Items coupon) {
    if (coupon.viewType == null || coupon.viewType!.isEmpty) {
      return const SizedBox.shrink();
    }

    final designMap = <String, dynamic>{};
    final endpoints = <String, String>{};

    if (coupon.design?.inputs != null) {
      final inputsMap = <String, dynamic>{};
      final inputs = coupon.design!.inputs!;

      void serializeInput(dynamic button, String key) {
        if (button != null) {
          inputsMap[key] = {
            'input_type': button.inputType ?? 'button',
            'label': button.label,
            'placeholder': button.placeholder,
            'name': button.name,
            'required': button.required,
            'api_endpoint': button.apiEndpoint,
            'options': button.options,
          };

          if (button.name != null && button.apiEndpoint != null) {
            endpoints[button.name!] = button.apiEndpoint!;
          }
        }
      }

      serializeInput(inputs.button, 'button');
      serializeInput(inputs.checkbox, 'checkbox');
      serializeInput(inputs.toggle, 'toggle');

      if (inputs.otherInputs != null) {
        inputsMap.addAll(inputs.otherInputs!);
        inputs.otherInputs!.forEach((k, v) {
          if (v is Map && v['name'] != null && v['api_endpoint'] != null) {
            endpoints[v['name']] = v['api_endpoint'];
          }
        });
      }

      designMap['inputs'] = inputsMap;
    }

    // Pass coupon API endpoint to the input design
    if (coupon.apiEndpoint != null) {
      designMap['api_endpoint'] = coupon.apiEndpoint;
    }

    final registerInput = RegisterInput(
      inputType: coupon.viewType,
      label: coupon.label ?? "",
      design: designMap,
      name: 'coupon_code_field',
      value: controller.couponController.text,
      placeholder: "",
    );

    return Obx(() {
      /// Sync coupon from BottomSheet → UI
      if (controller.appliedCouponCode.value.isNotEmpty &&
          couponFormData['coupon_code_field'] !=
              controller.appliedCouponCode.value) {
        couponFormData['coupon_code_field'] =
            controller.appliedCouponCode.value;

        controller.couponController.text =
            controller.appliedCouponCode.value;

        debugPrint(
          "🟢 Coupon synced from controller: ${controller.appliedCouponCode.value}",
        );
      }
      /// Sync manual typing
      else if (couponFormData['coupon_code_field'] !=
          controller.couponController.text) {
        couponFormData['coupon_code_field'] =
            controller.couponController.text;

        debugPrint(
          "🟡 Coupon from text field: ${controller.couponController.text}",
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DynamicFormBuilder(
          inputs: [registerInput],
          formData: couponFormData,
          errors: const {},
          onFieldChanged: (name, value) {
            couponFormData[name] = value;

            /// Coupon typing
            if (name == 'coupon_code_field') {
              controller.couponController.text = value.toString();

              // Fix: If user types manually and it differs from applied coupon, clear applied coupon to prevent overwrite
              if (controller.appliedCouponCode.value.isNotEmpty &&
                  value.toString() != controller.appliedCouponCode.value) {
                controller.appliedCouponCode.value = '';
              }

              debugPrint("✏️ Coupon typed by user: $value");
            }

            /// Button / Toggle / Checkbox → API call
            if (endpoints.containsKey(name)) {
              debugPrint("🚀 Coupon API triggered");
              debugPrint("➡️ Field: $name");
              debugPrint("➡️ Endpoint: ${endpoints[name]}");

              if (MediaQuery.of(context).size.width > 900) {
                 _fetchCouponsForWeb(endpoints[name]!);
              } else {
                 controller.getCoupons(endpoints[name]!);
              }
            }
          },
        ),
      );
    });
  }

  Future<void> _fetchCouponsForWeb(String endpoint) async {
    try {
      controller.isLoading.value = true;
      // Get Location
      String lat = "";
      String long = "";
       if (Get.isRegistered<ClientHomeController>()) {
          final homeCtrl = Get.find<ClientHomeController>();
          if (homeCtrl.currentLatLng.value.latitude != 0) {
             lat = homeCtrl.currentLatLng.value.latitude.toString();
             long = homeCtrl.currentLatLng.value.longitude.toString();
          }
       }

      String userKey = ""; 
       final prefs = await SharedPreferences.getInstance();
       userKey = prefs.getString('ukey') ?? "";
       String? token = prefs.getString('auth_token');

      final body = {
        "user_key": userKey,
        "gps_lat": lat,
        "gps_long": long,
      };

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

       final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      // Use ApiService.postRequest (assuming it handles raw response or adjust based on return type)
      // Actually CartController uses `makeRequestRaw` which returns dynamic. 
      // looking at _fetchItems in THIS file, it uses ApiService.postRequest and checks response['success'].
      final response = await ApiService.postRequest(cleanEndpoint, body, headers: headers); 

      if (response != null && response['success'] == true) {
         controller.couponsResponseModel.value = CouponsGetResponseModel.fromJson(response);

         await showDialog(
           context: Get.context!, 
           builder: (context) => Dialog(
             backgroundColor: Colors.transparent,
             insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
             child: Center(
               child: Container(
                  width: 500, // Fixed width for web dialog
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor, // Match sheet bg
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const CouponCustomBottomSheet()
               ),
             ),
           ),
         );
      } else {
        debugPrint("❌ Failed to fetch coupons: $response");
      }

    } catch (e) {
       debugPrint("❌ Error fetching coupons web: $e");
    } finally {
      controller.isLoading.value = false;
    }
  }


  Widget _buildInfoSection(Info info) {
    return Obx(() {
      if (controller.isLoadingGetFunction.value) {
        return _buildInfoShimmer();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          if (info.rawData != null)
             ...info.rawData!.entries.map((entry) {
              return Column(children: [customrow(entry.key, "${AppStrings.currencySign}${entry.value}"), const SizedBox(height: 10.0)]);
            }).toList(),
          const SizedBox(height: 10.0),
        ],
      );
    });
  }

  Widget _buildInfoShimmer() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appTextColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Container(
                  height: 16.h,
                  width: 100.w,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                ),
                 Container(
                  height: 16.h,
                  width: 60.w,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  // Fetch items state
  final RxList<CartItem> fetchedItems = <CartItem>[].obs;
  final RxBool isFetchingItems = false.obs;
  final RxBool hasFetchedItems = false.obs;
  Worker? _cartWorker;

  @override
  void initState() {
    super.initState();
    _initializeAddress();
    controller.couponController.clear();
    controller.appliedCouponCode.value='';
    controller.isCouponApplied.value = false;

    // Listen to cart response changes to trigger item fetch
    _cartWorker = ever(controller.cartResponseModel, (model) {
      if (model?.result != null && model!.result!.isNotEmpty) {
        final itemsList = model.result!.first.items;
        final firstItem = itemsList?.where((e) => e.apiEndpoint?.isNotEmpty == true).firstOrNull ?? itemsList?.firstOrNull;

        // Trigger fetch if we haven't fetched yet and endpoint exists
        if (firstItem?.apiEndpoint != null && firstItem!.apiEndpoint!.isNotEmpty && !hasFetchedItems.value) {
          _fetchItems(firstItem.apiEndpoint!);
        }
      }
    });

    // Also check initial value in case it's already there
    final initialModel = controller.cartResponseModel.value;
    if (initialModel?.result != null && initialModel!.result!.isNotEmpty) {
      final itemsList = initialModel.result!.first.items;
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

      // Extract user_key from endpoint if possible (assuming last segment)
      String userKey = "";
      if (endpoint.isNotEmpty) {
        final segments = endpoint.split('/');
        if (segments.isNotEmpty) userKey = segments.last;
      }

      // Get Location from ClientHomeController
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
        debugPrint("⚠️ Could not get location from ClientHomeController: $e");
      }

      final body = {"user_key": userKey, "gps_lat": lat, "gps_long": long};

      debugPrint("🚀 Fetching Item Body: $body");
      debugPrint("🚀 endpoint : $endpoint");

      // Get Token
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final headers = {'Accept': 'application/json', 'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};

      final response = await ApiService.postRequest(endpoint, body, headers: headers);

      if (response != null && response['success'] == true && response['result'] != null) {
        debugPrint("✅ Items fetched successfully");

        final cartItemResponse = CartItemResponseModel.fromJson(response);

        if (cartItemResponse.result?.items != null) {
          fetchedItems.assignAll(cartItemResponse.result!.items!);

          // 🔥 LENGTH PRINT IN TERMINAL
          debugPrint("📦 Items length: ${fetchedItems.length}");
        } else {
          debugPrint("⚠️ result['items'] is null or empty");
        }
      } else {
        debugPrint("❌ Items fetch failed or empty result. Response: $response");
      }
      hasFetchedItems.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching cart items: $e");
    } finally {
      isFetchingItems.value = false;
    }
  }

  Widget _buildItemsSection(Items item) {
    return Obx(() {
      final shouldShowShimmer = !hasFetchedItems.value || 
                                (fetchedItems.isEmpty && (isFetchingItems.value || controller.isLoadingGetFunction.value));
      
      if (shouldShowShimmer) {
        debugPrint("✨ Showing Shimmer: hasFetched=${hasFetchedItems.value}, items=${fetchedItems.length}, loading=${isFetchingItems.value}/${controller.isLoadingGetFunction.value}");
        return _buildItemsShimmer();
      }

      if (fetchedItems.isEmpty) {
        return const SizedBox.shrink();
      }

      // If a list/grid view type is specified for the whole items section,
      // render it once with the entire collection.
      final listTypes = {'custom_vertical_listview_list', 'custom_horizontal_listview_list', 'custom_vertical_gridview_list', 'custom_horizontal_gridview_list'};

      if (item.viewType != null && listTypes.contains(item.viewType)) {
        return CustomViewWidget(
          type: item.viewType!,
          itemDataList: fetchedItems.map((e) => e.toJson()).toList(),
          isFromCartScreen: true,
          onActionTap: (btn, userKey) async {
            String? apiEndpoint = btn['api_endpoint']?.toString();
            String? nextPageName = btn['next_page_name']?.toString();
            String? nextPageApiEndpoint = btn['next_page_api_endpoint']?.toString();
            String? nextPageViewType = btn['next_page_view_type']?.toString();
            String? title = btn['title']?.toString();
            String? description = btn['description']?.toString();
            String? pageImage = btn['page_image']?.toString();
            Map<String, dynamic>? design = btn['design'] is Map<String, dynamic> ? btn['design'] : null;

            bool hasApi = apiEndpoint != null && apiEndpoint.isNotEmpty;
            bool hasNextPage = nextPageName != null && nextPageName.isNotEmpty;
            bool hasNextApi = nextPageApiEndpoint != null && nextPageApiEndpoint.isNotEmpty;
            bool hasNextView = nextPageViewType != null && nextPageViewType.isNotEmpty;

            bool hasConfirmData = (title != null && title.isNotEmpty) && (description != null && description.isNotEmpty);

            // RULE 1: Direct API
            if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
              print("Rule 1 → Direct API");
              _handleActionApiCall(apiEndpoint!);
              return;
            }

            // RULE 2: Navigate +API
            if (hasApi && hasNextApi && !hasConfirmData) {
              print("Rule 2 → Next API + Navigate");
              await controller.participateAndNavigate(
                  participateEndpoint: apiEndpoint!,
                  cartEndpoint: nextPageApiEndpoint!,
                  nextPageName: nextPageName ?? '',
                  shouldFetchCart: true);
              return;
            }

            // Rule 2b: Simple Navigate (No API fetch needed) - Implicitly covered if hasNextApi is false but hasNextPage is true.
            // Logic check: if hasNextPage is true, but hasNextApi is false.
            if (hasNextPage && !hasNextApi && !hasConfirmData) {
              print("Rule 2 →  Navigate");
              CustomNavigator.navigate(nextPageName);
              return;
            }

            // RULE 3: Confirm Data -> Show BidBottomSheet instead of Dialog
            if (!hasNextPage && !hasNextApi && !hasNextView && hasConfirmData) {
              print("Rule 3 → BidBottomSheet");
              var result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: DynamicBottomSheet(title: title, description: description, pageImage: pageImage, design: design == null ? null : CartItemActionDesign.fromJson(design), apiEndpoint: apiEndpoint),
                ),
              );

              if (result == true) {
                if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
                  await controller.actionButtonAction(apiEndpoint);
                }
                // await getPostDetailsController.getPostDetails(widget.ukey ?? '');
              }
              return;
            }
          },
          onFavoriteToggle: (index, val) {
            if (index < fetchedItems.length) {
              fetchedItems[index].info?.favorite = val;
              fetchedItems.refresh();
            }
          },
        );
      }

      return Column(
        children: fetchedItems.map((data) {
          final viewType = data.hidden?.viewType ?? 'unknown';

          return CustomViewWidget(
            type: item.viewType ?? viewType,
            itemData: data.toJson(),
            onActionTap: (btn, userKey) async {
              // 'btn' is Map<String, dynamic>
              String? apiEndpoint = btn['api_endpoint']?.toString();
              String? nextPageName = btn['next_page_name']?.toString();
              String? nextPageApiEndpoint = btn['next_page_api_endpoint']?.toString();
              String? nextPageViewType = btn['next_page_view_type']?.toString();
              String? title = btn['title']?.toString();
              String? description = btn['description']?.toString();
              String? pageImage = btn['page_image']?.toString();
              Map<String, dynamic>? design = btn['design'] is Map<String, dynamic> ? btn['design'] : null;

              bool hasApi = apiEndpoint != null && apiEndpoint.isNotEmpty;
              bool hasNextPage = nextPageName != null && nextPageName.isNotEmpty;
              bool hasNextApi = nextPageApiEndpoint != null && nextPageApiEndpoint.isNotEmpty;
              bool hasNextView = nextPageViewType != null && nextPageViewType.isNotEmpty;

              bool hasConfirmData = (title != null && title.isNotEmpty) && (description != null && description.isNotEmpty);

              // RULE 1: Direct API
              if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
                print("Rule 1 → Direct API");
                _handleActionApiCall(apiEndpoint!);
                return;
              }

              // RULE 2: Navigate +API
              if (hasApi && hasNextApi && !hasConfirmData) {
                print("Rule 2 → Next API + Navigate");
                await controller.participateAndNavigate(
                  participateEndpoint: apiEndpoint!,
                  cartEndpoint: nextPageApiEndpoint!,
                  nextPageName: nextPageName ?? '',
                  shouldFetchCart: true,
                );
                return;
              }

              // Rule 2b: Simple Navigate
              if (hasNextPage && !hasNextApi && !hasConfirmData) {
                print("Rule 2 →  Navigate");
                CustomNavigator.navigate(nextPageName);
                return;
              }

              // RULE 3: Confirm Data -> Show BidBottomSheet instead of Dialog
              if (!hasNextPage && !hasNextApi && !hasNextView && hasConfirmData) {
                print("Rule 3 → BidBottomSheet");
                var result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: DynamicBottomSheet(title: title, description: description, pageImage: pageImage, design: design == null ? null : CartItemActionDesign.fromJson(design), apiEndpoint: apiEndpoint),
                  ),
                );

                if (result == true) {
                  if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
                    await controller.actionButtonAction(apiEndpoint);
                  }
                }
                return;
              }
            },
            onFavoriteToggle: (index, val) {
              if (data.info != null) {
                data.info!.favorite = val;
                fetchedItems.refresh();
              }
            },
          );
        }).toList(),
      );
    });
  }

  Future<void> _handleActionApiCall(String endpoint) async {
    debugPrint("🚀 Handling Action API Call: $endpoint");

    String userKey = "";
    if (endpoint.isNotEmpty) {
      final segments = endpoint.split('/');
      if (segments.isNotEmpty) userKey = segments.last;
    }

    // Get Location from ClientHomeController
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
      debugPrint("⚠️ Could not get location from ClientHomeController: $e");
    }

    debugPrint("🔑 user_key: $userKey");

    final body = {
      "user_key": userKey,
      "gps_lat": lat,
      "gps_long": long,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response =
      await ApiService.postRequest(endpoint, body, headers: headers);

      if (response != null && response['success'] == true) {
        debugPrint("✅ Action API successful");

        // Reset flag to allow cart refetch
        hasFetchedItems.value = false;
        final prefs = await SharedPreferences.getInstance();


        final apiEndpoint = prefs.getString('cart_details_endpoint');
        print("cart refresh end points :$apiEndpoint");
        if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
          await controller.fetchCartDetails(cartEndpoint: apiEndpoint);
        } else {
          debugPrint("⚠️ Cart refresh endpoint not found");
        }
      } else {
        debugPrint("❌ Action API failed: $response");
        toast(response?['message'] ?? "Action failed");
      }
    } catch (e) {
      debugPrint("❌ Action API Error: $e");
    }
  }


  Widget _buildItemsShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appTextColor.withOpacity(0.1),
            child: Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
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
        title: Obx(() {
          return Text(
            controller.cartTitle.value,
            style: AppTextStyle.title(
                color: AppColors.appWhite, fontWeight: FontWeight.bold),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() {
                 final cartResult = controller.cartResponseModel.value?.result?.firstOrNull;
                 if (cartResult == null) {
                   if (controller.isLoadingGetFunction.value) {
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
                                 
                                 // Coupon
                                 if (cartResult.coupon != null) ...[
                                   _buildCouponSection(cartResult.coupon!),
                                   const SizedBox(height: 24),
                                 ],
                                 
                                 // Wallet Usage
                                 if (cartResult.walletUse != null) ...[
                                   _buildWalletUseSection(cartResult.walletUse!),
                                   const SizedBox(height: 24),
                                 ],
                                 
                                 const Divider(),
                                 const SizedBox(height: 16),
                                 
                                 // Pricing Info
                                 if (cartResult.info != null) _buildInfoSection(cartResult.info!),
                                 
                                 const SizedBox(height: 32),
                                 
                                 // Submit Button
                                 if (cartResult.submitButton?.isNotEmpty == true)
                                   _buildWebSubmitButton(cartResult.submitButton!.first),
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

  Widget _buildWebSubmitButton(SubmitButton submitButton) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appButtonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
              if (submitButton.apiEndpoint?.isNotEmpty == true) {
                String userKey = "";
                final prefs = await SharedPreferences.getInstance();
                userKey = prefs.getString('ukey') ?? "";

                String lat = "";
                String long = "";
                if (Get.isRegistered<ClientHomeController>()) {
                   final homeCtrl = Get.find<ClientHomeController>();
                   if (homeCtrl.currentLatLng.value.latitude != 0) {
                      lat = homeCtrl.currentLatLng.value.latitude.toString();
                      long = homeCtrl.currentLatLng.value.longitude.toString();
                   }
                }
                
                final Map<String, dynamic> body = {
                   "user_key": userKey,
                   "gps_lat": lat,
                   "gps_long": long,
                   ...walletFormData,
                   ...couponFormData,
                };

                 if (tempAddress != null) {
                    body['ship_location'] = tempAddress!['title'];
                    body['ship_address'] = tempAddress!['description'];
                    body['ship_lat'] = tempAddress!['address_lat'];
                    body['ship_long'] = tempAddress!['address_long'];
                 }

                 await controller.submitCart(
                    apiEndpoint: submitButton.apiEndpoint!,
                    body: body,
                    nextPageName: submitButton.nextPageName,
                    nextPageApiEndpoint: submitButton.nextPageApiEndpoint,
                 );
              }
          },
          child: Text(
            submitButton.label ?? 'Place Order',
            style: AppTextStyle.title(color: AppColors.appButtonTextColor, fontWeight: FontWeight.bold),
          ),
        ),
    );
  }
}
