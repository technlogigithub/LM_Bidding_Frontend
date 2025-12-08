import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/view/Participate_screens/participate_details_screen.dart';
import 'package:libdding/widget/custom_tapbar.dart';
import 'package:libdding/widget/participation_list_custom_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/participation/participate_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';

class ParticipateScreen extends StatelessWidget {
  const ParticipateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParticipateController controller = Get.put(ParticipateController());

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
          title: Obx(() => Text(
            "Participate",
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          )),
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
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.010),
                CustomTabBar(
                  // height: 50,
                  tabs: const ['Active', 'Pending', 'Completed', 'Cancelled'],
                  // primaryColor: AppColors.appColor,
                  // borderColor: Colors.grey.shade300,
                    textStyle: AppTextStyle.description(),
                  onTap: (index) {
                    controller.updateTab(index);
                  },
                ),
                SizedBox(height: screenHeight * 0.010),
                Obx(() => ParticipationListCustomWidget(
                  items: controller.currentList,
                  isLoading: controller.currentLoading.obs,
                  onItemTap: () {
                    const ParticipateDetailsScreen().launch(context);
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}