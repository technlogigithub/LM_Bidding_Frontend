import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/home/home_controller.dart';
import '../../../controller/my_orders/my_orders_controller.dart';
import '../../../core/api_config.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_textstyle.dart';
import '../../../models/Cart/Cart_Item_Model.dart';
import '../../../models/Order/order_details_model.dart';
import '../../../models/App_moduls/AppResponseModel.dart';
import '../../../widget/button_global.dart';
import '../../../widget/custom_navigator.dart';
import '../../../widget/form_widgets/app_button.dart';
import '../../../widget/custom_view_widget.dart';
import '../../../widget/dynamic_bottom_sheet.dart';


class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final controller = Get.put(MyOrdersController());
  Map<String, dynamic>? tempAddress;

  // Selected Payment Method Index
  final RxInt selectedPaymentIndex = (-1).obs;


  Worker? _cartWorker;

  @override
  void initState() {
    super.initState();
    _initializeAddress();

    // Listen to cart PREVIEW response changes
    // _cartWorker = ever(controller.cartPreviewResponse, (model) {
    //   if (model?.result != null && model!.result!.isNotEmpty) {
    //     _handleItemFetch(model!);
    //     _updateAddress(model);
    //   }
    // });

    // Initial check
    if (controller.getOrderDetailsResponseModel.value?.result != null &&
        controller.getOrderDetailsResponseModel.value!.result!.isNotEmpty) {
      _handleItemFetch(controller.getOrderDetailsResponseModel.value!);
      _updateAddress(controller.getOrderDetailsResponseModel.value!);
    }
  }

  void _updateAddress(GetOrderDetailsResponseModel model) {
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
    if (controller.getOrderDetailsResponseModel.value?.result != null &&
        controller.getOrderDetailsResponseModel.value!.result!.isNotEmpty) {
      _updateAddress(controller.getOrderDetailsResponseModel.value!);
    }
  }

  void _handleItemFetch(GetOrderDetailsResponseModel model) {
    if (model.result == null || model.result!.isEmpty) return;

    final result = model.result!.first;
    if (result.detailsItems != null && result.detailsItems!.isNotEmpty) {
      final itemsList = result.detailsItems;
      final firstItem = itemsList?.where((e) => e.apiEndpoint?.isNotEmpty == true).firstOrNull ?? itemsList?.firstOrNull;

      if (firstItem?.apiEndpoint != null && firstItem!.apiEndpoint!.isNotEmpty) {
      // if (firstItem?.apiEndpoint != null && firstItem!.apiEndpoint!.isNotEmpty && !controller.hasFetchedItems.value) {
        controller.fetchOrderItems(firstItem.apiEndpoint!);
      }
    }
  }

  @override
  void dispose() {
    _cartWorker?.dispose();
    super.dispose();
  }



  void _refreshOrderItems() {
    print("=========== REFRESH ORDER ITEMS START ===========");
    final model = controller.getOrderDetailsResponseModel.value;
    if (model == null) {
      print("❌ Model is NULL");
      return;
    }
    if (model.result == null) {
      print("❌ model.result is NULL");
      return;
    }
    if (model.result!.isEmpty) {
      print("❌ model.result is EMPTY");
      return;
    }
    final result = model.result!.first;
    if (result.detailsItems == null) {
      print("❌ detailsItems is NULL");
      return;
    }
    if (result.detailsItems!.isEmpty) {
      print("❌ detailsItems is EMPTY");
      return;
    }
    final itemsList = result.detailsItems;
    for (int i = 0; i < itemsList!.length; i++) {
    }
    final firstItem = itemsList
        .where((e) => e.apiEndpoint?.isNotEmpty == true)
        .firstOrNull ??
        itemsList.firstOrNull;
    if (firstItem == null) {
      print("❌ firstItem is NULL");
      return;
    }
    if (firstItem.apiEndpoint == null) {
      print("❌ apiEndpoint is NULL");
      return;
    }
    if (firstItem.apiEndpoint!.isEmpty) {
      print("❌ apiEndpoint is EMPTY");
      return;
    }
    print("🚀 Calling fetchOrderItems with endpoint: ${firstItem.apiEndpoint}");
    controller.fetchOrderItems(firstItem.apiEndpoint!);
    print("=========== REFRESH ORDER ITEMS END ===========");
  }


  @override
  Widget build(BuildContext context) {
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
          "Order Details Screen",
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final cartResult = controller.getOrderDetailsResponseModel.value?.result?.firstOrNull;
        if (cartResult?.submitButton == null || cartResult!.submitButton!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _generateButtonRows(cartResult.submitButton!),
            ),
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
              final cartResult = controller.getOrderDetailsResponseModel.value?.result?.firstOrNull;
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
                  if (cartResult.detailsItems != null && cartResult.detailsItems!.isNotEmpty)
                    ...cartResult.detailsItems!.map((item) => _buildItemsSection(item)).toList(),

                  // Info Section
                  if (cartResult.info != null)
                    _buildInfoSection(cartResult.info!),
                    
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateButtonRows(List<SubmitButton> buttons) {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 10)); // Gap between rows

      if (i + 1 < buttons.length) {
        // Pair: Half - Half
        rows.add(Row(
          children: [
            Expanded(child: _buildSingleButton(buttons[i])),
            const SizedBox(width: 10),
            Expanded(child: _buildSingleButton(buttons[i+1])),
          ],
        ));
      } else {
        // Single: Full Width
        rows.add(Row(
          children: [
            Expanded(child: _buildSingleButton(buttons[i])),
          ],
        ));
      }
    }
    return rows;
  }

  Widget _buildSingleButton(SubmitButton btn) {
    return CustomButton(
      text: btn.label ?? '',
      onTap: () async {
        String? apiEndpoint = btn.apiEndpoint;
        String? nextPageName = btn.nextPageName;
        String? nextPageApiEndpoint = btn.nextPageApiEndpoint;
        String? nextPageViewType = btn.nextPageViewType;
        String? title = btn.title;
        String? description = btn.description;
        String? pageImage = btn.pageImage;
        // Convert design to Map if possible, or pass as is if it matches what BidBottomSheet expects
        // SubmitButton design is List<dynamic>?, but BidBottomSheet expects Map or SubmitButtonDesign
        // In OrderDetailsModel, Map is wrapped in a List, so we extract the first element.
        dynamic design = (btn.design != null && btn.design!.isNotEmpty) ? btn.design!.first : null; 

        bool hasApi = apiEndpoint != null && apiEndpoint.isNotEmpty;
        bool hasNextPage = nextPageName != null && nextPageName.isNotEmpty;
        bool hasNextApi = nextPageApiEndpoint != null && nextPageApiEndpoint.isNotEmpty;
        bool hasNextView = nextPageViewType != null && nextPageViewType.isNotEmpty;

        bool hasDesign = design != null && (design is Map ? design.isNotEmpty : (design is List ? design.isNotEmpty : false));
        bool hasConfirmData = (title != null && title.isNotEmpty) || (description != null && description.isNotEmpty) || hasDesign;

        // RULE 1: Direct API
        if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
          print("Rule 1 → Direct API");
          await controller.handleActionApiCall(apiEndpoint!);
          _refreshOrderItems();
          return;
        }

        // RULE 2: Navigate +API
        if (hasApi && hasNextApi && !hasConfirmData) {
          print("Rule 2 → Next API + Navigate");
          await controller.handleActionApiCallAndNavigate(
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
          // Create AppMenuItem to pass as arguments
          if(nextPageName== "help_and_support_screen"){
            AppMenuItem menuItem = AppMenuItem(
              label: btn.label,
              nextPageName: nextPageName,
              nextPageApiEndpoint: nextPageApiEndpoint,
              pageImage: pageImage,
              title: title,
              description: description,
              design: design, // Parsed map or null
              viewType: btn.viewType,
              // Map other fields if necessary
            );

            CustomNavigator.navigate(nextPageName, arguments: menuItem);
          }else{
            CustomNavigator.navigate(nextPageName);
          }
          return;
        }

          // RULE 3: Confirm Data -> Show BidBottomSheet instead of Dialog
        if (!hasNextPage && !hasNextApi && !hasNextView && hasConfirmData) {
          print("Rule 3 → DynamicBottomSheet");
          var result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DynamicBottomSheet(
                title: title, 
                description: description, 
                pageImage: pageImage, 
                design: design, 
                apiEndpoint: apiEndpoint,
                onSubmit: (endpoint, data) async {
                  bool success = await controller.submitDynamicForm(endpoint: endpoint, formData: data);
                  if (success) {
                    _refreshOrderItems();
                  }
                  return success;
                },
              ),
            ),
          );

          if (result == true) {
            if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
              // await controller.actionButtonAction(apiEndpoint);
            }
          }
          return;
        }
      },
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

  Widget _buildItemsSection(DetailsItems item) {
    return Obx(() {
      final shouldShowShimmer = !controller.hasFetchedItems.value ||
          (controller.fetchedItems.isEmpty && (controller.isFetchingItems.value));

      if (shouldShowShimmer) {
        return _buildItemsShimmer();
      }

      if (controller.fetchedItems.isEmpty) return const SizedBox.shrink();

      final listTypes = {'custom_vertical_listview_list', 'custom_horizontal_listview_list', 'custom_vertical_gridview_list', 'custom_horizontal_gridview_list'};

      if (item.viewType != null && listTypes.contains(item.viewType)) {
        return CustomViewWidget(
          type: item.viewType!,
          itemDataList: controller.fetchedItems.map((e) => e.toJson()).toList(),
          isFromCartScreen: true,
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

            bool hasDesign = design != null && design.isNotEmpty;
            bool hasConfirmData = (title != null && title.isNotEmpty) || (description != null && description.isNotEmpty) || hasDesign;

            // RULE 1: Direct API
            if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
              print("Rule 1 → Direct API");
              controller.handleActionApiCall(apiEndpoint!);
              return;
            }

            // RULE 2: Navigate +API
            if (hasApi && hasNextApi && !hasConfirmData) {
              print("Rule 2 → Next API + Navigate");
              await controller.handleActionApiCallAndNavigate(
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
              AppMenuItem menuItem = AppMenuItem.fromJson(btn);
              CustomNavigator.navigate(nextPageName, arguments: menuItem);
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
                  child: DynamicBottomSheet(
                    title: title, 
                    description: description, 
                    pageImage: pageImage, 
                    design: design, 
                    apiEndpoint: apiEndpoint,
                    onSubmit: (endpoint, data) async {
                      bool success = await controller.submitDynamicForm(endpoint: endpoint, formData: data);
                      if (success) {
                        _refreshOrderItems();
                      }
                      return success;
                    },
                  ),
                ),
              );

              if (result == true) {
                if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
                  // await controller.actionButtonAction(apiEndpoint);
                }
              }
              return;
            }
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


}