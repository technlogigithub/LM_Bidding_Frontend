import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../models/Participate/participate_details_model.dart';
import '../../widget/app_social_icons.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../../core/network.dart';
import '../../core/utils.dart';
import '../../widget/custom_navigator.dart';

class ParticipationDetailController extends GetxController {
  var isLoading = true.obs;
  var detailResponse = Rxn<ParticipateDetaislResponseModel>();
  var isLoadingForm = false.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real scenario, we would call getParticipationDetails with an endpoint
    // but here we wait for the screen to trigger it.
  }

  Future<Map<String, dynamic>> getBaseBody() async {
    final prefs = await SharedPreferences.getInstance();
    String? ukey = prefs.getString('ukey');
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
      debugPrint("❌ Error getting location: $e");
    }

    return {
      if (ukey != null) "user_key": ukey,
      if (lat.isNotEmpty) "gps_lat": lat,
      if (long.isNotEmpty) "gps_long": long,
    };
  }

  Future<void> getParticipationDetails(String endpoint) async {
    if (endpoint.isEmpty) return;
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final body = await getBaseBody();

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };

      final response = await ApiServices().makeRequestFormData(
        endPoint: endpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && response['success'] == true) {
        detailResponse.value = ParticipateDetaislResponseModel.fromJson(response);
      } else {
        detailResponse.value = null; // Reset if failed
        debugPrint("⚠️ API returned success=false or null: $response");
        Utils.showSnackbar(
          isSuccess: false,
          title: "",
          message: response != null ? response['message'] ?? "" : "",
        );
      }
    } catch (e) {
      detailResponse.value = null;
      debugPrint("❌ Error fetching participation details: $e");
      // Utils.showSnackbar(
      //   isSuccess: false,
      //   title: "Error",
      //   message: "An error occurred while fetching details",
      // );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<dynamic>> fetchSectionItems(String endpoint) async {
    if (endpoint.isEmpty) return [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final body = await getBaseBody();

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };

      final response = await ApiServices().makeRequestFormData(
        endPoint: endpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && response['success'] == true && response['result'] != null) {
        if (response['result'] is List) {
          return response['result'];
        } else if (response['result'] is Map && response['result']['items'] != null) {
          return response['result']['items'];
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching section items: $e");
    }
    return [];
  }

  Future<void> submitSubmitButtonAction({
    required String endpoint,
    required Map<String, dynamic> formData,
  }) async {
    if (endpoint.isEmpty) return;
    isLoadingForm.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final body = await getBaseBody();
      body.addAll(formData);

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };

      final response = await ApiServices().makeRequestFormData(
        endPoint: endpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && (response['success'] == true || response['response_code'] == 200)) {
        Utils.showSnackbar(
          isSuccess: true,
          title: "",
          message: response['message'] ?? "",
        );
        Get.back();
      } else {
        Utils.showSnackbar(
          isSuccess: false,
          title: "",
          message: response != null ? response['message'] ?? "" : "",
        );
      }
    } catch (e) {
      debugPrint("❌ Error submitting action: $e");
      // Utils.showSnackbar(
      //   isSuccess: false,
      //   title: "Error",
      //   message: "Failed to perform action",
      // );
    } finally {
      isLoadingForm.value = false;
    }
  }

  Future<void> executeGeneralAction(String endpoint, String nextPageName, String nextPageViewType) async {
    if (endpoint.isEmpty) {
      if (nextPageName.isNotEmpty) {
        CustomNavigator.navigate(nextPageName);
      }
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final body = await getBaseBody();

      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      };

      final response = await ApiServices().makeRequestFormData(
        endPoint: endpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null && (response['success'] == true || response['response_code'] == 200)) {
        if (nextPageName.isNotEmpty) {
           CustomNavigator.navigate(nextPageName);
        }
      }
    } catch (e) {
      debugPrint("❌ Error executing action: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
