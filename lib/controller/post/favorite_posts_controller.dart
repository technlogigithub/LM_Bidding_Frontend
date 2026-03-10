import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/api_config.dart';
import '../../core/network.dart';
import '../../models/Post/Get_favorite_post_list_model.dart';
import '../app_main/App_main_controller.dart';

class FavoritePostsController extends GetxController {
  // Filter Status (POSTS, CATEGORIES, USERS)
  var currentStatus = 'POSTS'.obs; 
  var selectedTabIndex = 0.obs;
  
  RxBool isLoading = false.obs;
  bool hasInitiatedFetch = false;

  // Favorites List
  var allFavorites = <Result>[].obs;
  
  Rx<FavoriteResponseModel?> favoriteResponseModel = Rx<FavoriteResponseModel?>(null);

  var dynamicEndpoint = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Update tab and status
  void updateTab(int index, String statusValue) {
    selectedTabIndex.value = index;
    currentStatus.value = statusValue;
    fetchFavoriteList();
  }

  Future<void> fetchFavoriteList() async {
    isLoading.value = true;
    allFavorites.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // 1. Get Location
      String lat = '';
      String long = '';
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        debugPrint("❌ Error getting location: $e");
      }

      // 2. Identify Endpoint
      String endpoint = dynamicEndpoint.value;
      debugPrint("🔍 Controller fetchFavoriteList started with endpoint: '$endpoint'");

      if (endpoint.isEmpty) {
        debugPrint("Favorite endpoint is empty..... inside controller");
        return;
      }

      // 3. Setup Request
      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
        'status': currentStatus.value,
      };

      // 4. Make Request
      var response = await apiService.makeRequestFormData(
        endPoint: endpoint, 
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        favoriteResponseModel.value = FavoriteResponseModel.fromJson(response);
        
        if (favoriteResponseModel.value?.result != null) {
          allFavorites.assignAll(favoriteResponseModel.value!.result!);
        } else {
          allFavorites.clear();
        }
      }
    } catch (e) {
      debugPrint("Error fetching favorite list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status locally and on server
  Future<void> toggleFavorite(int index, bool newValue) async {
    if (index < 0 || index >= allFavorites.length) return;
    
    // Locally update
    allFavorites[index].info?['favorite'] = newValue;
    allFavorites.refresh();

    // API call can be added here if there's a specific endpoint for toggling from this screen
  }
}
