import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/api_config.dart';
import '../../core/network.dart';
import '../../models/Order/my_order_list_model.dart';
import '../../models/Order/order_details_model.dart';
import '../../models/Cart/Cart_Item_Model.dart';
import '../../widget/custom_navigator.dart';
import '../app_main/App_main_controller.dart';
import '../home/home_controller.dart';

class MyOrdersController extends GetxController {
  // Filter Status
  var currentStatus = ''.obs; // The value of the selected status (e.g. "draft", "submitted")
  // Tab Index (for UI selection)
  var selectedTabIndex = 0.obs;
  
  RxBool isLoading = false.obs;
  RxBool isLoadingForDetails = false.obs;
  RxBool isLoadingGetFunction = false.obs;
  bool hasInitiatedFetch = false;

  // Lists
  var allOrders = <OrderItem>[].obs;
  // var activeOrders = <Items>[].obs; // Removed hardcoded lists
  // var pendingOrders = <Items>[].obs;
  // var completedOrders = <Items>[].obs;
  // var cancelledOrders = <Items>[].obs;
  
  Rx<MyOrderResponseModel?> myOrderResponseModel = Rx<MyOrderResponseModel?>(null);
  Rx<GetOrderDetailsResponseModel?> getOrderDetailsResponseModel = Rx<GetOrderDetailsResponseModel?>(null);

  var dynamicEndpoint = ''.obs;

