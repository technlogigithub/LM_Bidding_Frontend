import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network.dart';
import '../../core/utils.dart';
import '../../models/Cart/Cart_Model.dart';
import '../../models/Cart/Cart_preview_Model.dart';
import '../../models/Post/Get_coupons_model.dart';
import '../../models/Post/OnlinePayment_GetDetails_Model.dart';
import '../../view/post_details_service/coupon_custom_bottom_sheet.dart';
import '../../view/profile_screens/My Orders/my_orders_screen.dart';
import '../../widget/custom_navigator.dart';

import '../../service/razorpay_service.dart';

class CartController extends GetxController {
  final RazorpayService _razorpayService = RazorpayService();
  String? _currentPaymentApiEndpoint;

  @override
  void onInit() {
    super.onInit();
    _razorpayService.initRazorpay(
      onSuccess: (response) {
        print("🔔 onSuccess triggered in CartController");
        if (_currentPaymentApiEndpoint != null && response.paymentId != null) {
          final pgResponseMap = {
            "paymentId": response.paymentId,
            "orderId": response.orderId,
            "signature": response.signature
          };
          
          final jsonString = jsonEncode(pgResponseMap);
          print("🧩 Constructed PG Response JSON: $jsonString");
          
          storePaymentResponse(
            apiEndpoint: _currentPaymentApiEndpoint!,
            payment_id: response.paymentId!,
            order_id: response.orderId ?? "",
            pg_response: jsonString,
          );
        }
      },
      onFailure: (response) {
        // Handle failure if needed, e.g. store failure via API
      },
    );
  }

  @override
  void onClose() {
    _razorpayService.dispose();
    super.onClose();
  }

  RxBool isLoading = false.obs;
  RxBool isWalletUse = true.obs;
  RxBool isLoadingfordynamicForm = false.obs;
  RxBool isLoadingGetFunction = false.obs;
  RxBool isApplyingCoupon = false.obs;
  RxString appliedCouponCode = ''.obs; // To trigger UI updates
  RxBool isCouponApplied = false.obs; // To show checkmark
  RxString cartTitle = ''.obs; // To trigger UI updates
  final TextEditingController couponController = TextEditingController();
  Rx<CartResponseModel?> cartResponseModel = Rx<CartResponseModel?>(null);
  Rx<CouponsGetResponseModel?> couponsResponseModel = Rx<CouponsGetResponseModel?>(null);
  Rx<OnlinePaymentGetDetailsResponseModel?> onlinePaymentGetDetailsResponseModel = Rx<OnlinePaymentGetDetailsResponseModel?>(null);
  final cartPreviewResponse = Rx<CartPreviewResponseModel?>(null);







  Future<void> storetitle() async {
    final prefs = await SharedPreferences.getInstance();
    cartTitle.value = prefs.getString('cart_details_title') ?? '';
  }


  Future<void> fetchCartDetails({required String cartEndpoint, String? nextPageName}) async {
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
        'wallet_use' : isWalletUse.value,
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
      };

