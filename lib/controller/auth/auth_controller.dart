import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_constant.dart';
import '../../core/app_string.dart';
import '../../core/network.dart';
import '../../core/utils.dart';
import '../../view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../../view/auth/otp_varification_screen.dart';
import '../app_main/App_main_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';


class AuthController extends GetxController {
  var mobile = ''.obs;
  var password = ''.obs;
  var hidePassword = true.obs;
  var isLoading = false.obs;
  var hidePasswordForConfirm = true.obs;
  var isCheck = false.obs;
  RxString errorMessage = ''.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  TextEditingController mobileController = TextEditingController();
  TextEditingController forotpmobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxList<String> availableSimNumbers = <String>[].obs;

  void togglePassword() => hidePassword.value = !hidePassword.value;
  void toggleCheck() => isCheck.value = !isCheck.value;
  void togglePasswordVisibilityForConfirm() => hidePasswordForConfirm.value = !hidePasswordForConfirm.value;

  final ClientHomeController homecontroller = Get.put(ClientHomeController());
  final appController = Get.find<AppSettingsController>();
  final profilecontroller = Get.put(ProfileController());
  Map<String, TextEditingController> fieldControllers = {};


  @override
  void onInit() {
    // TODO: implement onInit
    initMobileNumber();
    // loadSavedCredentials();
    super.onInit();
  }
  /// ✅ Login API
  Future<void> loginApi(BuildContext context,) async {

    if (mobileController.text.trim().isEmpty) {
      toast("${AppStrings.please} ${AppStrings.enteryourMobileNumber}");
      return;
    } else if (passwordController.text.trim().isEmpty) {
      toast("${AppStrings.please} ${AppStrings.pleaseenteryourpassword}");
      return;
    }

    try {
      isLoading.value = true;

      final apiService = ApiServices();
      var response = await apiService.makeRequestFormData(
        endPoint: AppConstants.login,
        method: "POST",
        body: {
          "mobile_no": mobileController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      if (response['success'] == true) {
        final loginData = response['result'];     // ⬅ full data
        final token = loginData['token'];         // ⬅ token

        await saveAuthToken(token);
        await saveUserData(loginData);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await saveCredentials();

        print(" Login Successfull ");
        mobileController.clear();
        passwordController.clear();
        homecontroller.checkLoginStatus();
        appController.fetchAppContent();
        profilecontroller.fetchProfileDetails();
        // homecontroller.fetchBanner();
        // homecontroller.fetchCategory();
        Utils.gotoNextPage(() => BottomNavigationScreen(),);



        // 🔹 Redirect to the original selected page
        // if (widget.redirectPage != null) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => widget.redirectPage!),
        //   );
        // } else {
        //   // Default fallback → ClientHome
        //   ClientHome().launch(context);
        // }
      } else {
        final message = response['message'] ?? "Something went wrong";
        toast(message);
      }

    } catch (e) {
      toast("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  /// ✅ Save Auth Token
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print("Auth Token Saved: $token");
  }


  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_data", jsonEncode(data));
  }


  /// ✅ Save Credentials Securely
  Future<void> saveCredentials() async {
    await secureStorage.write(key: 'mobile', value: mobileController.text);
    await secureStorage.write(key: 'password', value: passwordController.text);
  }

  /// ✅ Load Saved Credentials
  Future<void> loadSavedCredentials() async {
    String? savedMobile = await secureStorage.read(key: 'mobile');
    String? savedPassword = await secureStorage.read(key: 'password');

    if (savedMobile != null) mobileController.text = savedMobile;
    if (savedPassword != null) passwordController.text = savedPassword;
  }

  /// ✅ Initialize SIM Number
  Future<void> initMobileNumber() async {
    try {
      print('Permission Granted checking...');
      bool permissionGranted = await MobileNumber.hasPhonePermission;
      print('Permission Granted action...');
      if (!permissionGranted) {
        print('Permission Granted 0...');
        await MobileNumber.requestPhonePermission;
        permissionGranted = await MobileNumber.hasPhonePermission;
        print('Permission Granted 1...');
      }

      if (permissionGranted) {
        print('Permission Granted 2...');
        List<SimCard>? simCards = await MobileNumber.getSimCards;

        if (simCards != null && simCards.isNotEmpty) {
          availableSimNumbers.clear();
          for (var sim in simCards) {
            String? number = sim.number;
            if (number != null && number.isNotEmpty) {
              // Clean the number: remove +, spaces, and country code if needed
              String formattedNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
              if (formattedNumber.startsWith('91') && formattedNumber.length > 10) {
                formattedNumber = formattedNumber.substring(formattedNumber.length - 10);
              }
              if (!availableSimNumbers.contains(formattedNumber)) {
                availableSimNumbers.add(formattedNumber);
              }
            }
          }
          print('Permission Granted 3...');
          if (availableSimNumbers.isNotEmpty) {
            // If only one number is detected, set it directly
            if (availableSimNumbers.length == 1) {
              mobileController.text = availableSimNumbers[0];
              mobile.value = availableSimNumbers[0];
              print("Single SIM Number Loaded: ${availableSimNumbers[0]}");
            } else {
              // Show dialog to select a number
              showMobileNumberSelectionDialog();
            }
          } else {
            print("No valid SIM numbers found.");
          }
        } else {
          print("No SIM cards detected.");
        }
      } else {
        toast("Phone permission denied.");
      }
    } catch (e) {
      print("Cannot read SIM numbers: $e");
      toast("Error accessing SIM numbers: $e");
    }
  }

  void showMobileNumberSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Select Mobile Number"),
        content: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: availableSimNumbers.map((number) {
              return ListTile(
                title: Text(number),
                onTap: () {
                  mobileController.text = number;
                  mobile.value = number;
                  print("Selected Mobile Number: $number");
                  Get.back(); // Close the dialog
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }





  Future<void> CreateAccountApi(BuildContext context,) async {
    // Basic guard; detailed validations are handled in UI based on dynamic form rules
    if (!isCheck.value) {
      toast(AppStrings.pleaseAcceptTerms);
      return;
    }

    try {
      isLoading.value = true;

      final apiService = ApiServices();
      var response = await apiService.makeRequestFormData(
        endPoint: AppConstants.register,
        method: "POST",
        body: {
          "mobile_no": mobileController.text.trim(),
          "password": passwordController.text.trim(),
          "password_confirmation": confirmPasswordController.text.trim(),
        },
      );

      if (response['success'] == true) {
        final otp = response['result']['otp'];
        toast("OTP: $otp");
        print(" Registor Successfull ");
        // Navigate to OTP verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVarificationScreen(mobile: mobileController.text.trim()),
          ),
        );
      } else {
        final message = response['message'] ?? "Something went wrong";
        toast(message);
      }

    } catch (e) {
      toast("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithOtp(BuildContext context,String mobileNo) async {

    if (mobileNo.isEmpty) {
      toast("${AppStrings.please} ${AppStrings.enteryourMobileNumber}");
      return;
    }
    try {
      isLoading.value = true;

      final apiService = ApiServices();
      var response = await apiService.makeRequestFormData(
        endPoint: AppConstants.loginwithotp,
        method: "POST",
        body: {
          "mobile_no": mobileNo

        },
      );
      print("Login Response: $response");
      if (response['success'] == true) {
        final otp = response['result']['otp'];
        toast("OTP: $otp");
        await saveCredentials();
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('isLoggedIn', true);
        await saveCredentials();
        print(" Login Successfull ");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVarificationScreen(mobile: mobileNo),
          ),
        );


        // 🔹 Redirect to the original selected page
        // if (widget.redirectPage != null) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => widget.redirectPage!),
        //   );
        // } else {
        //   // Default fallback → ClientHome
        //   ClientHome().launch(context);
        // }
      } else {
        final message = response['message'] ?? "Something went wrong";
        toast(message);
      }

    } catch (e) {
      toast("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
