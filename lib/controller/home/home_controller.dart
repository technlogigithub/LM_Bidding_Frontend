import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_constant.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_config.dart';
import '../../core/utils.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../../models/home/banner_response_model.dart';
import '../../models/home/category_response_model.dart';
import '../../models/static models/service_items_model.dart';
import '../../widget/form_widgets/location_picker.dart';
import '../../service/razorpay_service.dart';
import '../post/app_post_controller.dart';
import '../../models/App_moduls/AppResponseModel.dart';

class ClientHomeController extends GetxController {

  Future<void> refreshData() async {
    isCategoryFetched.value = false;
    isBannerFetched.value = false;
    isVideoBannerFetched.value = false;
    categoryList.clear();
    bannerList.clear();
    bannerVideoAndImageList.clear();
    
    // Clear all tagged AppPostControllers to force re-fetch
    if (Get.context != null) {
      final appSettingsController = Get.find<AppSettingsController>();
      final homePage = appSettingsController.homePage.value;
      final bodySections = homePage?.design?.body;
      
      if (bodySections != null) {
        for (var section in bodySections) {
           if (section.apiEndpoint != null && section.apiEndpoint!.isNotEmpty) {
             final tag = section.apiEndpoint!;
             if (Get.isRegistered<AppPostController>(tag: tag)) {
               final controller = Get.find<AppPostController>(tag: tag);
               controller.getPostForHomeResponseModel.value = null; // Clear data
             }
           }
        }
      }
    }

    await initializeData();
    // Trigger update on home screen if needed (usually Obx handles it)
  }





  static ClientHomeController get to => Get.find();

  // Reactive variables
  var isFavorite = false.obs;
  var isLoggedIn = false.obs;
  var isLoading = true.obs;
  var showShimmer = true.obs;

  var categoryList = <CategoryResult>[].obs;
  var filteredCategoryList = <CategoryResult>[].obs;
  var bannerList = <BannerResult>[].obs;
  var bannerVideoAndImageList = <BannerVidepResult>[].obs;
  var livePostList = <dynamic>[].obs;
  var notifications = <dynamic>[].obs;
  var currentLocation = ''.obs;
  var currentLatLng = const LatLng(0, 0).obs;

  // Subcategories storage: Map<parentUkey, List<CategoryResult>>
  var subcategoriesMap = <String, List<CategoryResult>>{}.obs;
  var loadingSubcategories = <String, bool>{}.obs;

  var services = <ServiceItem>[].obs;
  var recentViewedList = <ServiceItem>[].obs;
  late final AppPostController appPostController;



  var categoryLoading = false.obs;
  var bannerLoading = false.obs;
  var bannerVideoLoading = false.obs;

  // Track if initial fetch has been attempted to prevent loops on empty data
  var isCategoryFetched = false.obs;
  var isBannerFetched = false.obs;
  var isVideoBannerFetched = false.obs;

  // Razorpay service
  final RazorpayService razorpayService = RazorpayService();

