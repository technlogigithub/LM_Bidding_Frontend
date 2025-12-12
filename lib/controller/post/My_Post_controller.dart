import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_constant.dart';
import '../../core/utils.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../../models/static models/participation_order.dart';
import '../app_main/App_main_controller.dart';

class MyPostController extends GetxController {
  // Tab Index
  var selectedTabIndex = 0.obs;

  // Loading State
  final isLoading = false.obs;
  Rx<GetPostListResponseModel?> getPostListResponseModel =
      Rx<GetPostListResponseModel?>(null);
  // tab ke status value store karega
  var selectedStatusValue = ''.obs;

  // Lists
  var activeOrders = <ParticipationOrder>[].obs;
  var pendingOrders = <ParticipationOrder>[].obs;
  var completedOrders = <ParticipationOrder>[].obs;
  var cancelledOrders = <ParticipationOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    extractStatusValue(); // ⬅️ add this
    getPostList(); // ⬅️ now api will use this value
  }

  void extractStatusValue() {
    final app = Get.find<AppSettingsController>();
    final model = app.myPostModel.value;

    if (model?.design?.inputs == null) return;

    SettingsInput? selectInput;

    // find select input
    if (model!.design!.inputs!.containsKey('select')) {
      selectInput = model.design!.inputs!['select'];
    } else {
      try {
        selectInput = model.design!.inputs!.values.firstWhere(
          (e) => e.inputType == "select",
        );
      } catch (e) {
        return;
      }
    }

    // optionItems → label + value case
    if (selectInput?.optionItems != null &&
        selectInput!.optionItems!.isNotEmpty) {
      selectedStatusValue.value = selectInput.optionItems!.first.value ?? "";
      return;
    }

    // simple options array
    if (selectInput?.options != null && selectInput!.options!.isNotEmpty) {
      selectedStatusValue.value = selectInput.options!.first;
    }
  }

  // Get current list based on tab
  List<ParticipationOrder> get currentList {
    switch (selectedTabIndex.value) {
      case 0:
        return activeOrders;
      case 1:
        return pendingOrders;
      case 2:
        return completedOrders;
      case 3:
        return cancelledOrders;
      default:
        return activeOrders;
    }
  }

  // Get current loading state
  bool get currentLoading {
    return isLoading.value;
  }

  // Update tab and fetch posts for selected status
  void updateTab(int index) {
    selectedTabIndex.value = index;

    // Extract status value for the selected tab
    final app = Get.find<AppSettingsController>();
    final model = app.myPostModel.value;

    if (model?.design?.inputs == null) return;

    SettingsInput? selectInput;

    // Find select input
    if (model!.design!.inputs!.containsKey('select')) {
      selectInput = model.design!.inputs!['select'];
    } else {
      try {
        selectInput = model.design!.inputs!.values.firstWhere(
          (e) => e.inputType == "select",
        );
      } catch (e) {
        return;
      }
    }

    // Get status value for selected tab index
    String? statusValue;

    // optionItems → label + value case
    if (selectInput?.optionItems != null &&
        selectInput!.optionItems!.isNotEmpty) {
      if (index < selectInput.optionItems!.length) {
        statusValue = selectInput.optionItems![index].value;
      }
    } else if (selectInput?.options != null &&
        selectInput!.options!.isNotEmpty) {
      // simple options array
      if (index < selectInput.options!.length) {
        statusValue = selectInput.options![index];
      }
    }

    // Update selectedStatusValue and call API
    if (statusValue != null && statusValue.isNotEmpty) {
      selectedStatusValue.value = statusValue;
      getPostList(); // Call API with new status value
    }
  }

  Future<void> getPostList() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: 'Authentication token not found',
        );
        return;
      }
      print("Status is : ${selectedStatusValue.value}");

      final userKey = prefs.getString('ukey') ?? 'null';

      final uri = Uri.parse(
        '${AppConstants.baseUrl}get-posts?user_key=$userKey&search=&category=&status=${selectedStatusValue.value}&sort_by=&sort_type&per_page&status&user_id&min_price&max_price',
      );

      // replace(
      //   queryParameters: {
      //     // "user_key": userKey ?? "null",
      //     "search": "",
      //     "category": "",
      //     "status": selectedStatusValue.value,
      //     "sort_by": "null",
      //     "sort_type": "null",
      //     "per_page": "null",
      //     "user_id": "null",
      //     "min_price": "null",
      //     "max_price": "null",
      //   },
      // );

      final response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final model = GetPostListResponseModel.fromJson(decoded);
        getPostListResponseModel.value = model;

        print("Total Posts: ${model.result?.length}");
        print("Has More: ${model.hasMore}");
        print("Next Start: ${model.nextStart}");
      } else {
        Utils.showSnackbar(
          isSuccess: false,
          title: "Error",
          message: decoded['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: 'Failed to load posts: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
