import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network.dart';
import '../../core/utils.dart';
import '../../models/Post/Get_Post_details_Model.dart';

class GetPostDetailsController extends GetxController {
  Rx<PostDetailsResponseModel?> getPostDetailsModel = Rx<PostDetailsResponseModel?>(null);
  RxBool isLoading = false.obs;

  Future<void> getPostDetails(String postId) async {
    isLoading.value = true;
    try {
      print("🚀 getPostDetails called for postId: $postId");

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
        
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
           print("📍 Getting current position...");
           Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(const Duration(seconds: 5));
           print("📍 Position obtained: ${position.latitude}, ${position.longitude}");
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
      print("Fetching Post Details for ID: $postId");
      var response = await apiService.makeRequestRaw(
        endPoint: 'post-details/$postId',
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        getPostDetailsModel.value = PostDetailsResponseModel.fromJson(response);
        print(" Body Response ${getPostDetailsModel.value}");
        // Save ukey if present in the response
        if (getPostDetailsModel.value?.result != null && getPostDetailsModel.value!.result!.isNotEmpty) {
           var resultItem = getPostDetailsModel.value!.result!.first;
           if (resultItem.hidden?.ukey != null) {

             // await saveUkey(resultItem.hidden!.ukey!);
           }
        }
      }

    } catch (e) {
      print("Error fetching post details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> saveUkey(String ukey) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('ukey', ukey);
  //   print("Ukey Saved: $ukey");
  // }

  Future<bool> executeApiAction(String endpoint) async {
    isLoading.value = true;
    try {
      print("🚀 performApiAction called for endpoint: $endpoint");

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Ensure endpoint doesn't start with leading slash if ApiServices appends it
      // Standardizing endpoint format
      final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      var response = await apiService.makeRequestRaw(
        endPoint: cleanEndpoint,
        method: 'GET', // Defaulting to GET based on usual REST or user cURL which didn't specify POST. Adjust if needed.
        body: {}, 
        headers: headers,
      );

      print("Response: $response");
      
      if (response != null) {
          // Check for success key or status
           // Assuming response is Map, check 'success' or 'status'
           bool isSuccess = false;
           if (response is Map) {
             if (response['success'] == true || response['status'] == true || response['response_code'] == 200) {
               isSuccess = true;
             }
           }
           
           if (isSuccess) {
              // Get.snackbar("Success", response['message'] ?? "Action completed successfully");
              return true;
           } else {
             Utils.showSnackbar(isSuccess: false, title: "Error", message: response['message'] ?? "Something went wrong");
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

  Future<void> actionButtonAction(String endpoint ) async {
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

        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          print("📍 Getting current position...");
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(const Duration(seconds: 5));
          print("📍 Position obtained: ${position.latitude}, ${position.longitude}");
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

      var response = await apiService.makeRequestRaw(
        endPoint: endpoint,
        method: 'GET',
        body: body,
        headers: headers,
      );

      if (response != null) {}

    } catch (e) {
      print("Error fetching post details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
