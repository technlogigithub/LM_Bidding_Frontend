import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app_color.dart';

class Utils {
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Check if there is a network connection
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Try connecting to Google to confirm actual internet access
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false; // No internet access
    }
  }
  static void showSnackbar({
    required bool isSuccess,
    required String title,
    required String message,
    int durationInSeconds = 3,
  }) {
    Get.snackbar(
      colorText: AppColors.appWhite,
      backgroundColor: isSuccess ? AppColors.appSuccesses : AppColors.appFail,
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: durationInSeconds),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(
        Icons.info,
        color: AppColors.appWhite
        ,
      ),
    );
  }

  static bool isValidEmail(String email) {
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
  /// **Get Address From Lat - Long
  static Future<String> getAddressFromLatLong(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0]; // Take the first result

      // Construct the address from available fields
      String address = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return address;
    } catch (e) {
      print("Error occurred: $e");
      return "Unable to get address";
    }
  }


  /// **Use this method to go to Next page Without replacement of previous page
  static gotoNextPage(Widget Function() pageName) {
    Get.to(pageName());
  }

  /// **Use this method to go to Next page With replacement of previous page
  static gotoNextPageWithReplacement(Widget Function() pageName) {
    Get.off(pageName()); // Replaces the current page
  }

  /// **Use this method to go to Next page With replacement of All Screens
  static gotoNextPageWithReplacemenofALL(Widget Function() pageName) {
    Get.offAll(pageName()); // Replaces the current page
  }

  /// **Use this method to go to Next page With replacement of All Screens
  static gotoNextPageWithReplacemenofALLwithParams(Widget Function() pageName, var params) {
    Get.offAll(() => pageName(), arguments: params); // Replaces the current page
  }

  /// **Use this method to go to Next page Without Replacement of previous page and pass params
  static gotoNextPageWithParams(Widget Function() pageName, var params) {
    Get.to(() => pageName(), arguments: params);
  }

  /// **Use this method to go to Next page With Replacement of previous page and pass params
  static gotoNextPageWithReplacementWithParams(Widget Function() pageName, var params) {
    Get.off(() => pageName(), arguments: params);
  }

  /// **Use this method to go to Previous page
  static gotoPreviousPage() {
    Get.back();
  }

  /// Navigate to the previous page with an optional result
  static void gotoPreviousPagewithanOptionResult({dynamic result}) {
    Future.delayed(Duration(milliseconds: 2), () {
      Get.back(result: result);
    });
  }

  /// **Use this Method to go to previous page with params
  static gotoPreviousPagewithParams({required Map<String, dynamic> result}) {
    Get.back(result: result);
  }

  /// Navigate to the next page and wait for result
  static Future<void> gotoNextPageAndWaitForTheResult(Widget Function() pageName, Function? onReturn) async {
    final result = await Get.to(pageName());
    if (onReturn != null) {
      onReturn(); // Call refresh method after returning
    }
  }
}