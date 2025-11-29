import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/app_color.dart';

class RazorpayService {
  late Razorpay _razorpay;

  // Static Razorpay Key (Demo purpose - replace with your actual key)
  // For testing, you can use Razorpay's test keys
  static const String _razorpayKey = 'rzp_test_1DP5mmOlF5G5ag'; // Replace with your actual Razorpay key

  void initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required double amount,
    String? name,
    String? description,
    String? prefillEmail,
    String? prefillContact,
  }) {
    var options = {
      'key': _razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': name ?? '',
      'description': description ?? 'Payment for services',
      'prefill': {
        'contact': prefillContact ?? '9999999999',
        'email': prefillEmail ?? 'demo@libdding.com'
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color':'#28282B',
        'backdrop_color': '#28282B',
        "backgroundColor": "#28282B",
      },
      "display": {
        "widget": {
          "main": {
            "isDarkMode": true,
            "content": {
              "backgroundColor": "#28282B",
              "color": "#28282B",
              "fontSize": "13px"
            }
          }
        }
      }
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    Get.snackbar(
      'Payment Success',
      'Payment ID: ${response.paymentId}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment failed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
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
  }

  void dispose() {
    _razorpay.clear();
  }
}

