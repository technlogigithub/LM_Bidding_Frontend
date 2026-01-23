import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/seach/search_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../widget/custom_navigator.dart';
import '../../widget/custom_tapbar.dart';
import '../../widget/custom_view_widget.dart';
import '../../controller/post/get_post_details_controller.dart';

class SearchFilterScreen extends StatefulWidget {
  final dynamic initialFilter; // Can be String or other types depending on passed arguments
  const SearchFilterScreen({super.key, this.initialFilter});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late final SearchAndFilterController controller;
  late final AppSettingsController appSettingcontroller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchAndFilterController());
    appSettingcontroller = Get.put(AppSettingsController());
    Get.put(GetPostDetailsController());
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Extract tab labels from search_page-design-custom_tapbar-design-inputs-select-options
    // Returns null if no valid labels found, otherwise returns list of labels
    List<String>? getTabLabelsFromSearchPage(SearchPage? searchPage) {
      if (searchPage?.design?.customTapbar?.design != null) {
        final designValue = searchPage!.design!.customTapbar!.design;

        // Check if design is a Map and contains inputs
        if (designValue is Map<String, dynamic>) {
          final inputs = designValue['inputs'];

          if (inputs != null && inputs is Map<String, dynamic>) {
            // Try to find select input - check for key "select" or any input with inputType "select"
            SettingsInput? selectInput;

            // First try to find by key "select"
            if (inputs.containsKey('select')) {
              final selectData = inputs['select'];
              if (selectData is Map<String, dynamic>) {
                selectInput = SettingsInput.fromJson(selectData);
              }
            } else {
              // Try to find any input with inputType "select"
              try {
                final selectEntry = inputs.entries.firstWhere((entry) {
                  if (entry.value is Map<String, dynamic>) {
                    final inputData = entry.value as Map<String, dynamic>;
                    return inputData['input_type'] == 'select';
                  }
                  return false;
                });
                if (selectEntry.value is Map<String, dynamic>) {
                  selectInput = SettingsInput.fromJson(
                    selectEntry.value as Map<String, dynamic>,
                  );
                }
              } catch (e) {
                // No select input found
                selectInput = null;
              }
            }

            if (selectInput != null) {
              // Get labels from optionItems
              if (selectInput.optionItems != null &&
                  selectInput.optionItems!.isNotEmpty) {
                final labels = selectInput.optionItems!
                    .map((e) => e.label ?? '')
                    .where((label) => label.isNotEmpty)
                    .toList();
                // Return labels only if not empty
                if (labels.isNotEmpty) {
                  return labels;
                }
              }
              // Fallback to simple options list
              if (selectInput.options != null &&
                  selectInput.options!.isNotEmpty) {
                return selectInput.options!;
              }
            }
          }
        }
      }
      // Return null when no valid labels found
      return null;
    }

    var searchpage = appSettingcontroller.searchPage.value;
    var appbarTitle = searchpage?.title ?? '';
    var viewtype = searchpage?.viewType ?? '';
    var pagedesign = searchpage?.design?.headerMenu;
    var filterIcon = (pagedesign != null && pagedesign.isNotEmpty)
        ? pagedesign[0].icon
        : '';
    print(" icon path :$filterIcon");
    print(" view type :$viewtype");

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appbarColor),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          title: Obx(() {
            return Text(
              appbarTitle,
              style: AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          actions: [
            if (filterIcon!.isNotEmpty)
              Container(
                height: 30.h,
                width: 30.w,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(filterIcon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: RefreshIndicator(
            onRefresh: () async {
              // Refresh data - shimmer will show automatically via isLoading
              await controller.getPostList();
            },
            color: AppColors.appButtonColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.010),
                    Obx(() {
                      // Get searchPage reactively
                      final searchPage = appSettingcontroller.searchPage.value;
                      // Get tab labels from search_page-design-custom_tapbar-design-inputs-select-options
                      final tabLabels = getTabLabelsFromSearchPage(searchPage);

                      // Determine initial index based on widget.initialFilter OR Get.arguments
                      // Priority: widget argument > Get.arguments
                      dynamic filterValue = widget.initialFilter ?? Get.arguments;
                      
                      int initialIndex = 0;
                      if (tabLabels != null &&
                          tabLabels.isNotEmpty &&
                          filterValue != null &&
                          filterValue is String) {
                        final foundIndex = tabLabels.indexOf(filterValue);
                        if (foundIndex != -1) {
                          initialIndex = foundIndex;
                          // Update controller if needed
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                              // Ensure we only update if it's different to avoid loops or unnecessary calls
                              if(controller.selectedTabIndex.value != initialIndex){
                                  controller.updateTab(initialIndex);
                              }
                           });
                        } else {
                           // If not found in labels directly, try asking controller to find by value/label match internally
                           // This is more robust as tabLabels here are just strings, but controller has full objects
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                               controller.updateTabByValue(filterValue);
                           });
                        }
                      }

                      // Only show TabBar if labels are not null and not empty
                      if (tabLabels != null && tabLabels.isNotEmpty) {
                        print(" initialIndex $initialIndex");
                        return CustomTabBar(
                          // height: 50,
                          tabs: tabLabels,
                          // primaryColor: AppColors.appColor,
                          // borderColor: Colors.grey.shade300,
                          textStyle: AppTextStyle.description(),
                          initialIndex: initialIndex,
                          onTap: (index) {
                            controller.updateTab(index);
                          },
                        );
                      }
                      // Return empty SizedBox when no labels available
                      return const SizedBox.shrink();
                    }),
                    SizedBox(height: screenHeight * 0.010),
                    Obx(() {
                      // var myPostModel = appSettingcontroller.myPostModel.value;
                      // final viewType = myPostModel?.viewtype ?? '';
                      // print(" View type is $viewType");
                      return CustomViewWidget(
                        type: viewtype,
                        controller: controller.appPostController,
                        statusValue: controller.selectedStatusValue.value,
                        onItemTap: (String ukey) {
                          print(" Tapped item with ukey: $ukey");
                          // Get.find<GetPostDetailsController>().getPostDetails(ukey);
                          CustomNavigator.navigate("post_detail_screen",arguments: ukey);
                        },
                        // Optional callbacks for other view types
                        onFavoriteToggle: (index, isFavorite) {
                          // Handle favorite toggle if needed
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
