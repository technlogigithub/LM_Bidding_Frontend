import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/Post/Get_Post_List_Model.dart';
import '../../view/search_filter_post/search_filter_screen.dart';
import '../app_main/App_main_controller.dart';
import '../post/app_post_controller.dart';

class SearchForPostsController  extends GetxController  {

  final isLoading = false.obs;
  Rx<GetPostListResponseModel?> getPostListResponseModel =
  Rx<GetPostListResponseModel?>(null);

  TextEditingController searchController = TextEditingController();



  void onSearchTap() {
    final query = searchController.text.trim();

    final appController = Get.find<AppSettingsController>();
    final homePage = appController.homePage.value;
    final searchBarConfig = homePage?.design?.searchBar;

    final pageName = searchBarConfig?.pageName;

    final appPostController = Get.find<AppPostController>();

    // ✅ page_name store karo
    if (pageName != null && pageName.isNotEmpty) {
      appPostController.updatePageName(pageName);
    }

    // ✅ search text store karo (API call nahi)
    appPostController.updateSearch(query);

    // ✅ sirf navigation
    // Get.to(() => SearchFilterScreen());
  }

// void onSearchTap() {
  //   final query = searchController.text.trim();
  //
  //   // if (query.isEmpty) return;
  //
  //   // Get home page configuration for search_bar
  //   final appController = Get.find<AppSettingsController>();
  //   final homePage = appController.homePage.value;
  //   final searchBarConfig = homePage?.design?.searchBar;
  //
  //   // Get endpoint and page_name from search_bar configuration
  //   final endpoint = searchBarConfig?.apiEndpoint;
  //   final pageName = searchBarConfig?.pageName;
  //
  //   // AppPostController ko call karo
  //   final appPostController = Get.find<AppPostController>();
  //
  //   // Update page_name in AppPostController if available
  //   if (pageName != null && pageName.isNotEmpty) {
  //     appPostController.updatePageName(pageName);
  //   }
  //
  //   appPostController.getPostListWithParams(
  //     endpoint: endpoint,
  //     searchParam: query,
  //   );
  //
  //   Get.to(SeachFilterScreen());
  // }


}