      print("➡️ Fetching Cart Details from: $cartEndpoint");
      var response = await apiService.makeRequestFormData(
        endPoint: cartEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        cartResponseModel.value = CartResponseModel.fromJson(response);
        print("📦 Cart Response Stored: ${cartResponseModel.value?.message}");
        
        // Check if result is empty (Cart is empty)
        if (cartResponseModel.value?.result == null || cartResponseModel.value!.result!.isEmpty) {
          Get.back();
        } else if (nextPageName != null && nextPageName.isNotEmpty) {
          await storetitle();
          CustomNavigator.navigate(nextPageName);
        }
      } else {
        Get.back();
      }
    } catch (e) {
      print("Error fetching cart details: $e");
      rethrow;
    } finally {
      isLoadingGetFunction.value = false;
    }
  }

  Future<void> participateAndNavigate({
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
      print("🚀 Calling Participate API: $participateEndpoint");
      await apiService.makeRequestRaw(
        endPoint: participateEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      // 2. Call Cart API or Navigate
      if (shouldFetchCart) {
        print("🚀 Calling Cart API: $cartEndpoint and Navigating to $nextPageName");
        await fetchCartDetails(cartEndpoint: cartEndpoint, nextPageName: nextPageName);
      } else {
        print("🚀 Navigating to: $nextPageName (Skipping Cart Fetch)");
        CustomNavigator.navigate(nextPageName);
      }
    } catch (e) {
      print("Error in participateAndNavigate: $e");
    } finally {
      isLoadingGetFunction.value = false;
    }
  }

  Future<bool> executeApiAction(String endpoint) async {
    isLoading.value = true;

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
              desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for apply coupon: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Construct body as per Postman request
      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
      };

      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'Post',
        body: body,
        headers: headers,
      );

      print("Response: $response");

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
          // Get.snackbar("Success", response['message'] ?? "Action completed successfully");
          return true;
        } else {
          Utils.showSnackbar(
              isSuccess: false,
              title: "Error",
              message: response['message'] ?? "Something went wrong");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error performing action: $e");
      Get.snackbar("Error", "Failed to perform action");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitCart({
    required String apiEndpoint,
    required Map<String, dynamic> body,
    String? nextPageName,
    String? nextPageApiEndpoint,
  }) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final cleanEndpoint = apiEndpoint.startsWith('/') ? apiEndpoint.substring(1) : apiEndpoint;

      print("🚀 Submitting Cart to: $cleanEndpoint");
      print("📦 Body: $body");

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        if (response['success'] == true) {
           print("✅ Cart Submitted Successfully");
           
           print("👉 nextPageApiEndpoint: $nextPageApiEndpoint");
           
           if(nextPageApiEndpoint != null && nextPageApiEndpoint.isNotEmpty){
             await fetchCartPreview(apiEndpoint: nextPageApiEndpoint, nextPageName: nextPageName.toString());
           } else if (nextPageName != null && nextPageName.isNotEmpty) {
             print("🔄 Navigating to: $nextPageName");
             // CustomNavigator.navigate(nextPageName);
           }

        } else {
           Utils.showSnackbar(
              isSuccess: false,
              title: "Error",
              message: response['message'] ?? "Submission failed");
        }
      }
    } catch (e) {
      print("Error submitting cart: $e");
      Utils.showSnackbar(
          isSuccess: false, title: "Error", message: "An error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionButtonAction(String endpoint) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
      String lat = '';
      String long = '';
      try {
        print("📍 Checking location permission...");
        LocationPermission permission = await Geolocator.checkPermission();
        print("📍 Permission status: $permission");

        if (permission == LocationPermission.denied) {
          print("📍 Requesting permission...");
          permission = await Geolocator.requestPermission();
          print("📍 Permission after request: $permission");
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          print("📍 Getting current position...");
          Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          print(
              "📍 Position obtained: ${position.latitude}, ${position.longitude}");
          lat = position.latitude.toString();
          long = position.longitude.toString();
        } else {
          print("📍 Location permission not granted.");
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();
      print(" Token $token");
      print(" user_key $ukey");
      print(" gps_lat $lat");
      print(" gps_long  $long");

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

      // Calling API
      await apiService.makeRequestRaw(
        endPoint: endpoint,
        method: 'GET',
        body: body,
        headers: headers,
      );

    } catch (e) {
      print("Error fetching post details: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> getCoupons(String endpoint) async {
    isLoading.value = true;
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
                  desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for coupons: $e");
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

      // Ensure endpoint doesn't have leading slash if ApiService appends it
      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      print("➡️ Fetching Coupons from: $cleanEndpoint");
      print("📦 Body: $body");

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && response is Map<String, dynamic>) {
        couponsResponseModel.value = CouponsGetResponseModel.fromJson(response);
        print("📦 Coupons Response Stored: ${couponsResponseModel.value?.success}");
        
        // Show Bottom Sheet
        Get.bottomSheet(
          const CouponCustomBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      }
    } catch (e) {
      print("Error fetching coupons: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyCoupon({required String endpoint, required String couponCode}) async {
    isApplyingCoupon.value = true;
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
                  desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for apply coupon: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Construct body as per Postman request
      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
        'coupon_code': couponCode,
      };

      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      print("🚀 Applying Coupon at: $cleanEndpoint");
      print("📦 Body: $body");

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
         print("✅ Coupon Applied Successfully");
         appliedCouponCode.value = couponCode;
         isCouponApplied.value = true;
         final prefs = await SharedPreferences.getInstance();


         final apiEndpoint = prefs.getString('cart_details_endpoint');
         print("cart refresh end points :$apiEndpoint");
         if (apiEndpoint != null && apiEndpoint.isNotEmpty) {
           await fetchCartDetails(cartEndpoint: apiEndpoint);
         } else {
           debugPrint("⚠️ Cart refresh endpoint not found");
         }
         Utils.showSnackbar(isSuccess: true, title: "Success", message: response['message'] ?? "Coupon applied");
         
      } else {
         final msg = (response is Map<String, dynamic>) ? response['message'] : "Failed to apply coupon";
         print("❌ Coupon Application Failed: $msg");
         Utils.showSnackbar(
              isSuccess: false,
              title: "Error",
              message: msg ?? "Failed to apply coupon");
         // Clear applied coupon if failed
         appliedCouponCode.value = '';
         isCouponApplied.value = false;
      }
    } catch (e) {
      print("Error applying coupon: $e");
      Utils.showSnackbar(isSuccess: false, title: "Error", message: "An error occurred");
    } finally {
      isApplyingCoupon.value = false;
    }
  }




  Future<void> fetchCartPreview({
    required String apiEndpoint,
    required String nextPageName,
  }) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
      String lat = '';
      String long = '';
      try {
        print("📍 Checking location permission...");
        LocationPermission permission = await Geolocator.checkPermission();
        print("📍 Permission status: $permission");

        if (permission == LocationPermission.denied) {
          print("📍 Requesting permission...");
          permission = await Geolocator.requestPermission();
          print("📍 Permission after request: $permission");
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          print("📍 Getting current position...");
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          print(
              "📍 Position obtained: ${position.latitude}, ${position.longitude}");
          lat = position.latitude.toString();
          long = position.longitude.toString();
        } else {
          print("📍 Location permission not granted.");
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();
      print(" Token $token");
      print(" user_key $ukey");
      print(" gps_lat $lat");
      print(" gps_long  $long");

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
      final response = await apiService.makeRequestRaw(
        endPoint: apiEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        /// ✅ Parse response into model
        final model = CartPreviewResponseModel.fromJson(response);

        if (model.success == true) {
          cartPreviewResponse.value = model;
          if (nextPageName != null && nextPageName.isNotEmpty) {
            print("🔄 Navigating to: $nextPageName");
            CustomNavigator.navigate(nextPageName);
          }
          print("✅ Cart Preview Loaded");
          // print("🧾 Items Count: ${model.result?.first.items?.length}");
        } else {
          Utils.showSnackbar(
            isSuccess: false,
            title: "Error",
            message: model.message ?? "Cart preview failed",
          );
        }
      }
    } catch (e) {
      print("❌ Error fetching cart preview: $e");
      Utils.showSnackbar(
        isSuccess: false,
        title: "Error",
        message: "An error occurred",
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> paymentMethodCall({required String endpoint,required String nextpagename,required String nextpageapiendpoint}) async {
    isApplyingCoupon.value = true;
    _currentPaymentApiEndpoint = nextpageapiendpoint; // Store for callback
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
              desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for apply coupon: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Construct body as per Postman request
      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
      };

      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      print("🚀 Applying : $cleanEndpoint");
      print("📦 Body: $body");

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null &&
          response is Map<String, dynamic> &&
          response['success'] == true) {

        print("✅ Payment Method Applied Successfully");
        if (nextpagename == "razorpay_screen") {
          onlinePaymentGetDetailsResponseModel.value = OnlinePaymentGetDetailsResponseModel.fromJson(response as Map<String, dynamic>);
          
          if (onlinePaymentGetDetailsResponseModel.value?.result != null) {
            final result = onlinePaymentGetDetailsResponseModel.value!.result!;
            _razorpayService.openCheckout(
              amount: (result.totalAmount ?? 0).toDouble(),
              description: result.description,
              prefillContact: result.contactNumber,
              prefillEmail: result.emailId,
            );
          }
        }else{
          // Get.to(()=>MyOrdersScreen());
        }
        //
        // if (nextpagename == "razorpay_screen") {
        //   const double staticAmount = 100; // ₹100 fixed test amount
        //
        //   _razorpayService.openCheckout(
        //     amount: staticAmount,
        //     description: "Payment for ${btn.label ?? 'Order'}",
        //     // prefillContact: userMobile,
        //     // prefillEmail: userEmail,
        //   );
        // }
      }
      else {
        final msg = (response is Map<String, dynamic>) ? response['message'] : "";
        print("❌ Payment Method Failed: $msg");
        Utils.showSnackbar(
            isSuccess: false,
            title: "Error",
            message: msg ?? "");
        // Clear applied coupon if failed
        appliedCouponCode.value = '';
        isCouponApplied.value = false;
      }
    } catch (e) {
      print("Error applying coupon: $e");
      Utils.showSnackbar(isSuccess: false, title: "Error", message: "An error occurred");
    } finally {
      isApplyingCoupon.value = false;
    }
  }
  Future<void> storePaymentResponse({
    required String apiEndpoint,
    required String payment_id,
    String? order_id,
    String? pg_response,
  }) async {
    print("💾 storePaymentResponse called with: payment_id=$payment_id, order_id=$order_id, pg_response=$pg_response");
    isLoading.value = true;
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
          print("📍 Requesting permission...");
          permission = await Geolocator.requestPermission();
          print("📍 Permission after request: $permission");
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
              .timeout(const Duration(seconds: 5));
          print(
              "📍 Position obtained: ${position.latitude}, ${position.longitude}");
          lat = position.latitude.toString();
          long = position.longitude.toString();
        } else {
          print("📍 Location permission not granted.");
        }
      } catch (e) {
        print("❌ Error getting location: $e");
      }

      final apiService = ApiServices();
      print(" Token $token");
      print(" user_key $ukey");
      print(" gps_lat $lat");
      print(" gps_long  $long");

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
        'payment_id': payment_id,
        'order_id': order_id ?? "",
        'pg_response': pg_response ?? "",
      };
      final response = await apiService.makeRequestRaw(
        endPoint: apiEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && response is Map<String, dynamic>) {
         if (response['success'] == true) {
             print("✅ Payment stored successfully");
             Utils.showSnackbar(isSuccess: true, title: "Success", message: response['message'] ?? "Payment Successful");
             
             // Navigate to next page if needed or go back
             // For now just back to previous screen or cart
             // You might want to clear cart or navigate to order success page
             Get.back(); // Close cart preview?
         } else {
             Utils.showSnackbar(isSuccess: false, title: "Error", message: response['message'] ?? "Payment Verification Failed");
         }
      }
    } catch (e) {
      print("❌ Error storing payment response: $e");
      Utils.showSnackbar(
        isSuccess: false,
        title: "Error",
        message: "An error occurred while storing payment",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
