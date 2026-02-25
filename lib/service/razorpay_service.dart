import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_images.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../controller/app_main/App_main_controller.dart';
import '../core/app_color.dart';

class RazorpayService {
  late Razorpay _razorpay;

  // Fallback key — override via openCheckout(razorpayKey: ...)
  static const String _fallbackKey = 'rzp_test_1DP5mmOlF5G5ag';
  String _razorpayKey = _fallbackKey;

  AppSettingsController appController = Get.find<AppSettingsController>();
  AppSettingsController appSettingsController = Get.find<AppSettingsController>();
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;
  Function(ExternalWalletResponse)? onExternalWallet;

  void initRazorpay({
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onFailure,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    this.onSuccess = onSuccess;
    this.onFailure = onFailure;
    this.onExternalWallet = onExternalWallet;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required double amount,
    String? razorpayKey,   // ← dynamic key from backend
    String? name,
    String? description,
    String? prefillEmail,
    String? prefillContact,
  }) {
    // Use backend-provided key, fall back to constant if absent
    _razorpayKey = (razorpayKey != null && razorpayKey.isNotEmpty)
        ? razorpayKey
        : _fallbackKey;

    var options = {
      'key': _razorpayKey,
      'amount': (amount * 100).toInt(),
      'image': appSettingsController.logoSplash.value,
      'name': appSettingsController.appName.value,
      'description': description ?? '',
      'prefill': {
        'contact': prefillContact ?? '',
        'email': prefillEmail ?? ''
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': appSettingsController.primaryColor.value,

        /// Header Color
        "isDarkMode": appController.isDarkMode.value
      },
      "display": {
        "widget": {
          "main": {
            "isDarkMode": appController.isDarkMode.value
          }
        }
      }
      // 'theme': {
      //   'color':'#28282B',
      //   'backdrop_color': '#28282B',
      //   "backgroundColor": "#28282B",
      // },
      // "display": {
      //   "widget": {
      //     "main": {
      //       "isDarkMode": true,
      //       "content": {
      //         "backgroundColor": "#28282B",
      //         "color": "#28282B",
      //         "fontSize": "13px"
      //       }
      //     }
      //   }
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      Get.snackbar(
        'Error',
        'Failed to open payment gateway',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // void openCheckout() async {
  //   var options = {
  //     'key': 'RAZORPAY_KEY_HERE',
  //     'amount': 5000,
  //     'name': 'Your App Name',
  //     'description': 'Order Payment',
  //     // ✅ Add Application Logo (must be a URL)
  //     'image': 'https://phplaravel-1517766-5835172.cloudwaysapps.com/assets/images/lobalmart/logo_splash.png',
  //
  //     'prefill': {
  //       'contact': '9876543210',
  //       'email': 'test@example.com',
  //     },
  //
  //     // 🎨 Theme Color
  //     'theme': {
  //       'color': '#7b3df8'
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Build full dump manually (SDK me sirf ye hi fields hoti hain)
    final Map<String, dynamic> fullResponse = {
      "paymentId": response.paymentId,
      "orderId": response.orderId,
      "signature": response.signature,
    };

    debugPrint('================ RAZORPAY PAYMENT SUCCESS ================');
    debugPrint(const JsonEncoder.withIndent('  ').convert(fullResponse));
    debugPrint('==========================================================');

    Get.snackbar(
      'Payment Success',
      'Payment ID: ${response.paymentId}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    if (onSuccess != null) onSuccess!(response);
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    final Map<String, dynamic> fullErrorResponse = {
      "code": response.code,
      "message": response.message,
      "error": response.error, // sometimes contains nested map
    };

    debugPrint('================ RAZORPAY PAYMENT FAILURE ================');
    debugPrint(const JsonEncoder.withIndent('  ').convert(fullErrorResponse));
    debugPrint('==========================================================');

    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment failed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    if (onFailure != null) onFailure!(response);
  }



  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    Get.snackbar(
      'External Wallet',
      'Selected wallet: ${response.walletName}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    if (onExternalWallet != null) onExternalWallet!(response);
  }

  void dispose() {
    _razorpay.clear();
  }
}
