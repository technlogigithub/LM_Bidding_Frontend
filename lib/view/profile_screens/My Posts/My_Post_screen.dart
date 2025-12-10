import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controller/post/My_Post_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/app_textstyle.dart';
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
            "Post List",
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
                Obx(() => MypostListCustomWidget(
                  items: controller.currentList,
                  isLoading: controller.currentLoading.obs,
                  onItemTap: () {
                    const PostDetailsScreen().launch(context);
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
