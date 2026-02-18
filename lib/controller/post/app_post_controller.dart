import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_constant.dart';
import '../../core/utils.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../app_main/App_main_controller.dart';

class AppPostController extends GetxController {
  // Loading State
  final isLoading = false.obs;

  // Response Model
  Rx<GetPostListResponseModel?> getPostListResponseModel = Rx<GetPostListResponseModel?>(null);
  Rx<GetPostListResponseModel?> getPostForHomeResponseModel = Rx<GetPostListResponseModel?>(null);

  // API Call Parameters - Store and manage all parameters here
  var userKey = ''.obs;
  var pageName = ''.obs;
  var search = ''.obs;
  var category = ''.obs;
  var status = ''.obs;
  var sortBy = ''.obs;
  var sortType = ''.obs;
  var startFrom = ''.obs;
  var currentLat = ''.obs;
  var currentLong = ''.obs;
  var perPage = ''.obs;
  var userId = ''.obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;
  var radius = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final ukey = prefs.getString('ukey') ?? '';
    userKey.value = ukey;
  }

  // Method to update search parameter
  void updateSearch(String value) {
    search.value = value;
  }

  // Method to update category parameter
  void updateCategory(String value) {
    category.value = value;
  }

  // Method to update status parameter
  void updateStatus(String value) {
    status.value = value;
  }

  // Method to update sort parameters
  void updateSort(String by, String type) {
    sortBy.value = by;
    sortType.value = type;
  }

  // Method to update location parameters
  void updateLocation(String lat, String long) {
    currentLat.value = lat;
    currentLong.value = long;
  }

  // Method to update pagination parameters
  void updatePagination(String start, String perPageValue) {
    startFrom.value = start;
    perPage.value = perPageValue;
  }

  // Method to update price range parameters
  void updatePriceRange(String min, String max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  // Method to update user ID parameter
  void updateUserId(String value) {
    userId.value = value;
  }

  // Method to update page name parameter
  void updatePageName(String value) {
    pageName.value = value;
  }

  // Method to reset all parameters to default
  void resetParameters() {
    search.value = '';
    category.value = '';
    status.value = '';
    sortBy.value = '';
    sortType.value = '';
    startFrom.value = '';
    currentLat.value = '';
    currentLong.value = '';
    perPage.value = '';
    userId.value = '';
    minPrice.value = '';
    maxPrice.value = '';
    pageName.value = '';
  }

  // Build form data map from stored values
  Map<String, String> _buildFormData() {
    final formData = <String, String>{};

    // Add all fields, even if empty (as per Postman request)
    formData['page_name'] = pageName.value;
    formData['user_key'] = userKey.value;
    formData['user_id'] = userId.value;
    formData['search'] = search.value;
    formData['category'] = category.value;
    formData['status'] = status.value;
    formData['sort_by'] = sortBy.value;
    formData['sort_type'] = sortType.value;
    formData['per_page'] = perPage.value;
    formData['start_frm'] = startFrom.value;
    formData['current_lat'] = currentLat.value;
    formData['current_long'] = currentLong.value;
    formData['radius'] = radius.value;

    // Optional fields
    if (minPrice.value.isNotEmpty) {
      formData['min_price'] = minPrice.value;
    }
    if (maxPrice.value.isNotEmpty) {
      formData['max_price'] = maxPrice.value;
    }

    return formData;
  }

  // Main API call method - uses stored parameters
  // endpoint is optional - if provided, it will be used; otherwise, it will try to get from configuration
  Future<void> getPostList({String? endpoint}) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        // Utils.showSnackbar(
        //   isSuccess: false,
        //   title: 'Error',
        //   message: 'Authentication token not found',
        // );
        return;
      }

      if (userKey.value.isEmpty) {
        await _loadUserData();
      }

      final formData = _buildFormData();

      final finalEndpoint =
      (endpoint != null && endpoint.isNotEmpty) ? endpoint : 'get-posts';

      var uri = Uri.parse('${AppConstants.baseUrl}$finalEndpoint');
      
      // For GET requests on Web, parameters MUST be in the query string
      if (formData.isNotEmpty) {
        uri = uri.replace(queryParameters: {
          ...uri.queryParameters,
          ...formData,
        });
      }

      print("API URL: $uri");

      final response = await http.get(uri, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        getPostListResponseModel.value =
            GetPostListResponseModel.fromJson(decoded);

        print("Total Posts: ${getPostListResponseModel.value?.result?.length}");
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
      resetParameters();
    }
  }
  Future<void> getPostListForHomeScreen({String? endpoint}) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        // Utils.showSnackbar(
        //   isSuccess: false,
        //   title: 'Error',
        //   message: 'Authentication token not found',
        // );
        return;
      }

      if (userKey.value.isEmpty) {
        await _loadUserData();
      }

      final formData = _buildFormData();

      final finalEndpoint =
      (endpoint != null && endpoint.isNotEmpty) ? endpoint : 'get-posts';

      var uri = Uri.parse('${AppConstants.baseUrl}$finalEndpoint');
      
      // For GET requests on Web, parameters MUST be in the query string
      if (formData.isNotEmpty) {
        uri = uri.replace(queryParameters: {
          ...uri.queryParameters,
          ...formData,
        });
      }

      print("API URL: $uri");

      final response = await http.get(uri, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        getPostForHomeResponseModel.value =
            GetPostListResponseModel.fromJson(decoded);

        print("Total Posts: ${getPostForHomeResponseModel.value?.result?.length}");
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
      resetParameters();
    }
  }


  // Method to get post list with custom parameters (optional override)
  Future<void> getPostListWithParams({
    String? endpoint,
    String? pageNameParam,
    String? searchParam,
    String? categoryParam,
    String? statusParam,
    String? sortByParam,
    String? sortTypeParam,
    String? startFromParam,
    String? currentLatParam,
    String? currentLongParam,
    String? perPageParam,
    String? userIdParam,
    String? minPriceParam,
    String? maxPriceParam,
  }) async {
    // Update parameters if provided
    if (pageNameParam != null) pageName.value = pageNameParam;
    if (searchParam != null) search.value = searchParam;
    if (categoryParam != null) category.value = categoryParam;
    if (statusParam != null) status.value = statusParam;
    if (sortByParam != null) sortBy.value = sortByParam;
    if (sortTypeParam != null) sortType.value = sortTypeParam;
    if (startFromParam != null) startFrom.value = startFromParam;
    if (currentLatParam != null) currentLat.value = currentLatParam;
    if (currentLongParam != null) currentLong.value = currentLongParam;
    if (perPageParam != null) perPage.value = perPageParam;
    if (userIdParam != null) userId.value = userIdParam;
    if (minPriceParam != null) minPrice.value = minPriceParam;
    if (maxPriceParam != null) maxPrice.value = maxPriceParam;

    // Call API with updated parameters and optional endpoint
    await getPostList(endpoint: endpoint);
  }
}
