import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/post/app_post_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../widget/post_view_widget.dart';

class RecentlyView extends StatefulWidget {
  const RecentlyView({super.key});

  @override
  State<RecentlyView> createState() => _RecentlyViewState();
}

class _RecentlyViewState extends State<RecentlyView> {
  @override
  void initState() {
    super.initState();
    // Initialize AppPostController and load data
    final appPostController = Get.put(AppPostController());
    // Defer API call until after the first frame is built to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appPostController.getPostList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppPostController appPostController = Get.find<AppPostController>();
    final AppSettingsController appController =
        Get.find<AppSettingsController>();
    final homePage = appController.homePage.value; // <-- HomePage? model
    final headerConfig = homePage?.design?.headerMenu; // <-- HeaderMenuSection?
    final appbartitle = headerConfig?.headerMenu?[1].label;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
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
            appbartitle ?? '',
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
          child: Obx(() {
            final homePage = appController.homePage.value;
            final headerConfig = homePage?.design?.headerMenu;
            final viewType = headerConfig?.headerMenu?[1].viewType ?? '';

            print("View type from headerMenu[1] is: $viewType");

            return PostViewWidget(
              type: viewType,
              controller: appPostController,
              onFavoriteToggle: (index, newValue) {
                // Update favorite in the model
                final result =
                    appPostController.getPostListResponseModel.value?.result;
                if (result != null && index < result.length) {
                  if (result[index].info != null) {
                    result[index].info!.favorite = newValue;
                    appPostController.getPostListResponseModel.refresh();
                  }
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
