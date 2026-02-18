import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/view/profile_screens/My%20Posts/my_post_details_screen.dart';
import '../../../controller/post/My_Post_controller.dart';
import '../../../controller/post/get_post_details_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/app_textstyle.dart';
import '../../../models/App_moduls/AppResponseModel.dart';
import '../../../widget/custom_tapbar.dart';
import '../../../widget/custom_view_widget.dart';
import '../../../widget/custom_navigator.dart';

class MyPostScreen extends StatelessWidget {
  final AppMenuItem? menuItem;
  const MyPostScreen({super.key, this.menuItem});

  @override
  Widget build(BuildContext context) {
    final AppMenuItem? effectiveMenuItem = menuItem ?? Get.arguments;
    final MyPostController controller = Get.put(MyPostController());
    // final AppSettingsController appSettingController = Get.put(
    //   AppSettingsController(),
    // );
    Get.put(GetPostDetailsController());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Extract tab labels from myPostModel design inputs select options
    // Returns null if no valid labels found, otherwise returns list of labels
    List<String>? getTabLabels(AppMenuItem? myPostModel) {
      if (myPostModel?.design == null || myPostModel?.design is! Map) {
        return null;
      }
      
      final SettingsDesign? design = SettingsDesign.fromJson(myPostModel!.design);

      if (design?.inputs != null) {
        // Try to find select input - check for key "select" or any input with inputType "select"
        SettingsInput? selectInput;

        // First try to find by key "select"
        if (design!.inputs!.containsKey('select')) {
          selectInput = design.inputs!['select'];
        } else {
          // Try to find any input with inputType "select"
          try {
            selectInput = design.inputs!.values.firstWhere(
              (input) => input.inputType == 'select',
            );
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
          if (selectInput.options != null && selectInput.options!.isNotEmpty) {
            return selectInput.options!;
          }
        }
      }
      // Return null when no valid labels found
      return null;
    }

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
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: RefreshIndicator(
            onRefresh: () async {
              // Refresh all data
              await controller.getPostList();
            },
            color: AppColors.appButtonColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.010),
                  Builder(builder: (context) {
                    final tabLabels = getTabLabels(effectiveMenuItem);

                    // Only show TabBar if labels are not null and not empty
                    if (tabLabels != null && tabLabels.isNotEmpty) {
                      return CustomTabBar(
                        // height: 50,
                        tabs: tabLabels,
                        // primaryColor: AppColors.appColor,
                        // borderColor: Colors.grey.shade300,
                        textStyle: AppTextStyle.description(),
                        initialIndex: 0,
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
                    if (!controller.isLoading.value &&
                        (controller.getPostListResponseModel.value?.result == null ||
                            controller.getPostListResponseModel.value!.result!
                                .isEmpty)) {
                      return SizedBox(
                        height: screenHeight * 0.7,
                        child: Center(
                          child: Text(
                            "No posts found", // You can use a dynamic message from model if available
                            style: AppTextStyle.description(
                                color: AppColors.appDescriptionColor),
                          ),
                        ),
                      );
                    }

                    final viewType = effectiveMenuItem?.viewType ?? '';
                    print(" View type is $viewType");
                    return CustomViewWidget(
                      type: viewType,
                      controller: controller.appPostController,
                      statusValue: controller.selectedStatusValue.value,
                      onItemTap: (String ukey) {
                        Get.to(() => const MyPostDetailsScreen());
                        // Get.find<GetPostDetailsController>().getPostDetails(ukey); Here Not Need to Call API Directly
                        // CustomNavigator.navigate("post_detail_screen",arguments: ukey,);
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
    );
  }
}
