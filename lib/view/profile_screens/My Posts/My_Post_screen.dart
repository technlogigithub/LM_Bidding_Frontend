import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controller/post/My_Post_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/app_textstyle.dart';
import '../../../models/App_moduls/AppResponseModel.dart';
import '../../../widget/MyPosts_list_custom.dart';
import '../../../widget/custom_tapbar.dart';
import '../../../widget/participation_list_custom_widget.dart';
import '../../Participate_screens/participate_details_screen.dart';
import 'Post_Details_screen.dart';

class MyPostScreen extends StatelessWidget {
  const MyPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyPostController controller = Get.put(MyPostController());
    final AppSettingsController appSettingcontroller = Get.put(
      AppSettingsController(),
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Extract tab labels from myPostModel design inputs select options
    // Returns null if no valid labels found, otherwise returns list of labels
    List<String>? getTabLabels(MyPostModel? myPostModel) {
      if (myPostModel?.design?.inputs != null) {
        // Try to find select input - check for key "select" or any input with inputType "select"
        SettingsInput? selectInput;

        // First try to find by key "select"
        if (myPostModel!.design!.inputs!.containsKey('select')) {
          selectInput = myPostModel.design!.inputs!['select'];
        } else {
          // Try to find any input with inputType "select"
          try {
            selectInput = myPostModel.design!.inputs!.values.firstWhere(
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
          title: Obx(() {
            var myPostModel = appSettingcontroller.myPostModel.value;
            return Text(
              myPostModel?.label ?? "",
              style: AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ),
        // appBar: AppBar(
        //   title: Text(
        //     "Participate",
        //     style: AppTextStyle.kTextStyle.copyWith(
        //       color: AppColors.appTextColor,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: AppColors.appWhite,
        // ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.010),
                Obx(() {
                  var myPostModel = appSettingcontroller.myPostModel.value;
                  final tabLabels = getTabLabels(myPostModel);

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
                Obx(
                  () => MypostListCustomWidget(
                    model: controller.getPostListResponseModel,
                    statusValue: controller.selectedStatusValue.value,
                    isLoading: controller.isLoading,
                    onItemTap: () {
                      const PostDetailsScreen().launch(context);
                    },
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
