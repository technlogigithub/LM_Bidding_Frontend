import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/post/app_post_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_view_widget.dart';

class RecentlyView extends StatefulWidget {
  const RecentlyView({super.key});

  @override
  State<RecentlyView> createState() => _RecentlyViewState();
}

class _RecentlyViewState extends State<RecentlyView> {
  late final AppPostController appPostController;
  late final AppSettingsController appController;
  String? _endpoint;
  String? _pageName;

  @override
  void initState() {
    super.initState();
    // Initialize AppPostController and load data
    appPostController = Get.put(AppPostController());
    appController = Get.find<AppSettingsController>();

    // Defer API call until after the first frame is built to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Get home page configuration for headerMenu[1]
    final homePage = appController.homePage.value;
    final headerConfig = homePage?.design?.headerMenu;
    final headerMenu = headerConfig?.headerMenu;

    // Get endpoint and page_name from headerMenu[1] if available
    _endpoint = null;
    _pageName = null;

    if (headerMenu != null && headerMenu.length > 1) {
      _endpoint = headerMenu[1].apiEndpoint;
      _pageName = headerMenu[1].pageName;
    }

    // Update page_name in AppPostController if available
    if (_pageName != null && _pageName!.isNotEmpty) {
      appPostController.updatePageName(_pageName!);
    }

    // Call API with dynamic endpoint
    await appPostController.getPostList(endpoint: _endpoint);
  }

  @override
  Widget build(BuildContext context) {
    final homePage = appController.homePage.value; // <-- HomePage? model
    final headerConfig = homePage?.design?.headerMenu; // <-- HeaderMenuSection?
    final appBarTitle = headerConfig?.headerMenu?[1].title;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            appBarTitle ?? '',
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data - shimmer will show automatically via isLoading
            await _loadData();
          },
          color: AppColors.appButtonColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
              child: Obx(() {
                final homePage = appController.homePage.value;
                final headerConfig = homePage?.design?.headerMenu;
                final viewType = headerConfig?.headerMenu?[1].viewType ?? '';

                print("View type from headerMenu[1] is: $viewType");

                return CustomViewWidget(
                  type: viewType,
                  controller: appPostController,
                  onFavoriteToggle: (index, newValue) {
                    // Update favorite in the model
                    final result = appPostController
                        .getPostListResponseModel
                        .value
                        ?.result;
                    if (result != null && index < result.length) {
                      if (result[index].info != null) {
                        result[index].info!['favorite'] = newValue;
                        appPostController.getPostListResponseModel.refresh();
                      }
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
