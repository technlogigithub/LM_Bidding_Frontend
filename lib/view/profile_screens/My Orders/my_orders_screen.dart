import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/cart/cart_controller.dart';
import 'package:libdding/widget/custom_tapbar.dart';
import 'package:libdding/widget/participation_list_custom_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../controller/app_main/App_main_controller.dart';
import '../../../controller/my_orders/my_orders_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/app_constant.dart' as AppStrings;
import '../../../core/app_textstyle.dart';
import 'order_details_screen.dart';
import '../../../models/Order/my_order_list_model.dart';

import '../../../models/App_moduls/AppResponseModel.dart';

class MyOrdersScreen extends StatelessWidget {
  final AppMenuItem? menuItem;
  const MyOrdersScreen({super.key, this.menuItem});

  @override
  Widget build(BuildContext context) {
    final AppMenuItem? effectiveMenuItem = menuItem ?? Get.arguments;
    final MyOrdersController controller = Get.put(MyOrdersController());
    // final AppSettingsController appSettingController = Get.put(
    //   AppSettingsController(),
    // );

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          title: Text(
              effectiveMenuItem?.label ?? "",
              style: AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.010),
                Builder(builder: (context) {
                  // Use effectiveMenuItem instead of appSettingController.myOrderModel
                  final SettingsDesign? design = (effectiveMenuItem?.design != null && effectiveMenuItem!.design is Map)
                      ? SettingsDesign.fromJson(effectiveMenuItem!.design)
                      : (effectiveMenuItem?.design is SettingsDesign ? effectiveMenuItem!.design : null);
                  
                  final inputs = design?.inputs;
                  // Use 'select' based on user prompt structure
                  final selectArgs = inputs != null ? inputs['select'] : null; 
                  
                  List<String> tabs = [];
                  List<String> values = [];

                  if (selectArgs?.optionItems != null) {
                    for (var opt in selectArgs!.optionItems!) {
                      if (opt.label != null) {
                         tabs.add(opt.label!);
                         values.add(opt.value?.toString() ?? '');
                      }
                    }
                  } else if (selectArgs?.options != null) {
                      tabs.addAll(selectArgs!.options!);
                      values.addAll(selectArgs!.options!);
                  }

                  // Fallback if no tabs found
                  if (tabs.isEmpty) {
                    tabs.add('All');
                    values.add('All'); 
                  }

                  // Auto-select first tab logic
                  if (values.isNotEmpty && !controller.hasInitiatedFetch) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!controller.hasInitiatedFetch) {
                        controller.hasInitiatedFetch = true;
                        controller.updateTab(0, values[0]);
                      }
                    });
                  }

                  return CustomTabBar(
                    initialIndex: 0,
                    tabs: tabs,
                    textStyle: AppTextStyle.description(),
                    onTap: (index) {
                      if (index < values.length) {
                         controller.updateTab(index, values[index]);
                      }
                    },
                  );
                }),
                SizedBox(height: screenHeight * 0.010),
                Obx(() {
                  if (!controller.isLoading.value && controller.currentList.isEmpty) {
                    return SizedBox(
                      height: screenHeight * 0.7,
                      child: Center(
                        child: Text(
                          controller.myOrderResponseModel.value?.message ?? "No orders found",
                          style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                        ),
                      ),
                    );
                  }
                  
                  return ParticipationListCustomWidget(
                  items: controller.currentList.map((e) {
                      final detailsMap = e.details?.toJson() ?? {};
                      // Remove keys that are null
                      detailsMap.removeWhere((key, value) => value == null);

                      return ParticipationCardUiModel(
                        orderId: e.hidden?.orderId?.toString() ?? e.hidden?.orderKey?.toString() ?? '',
                        date: e.details?.orderDate,
                        title: e.info?.title,
                        countdownDt: e.info?.countdownDt,
                        media: e.media,
                        dynamicDetails: detailsMap,
                        actionButtons: e.actionButton,
                        nextPageName: e.hidden?.nextPageName,
                        nextPageApiEndpoint: e.hidden?.nextPageApiEndpoint,
                      );
                  }).toList(),
                  isLoading: controller.isLoading,
                  onItemTap: (item) {
                     if (item.nextPageName != null && item.nextPageApiEndpoint != null) {
                        controller.fetchMyOrderDetails(
                          item.nextPageApiEndpoint!, 
                          item.nextPageName!, 
                          true
                        );
                     }
                  },
                );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}