  // Fetch items state
  final RxList<CartItem> fetchedItems = <CartItem>[].obs;
  final RxBool isFetchingItems = false.obs;
  final RxBool hasFetchedItems = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentStatus = ''.obs;
    // Initialize default status from settings if available
    // We can't easily do it here without context or delay, so we'll rely on the UI 
    // to set the initial status or default to "All" (empty string).
  }

  // Get current list based on filter
  List<OrderItem> get currentList {
    // Return allOrders directly as we are filtering from backend
    return allOrders;
  }

  // Update tab and status
  void updateTab(int index, String statusValue) {
    selectedTabIndex.value = index;
    currentStatus.value = statusValue;
    fetchMyOrderList();
  }

  Future<void> fetchMyOrderList() async {
    isLoading.value = true;
    allOrders.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
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
        print("❌ Error getting location for cart: $e");
      }

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

      // Get endpoint from settings if possible, else default
      final appSettings = Get.put(AppSettingsController());
      String endpoint = dynamicEndpoint.value.isNotEmpty
          ? dynamicEndpoint.value
          : appSettings.myOrderModel.value?.apiEndpoint ?? "";

      var response = await apiService.makeRequestFormData(
        endPoint: endpoint, 
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        myOrderResponseModel.value = MyOrderResponseModel.fromJson(response);
        
        if (myOrderResponseModel.value?.result != null && myOrderResponseModel.value!.result!.items != null) {
          allOrders.assignAll(myOrderResponseModel.value!.result!.items!);
        } else {
             allOrders.clear();
        }
      } else {
        // Handle error or empty response
      }
    } catch (e) {
      print("Error fetching m order list : $e");
      // rethrow; // Optional: handle error gracefully in UI
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchMyOrderDetails(String apiEndpoint, String nextPageName, bool isNext) async {
    isLoadingForDetails.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      String lat = '';
      String long = '';

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));

          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,

      };

      var response = await apiService.makeRequestFormData(
        endPoint: apiEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        getOrderDetailsResponseModel.value =
            GetOrderDetailsResponseModel.fromJson(response);

        // ✅ SUCCESS + NAVIGATION CONDITION
        if (isNext &&
            getOrderDetailsResponseModel.value?.success == true) {
          CustomNavigator.navigate(nextPageName);
        }
      }
    } catch (e) {
      print("Error fetching order list: $e");
    } finally {
      isLoadingForDetails.value = false;
    }
  }
  RxString invoiceHtml = ''.obs;

  Future<void> OrderDetailsAction(String apiEndpoint) async {
    isLoadingForDetails.value = true;
    invoiceHtml.value = ''; // Reset before new call

    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      String lat = '';
      String long = '';

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));

          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
      };

      var response = await apiService.makeRequestFormData(
        endPoint: apiEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        if (response['success'] == true && response['response_code'] == 200) {
          if (response['result'] != null &&
              response['result']['invoice_html'] != null) {
            String htmlContent = response['result']['invoice_html'];
            invoiceHtml.value = htmlContent; // Keep it in observable if needed elsewhere or just for safety
            CustomNavigator.navigate("invoice_screen", arguments: htmlContent);
          }
          print("✅ Invoice fetched successfully");
        } else {
          print("❌ API Failed: ${response['message']}");
          toast(response['message'] ?? "Failed to fetch invoice");
        }
      }
    } catch (e) {
      print("Error fetching order details action: $e");
    } finally {
      isLoadingForDetails.value = false;
    }
  }
  Future<void> handleActionApiCall(String endpoint) async {
    debugPrint("🚀 Handling Action API Call: $endpoint");

    String userKey = "";
    if (endpoint.isNotEmpty) {
      final segments = endpoint.split('/');
      if (segments.isNotEmpty) userKey = segments.last;
    }

    // Get Location from ClientHomeController
    String lat = "";
    String long = "";
    try {
      if (Get.isRegistered<ClientHomeController>()) {
        final homeCtrl = Get.find<ClientHomeController>();
        if (homeCtrl.currentLatLng.value.latitude != 0) {
          lat = homeCtrl.currentLatLng.value.latitude.toString();
          long = homeCtrl.currentLatLng.value.longitude.toString();
        }
      }
    } catch (e) {
      debugPrint("⚠️ Could not get location from ClientHomeController: $e");
    }

    debugPrint("🔑 user_key: $userKey");

    final body = {
      "user_key": userKey,
      "gps_lat": lat,
      "gps_long": long,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response =
      await ApiService.postRequest(endpoint, body, headers: headers);

      if (response != null && response['success'] == true) {
        debugPrint("✅ Action API successful");

        // Reset flag to allow cart refetch
        // hasFetchedItems.value = false;
        final prefs = await SharedPreferences.getInstance();


        final apiEndpoint = prefs.getString('cart_details_endpoint');
        print("cart refresh end points :$apiEndpoint");
        // if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
        //   await controller.fetchCartDetails(cartEndpoint: apiEndpoint);
        // } else {
        //   debugPrint("⚠️ Cart refresh endpoint not found");
        // }
      } else {
        debugPrint("❌ Action API failed: $response");
        toast(response?['message'] ?? "Action failed");
      }
    } catch (e) {
      debugPrint("❌ Action API Error: $e");
    }
  }
  Future<void>  handleActionApiCallAndNavigate({
    required String participateEndpoint,
    required String cartEndpoint,
    required String nextPageName,
    bool shouldFetchCart = true,
  }) async {
    isLoadingGetFunction.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
      String lat = '';
      String long = '';
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for participate: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
      };

      // 1. Call Participate API (POST)
      print("🚀 Calling  API: $participateEndpoint");
      await apiService.makeRequestRaw(
        endPoint: participateEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      // 2. Call Cart API or Navigate
      // if (shouldFetchCart) {
      //   print("🚀 Calling Cart API: $cartEndpoint and Navigating to $nextPageName");
      //   await fetchCartDetails(cartEndpoint: cartEndpoint, nextPageName: nextPageName);
      // } else {
      //   print("🚀 Navigating to: $nextPageName (Skipping Cart Fetch)");
      //   CustomNavigator.navigate(nextPageName);
      // }
    } catch (e) {
      print("Error in participateAndNavigate: $e");
    } finally {
      isLoadingGetFunction.value = false;
    }
  }
  Future<bool> submitDynamicForm({
    required String endpoint,
    required Map<String, dynamic> formData,
  }) async {
    isLoadingForDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
      String lat = '';
      String long = '';
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    print("🚀 Submitting dynamic form to: $endpoint");
    print("📦 Body: $formData");
      //)
      // Construct body
      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
        ...formData,
      };

      print("🚀 Submitting dynamic form to: $endpoint");
      print("📦 Body: $body");

      var response = await apiService.makeRequestRaw(
        endPoint: endpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        bool isSuccess = false;
        if (response is Map) {
          if (response['success'] == true ||
              response['status'] == true ||
              response['response_code'] == 200) {
            isSuccess = true;
          }
        }

        if (isSuccess) {
          // Get.find<SocketService>().sendMessage({
          //   'event': 'dynamic_form_submit',
          //   'data': formData,
          // });
           print("Response Message ${response['message']}");
          toast(response['message'] ?? "Action completed successfully");
          return true;
        } else {
             toast(response['message'] ?? "Something went wrong");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error submitting form: $e");
       toast("Failed to submit form");
      return false;
    } finally {
      isLoadingForDetails.value = false;
    }
  }


  Future<void> fetchOrderItems(String endpoint) async {
    fetchedItems.clear();
    //
    // if (hasFetchedItems.value) return;
    // if (isFetchingItems.value || hasFetchedItems.value) return;

    debugPrint("🚀 Triggering fetchOrderItems for endpoint: $endpoint");

    try {
      isFetchingItems.value = true;


      // Extract user_key from endpoint if possible
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');

      // Get Location
      String lat = "";
      String long = "";
      try {
        if (Get.isRegistered<ClientHomeController>()) {
          final homeCtrl = Get.find<ClientHomeController>();
          if (homeCtrl.currentLatLng.value.latitude != 0) {
            lat = homeCtrl.currentLatLng.value.latitude.toString();
            long = homeCtrl.currentLatLng.value.longitude.toString();
          }
        }
      } catch (e) {
        debugPrint("⚠️ Could not get location: $e");
      }

      final body = {"user_key": ukey, "gps_lat": lat, "gps_long": long};
      String? token = prefs.getString('auth_token');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };

      final response = await ApiService.postRequest(endpoint, body, headers: headers);

      if (response != null && response['success'] == true && response['result'] != null) {
        final cartItemResponse = CartItemResponseModel.fromJson(response);
        if (cartItemResponse.result?.items != null) {
          fetchedItems.assignAll(cartItemResponse.result!.items!);
          print(" Order items is >> ${fetchedItems.length}");
        }
      }
      hasFetchedItems.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching items: $e");
    } finally {
      isFetchingItems.value = false;
    }
  }
}