  void toggleFavorite(int index, bool newValue) {
    if (isLoggedIn.value) {
      services[index].isFavorite.value = newValue;
    } else {
      Get.offAll(LoginScreen());
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize AppPostController if not already initialized
    if (!Get.isRegistered<AppPostController>()) {
      Get.put(AppPostController());
    }
    appPostController = Get.find<AppPostController>();
    razorpayService.initRazorpay();
    // initializeData();
    _loadSavedLocation();
    checkLoginStatus();
    initializeData();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('currentLocation');
    final savedLat = prefs.getDouble('currentLat');
    final savedLng = prefs.getDouble('currentLng');
    if (savedAddress != null && savedLat != null && savedLng != null) {
      currentLocation.value = savedAddress;
      currentLatLng.value = LatLng(savedLat, savedLng);
    } else {
      _getCurrentLocation(); // Fetch current location if no saved location
    }
  }

  Future<void> _saveLocation(String address, LatLng latLng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLocation', address);
    await prefs.setDouble('currentLat', latLng.latitude);
    await prefs.setDouble('currentLng', latLng.longitude);
  }

  Future<void> getCurrentLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocation.value = 'Location permission denied';
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        currentLocation.value = 'Location permission permanently denied';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLatLng.value = LatLng(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String fullAddress = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
      currentLocation.value = fullAddress.isNotEmpty
          ? fullAddress
          : 'Unable to fetch location';
      await _saveLocation(
        currentLocation.value,
        currentLatLng.value,
      ); // Save location
    } catch (e) {
      print('Error fetching location: $e');
      currentLocation.value = 'Unable to fetch location';
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: 'Failed to fetch location: $e',
      );
    }
  }

  void updateLocation(LatLng latLng, String address) {
    currentLatLng.value = latLng;
    currentLocation.value = address;
    _saveLocation(address, latLng);
  }

  void changeLocation() {
    Get.to(
      () => LocationPickerScreen(
        initialLat: currentLatLng.value.latitude,
        initialLng: currentLatLng.value.longitude,
      ),
    );
  }

  Future<void> initializeData() async {
    print("Initializing home data...");
    // isLoading.value = true;

    // fetchCategory();
    // fetchBanner();
    // fetchBannerForVideo();
    // appPostController.getPostList();

    // isLoading.value = false; // Stop loading
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> fetchCategory(String endpoint) async {
    if (categoryLoading.value || isCategoryFetched.value) return; // Prevent duplicate or repeat calls
    categoryLoading.value = true;
    isCategoryFetched.value = true; // Mark as fetched immediately to stop loop

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print("➡️ Category endpoint: $endpoint");

      final headers = token != null
          ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
          : null;

      // Changed to GET as per error message "The POST method is not supported for route api/category"
      final res = await ApiService.getRequest(endpoint, headers: headers);

      print('📥 Category API Response: $res');

      final categoryModel = CategoryModel.fromJson(res);
      categoryList.assignAll(categoryModel.result ?? []);
      filteredCategoryList.assignAll(categoryList);

      print('✅ Total Categories: ${categoryList.length}');
    } catch (e, stack) {
      print('❌ Error fetching categories: $e');
      print(stack);
    } finally {
      categoryLoading.value = false;
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategoryList.assignAll(categoryList);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredCategoryList.assignAll(
        categoryList.where((category) {
          final name = category.name?.toLowerCase() ?? '';
          final title = category.title?.toLowerCase() ?? '';
          final detail = category.categoryDetail?.toLowerCase() ?? '';
          
          return name.contains(lowercaseQuery) || 
                 title.contains(lowercaseQuery) ||
                 detail.contains(lowercaseQuery);
        }).toList(),
      );
    }
  }



  Future<void> fetchSubcategories(String parentUkey) async {
    try {
      // Check if already loaded
      if (subcategoriesMap.containsKey(parentUkey)) {
        return;
      }

      loadingSubcategories[parentUkey] = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final appcontroller = Get.find<AppSettingsController>();
      final homePage = appcontroller.homePage.value;

      final customSection =
          homePage?.design?.customSections?["custom_category_horizontal_list"]
              as CustomSection?;
      final endpoint = customSection?.apiEndpoint;
      final finalEndpoint = endpoint ?? "";

      final headers = token != null
          ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
          : null;

      // Call API with ukey in body
      final res = await ApiService.postRequest(finalEndpoint, {
        'ukey': parentUkey,
      }, headers: headers);

      final categoryModel = CategoryModel.fromJson(res);
      if (categoryModel.result != null && categoryModel.result!.isNotEmpty) {
        subcategoriesMap[parentUkey] = categoryModel.result!;
      } else {
        subcategoriesMap[parentUkey] = [];
      }

      print(
        '✅ Fetched subcategories for $parentUkey: ${categoryModel.result?.length ?? 0}',
      );
    } catch (e, stack) {
      print('❌ Error fetching subcategories: $e');
      print(stack);
      subcategoriesMap[parentUkey] = [];
    } finally {
      loadingSubcategories[parentUkey] = false;
    }
  }

  Future<void> fetchBanner(String endpoint) async {
    if (bannerLoading.value || isBannerFetched.value) return;
    bannerLoading.value = true;
    isBannerFetched.value = true; // Mark as fetched immediately

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print(" banner end point $endpoint");

      final headers = token != null
          ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
          : null;

      final res = await ApiService.getRequest(endpoint, headers: headers);

      final bannerModel = BannerModel.fromJson(res);
      bannerList.assignAll(bannerModel.result ?? []);

      print('✅ Total Banners: ${bannerList.length}');
      isBannerFetched.value = true;
    } catch (e) {
      print('❌ Error fetching banners: $e');
    } finally {
      bannerLoading.value = false;
    }
  }


  Future<void> fetchBannerForVideo(String endpoint) async {
    if (bannerVideoLoading.value || isVideoBannerFetched.value) return;
    bannerVideoLoading.value = true;
    isVideoBannerFetched.value = true; // Mark as fetched immediately

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print(" custom_banner_with_video end point $endpoint");

      final headers = token != null
          ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
          : null;

      final res = await ApiService.getRequest(endpoint, headers: headers);

      final model = BannerForVideoModel.fromJson(res);
      bannerVideoAndImageList.assignAll(model.result ?? []);

      print('✅ Total Video Banners: ${bannerVideoAndImageList.length}');
      isVideoBannerFetched.value = true;
    } catch (e) {
      print('❌ Error fetching banners: $e');
    } finally {
      bannerVideoLoading.value = false;
    }
  }


  Future<void> livePost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final headers = token != null
          ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
          : null;
      final res = await ApiService.getRequest("get-post", headers: headers);
      livePostList.assignAll(res["data"] ?? []);
      // Print live posts data
      print('Live Posts API response:');
      for (var post in livePostList) {
        print(post);
      }
    } catch (e) {
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: 'Failed to load live posts: $e',
      );
    }
  }

  void handleRestrictedFeature(VoidCallback onLoggedIn) {
    print('Checking value ${isLoggedIn.value}');
    if (isLoggedIn.value) {
      onLoggedIn();
    } else {
      Get.offAll(LoginScreen()); // Replace with actual login route
    }
  }

  // Static payment method for demo
  void initiatePayment() {
    // Static bill amount for demo
    const double staticAmount = 1000.0;

    razorpayService.openCheckout(
      amount: staticAmount,
      name: 'LM Bidding',
      description: 'Payment for services',
      prefillEmail: 'demo@libdding.com',
      prefillContact: '9999999999',
    );
  }

  @override
  void onClose() {
    razorpayService.dispose();
    super.onClose();
  }

  Rx<GetPostListResponseModel?> getPostListResponseModel =
      Rx<GetPostListResponseModel?>(null);
}


