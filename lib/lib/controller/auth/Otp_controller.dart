import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/app_constant.dart';
import '../../core/network.dart';
import '../../core/utils.dart';
import '../../view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../app_main/App_main_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';

class OtpController extends GetxController {
  var pinController = TextEditingController();
  var isLoading = false.obs;
  var secondsRemaining = 60.obs;
  String mobile = ""; // store mobile number here
  Timer? _timer;

  final ClientHomeController homecontroller = Get.put(ClientHomeController());
  final appController = Get.find<AppSettingsController>();
  final profilecontroller = Get.put(ProfileController());



  @override
  void onInit() {
    // TODO: implement onInit
    startTimer();
    super.onInit();
  }
  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }

  void setMobile(String mobileNo) {
    mobile = mobileNo;
  }

  void startTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    toast("Resend OTP clicked");
    startTimer();
    // call your API to resend OTP if needed
  }

  Future<void> submitOtp() async {
    String pin = pinController.text.trim();

    // Read dynamic verify_otp rules
    final verify = Get.find<AppSettingsController>().verifyOtpPage.value;
    if (verify != null && (verify.inputs ?? []).isNotEmpty) {
      final field = verify.inputs!.first; // assume single OTP field
      // required
      if ((field.required ?? false) && pin.isEmpty) {
        toast(field.label != null ? "${field.label} is required" : "Please enter OTP");
        return;
      }
      for (final v in (field.validations ?? [])) {
        final t = (v.type ?? '').toLowerCase();
        if (t == 'numeric') {
          if (!RegExp(r'^\d+$').hasMatch(pin)) {
            toast(v.errorMessage ?? "OTP must be numeric");
            return;
          }
        } else if (t == 'exact_length') {
          final len = v.value ?? 0;
          if (pin.length != len) {
            toast(v.errorMessage ?? "OTP must be exactly $len digits");
            return;
          }
        } else if (t == 'min_length') {
          final len = v.value ?? v.minLength ?? 0;
          if (pin.length < len) {
            toast(v.errorMessage ?? v.minLengthError ?? "OTP must be at least $len digits");
            return;
          }
        } else if (t == 'max_length') {
          final len = v.value ?? v.maxLength ?? 999999;
          if (pin.length > len) {
            toast(v.errorMessage ?? v.maxLengthError ?? "OTP must be at most $len digits");
            return;
          }
        }
      }
    } else {
      if (pin.isEmpty) {
        toast("Please enter OTP");
        return;
      }
    }

    try {
      isLoading.value = true;

      final apiService = ApiServices();
      var response = await apiService.makeRequestFormData(
        endPoint: AppConstants.verifyotp,
        method: "POST",
        body: {
          "mobile_no": mobile,
          "otp": pin,
        },
      );

      print("OTP Verification Response: $response");

      if (response['success'] == true) {
        final token = response['result']['token'];
        await saveAuthToken(token);
        final loginData = response['result'];
        await saveUserData(loginData['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        homecontroller.checkLoginStatus();
        appController.fetchAppContent();
        profilecontroller.fetchProfileDetails();
        toast("OTP verified successfully");
        Utils.gotoNextPage(() => BottomNavigationScreen(),);
        // Navigate to Home
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ClientHome()));
      } else {
        toast(response['message'] ?? "OTP verification failed");
      }
    } catch (e) {
      toast("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print("Auth Token Saved: $token");
  }


  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_data", jsonEncode(data));
  }

}
