// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// class PaymentController extends GetxController {
//
//   final CFPaymentGatewayService cfService = CFPaymentGatewayService();
//
//   @override
//   void onInit() {
//     super.onInit();
//     cfService.setCallback(onPaymentVerify, onPaymentError);
//   }
//
//   // ===============================
//   // STEP 1 : CREATE ORDER (Laravel)
//   // ===============================
//   Future<void> createOrder() async {
//
//     final response = await http.post(
//       Uri.parse("https://yourdomain.com/api/cashfree/create-order"),
//     );
//
//     final data = jsonDecode(response.body);
//
//     startPayment(
//       orderId: data['orderId'],
//       paymentSessionId: data['paymentSessionId'],
//     );
//   }
//
//   // ===============================
//   // STEP 2 : START CASHFREE UI
//   // ===============================
//   Future<void> startPayment({
//     required String orderId,
//     required String paymentSessionId,
//   }) async {
//
//     try {
//
//       CFSession session = CFSessionBuilder()
//           .setEnvironment(CFEnvironment.SANDBOX) // change to PRODUCTION later
//           .setOrderId(orderId)
//           .setPaymentSessionId(paymentSessionId)
//           .build();
//
//       CFWebCheckoutPayment payment =
//       CFWebCheckoutPaymentBuilder()
//           .setSession(session)
//           .build();
//
//       cfService.doPayment(payment);
//
//     } on CFException catch (e) {
//       debugPrint("Cashfree Error: ${e.message}");
//     }
//   }
//
//   // ===============================
//   // STEP 3 : CASHFREE CALLBACK
//   // ===============================
//   void onPaymentVerify(String orderId) {
//     debugPrint("✅ PAYMENT SUCCESS: $orderId");
//     verifyFromServer(orderId);
//   }
//
//   void onPaymentError(CFErrorResponse error, String orderId) {
//     debugPrint("❌ PAYMENT FAILED: ${error.getMessage()}");
//   }
//
//   // ===============================
//   // STEP 4 : VERIFY FROM BACKEND
//   // ===============================
//   Future<void> verifyFromServer(String orderId) async {
//
//     final response = await http.post(
//       Uri.parse("https://yourdomain.com/api/cashfree/verify-payment"),
//       body: {
//         "orderId": orderId
//       },
//     );
//
//     debugPrint("SERVER VERIFY RESULT:");
//     debugPrint(response.body);
//   }
// }


// class PaymentController extends GetxController {
//
//   final CFPaymentGatewayService cfService = CFPaymentGatewayService();
//
//   final String clientId = "";
//   final String clientSecret = "";
//
//   @override
//   void onInit() {
//     super.onInit();
//     cfService.setCallback(onPaymentVerify, onPaymentError);
//   }
//
//   Future<void> createOrder() async {
//
//     String orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";
//
//     final response = await http.post(
//       Uri.parse("https://sandbox.cashfree.com/pg/orders"),
//       headers: {
//         "Content-Type": "application/json",
//         "x-client-id": clientId,
//         "x-client-secret": clientSecret,
//         "x-api-version": "2023-08-01",
//       },
//       body: jsonEncode({
//         "order_amount": 1,
//         "order_id": orderId,
//         "order_currency": "INR",
//         "customer_details": {
//           "customer_id": "123",
//           "customer_name": "Test User",
//           "customer_email": "test@gmail.com",
//           "customer_phone": "9999999999"
//         }
//       }),
//     );
//
//     debugPrint("STATUS: ${response.statusCode}");
//     debugPrint(response.body);
//
//     if (response.statusCode != 200) {
//       throw Exception("Cashfree order failed");
//     }
//
//     final data = jsonDecode(response.body);
//
//     if (data['payment_session_id'] == null) {
//       throw Exception("payment_session_id missing");
//     }
//
//     startPayment(
//       orderId: data['order_id'],
//       paymentSessionId: data['payment_session_id'],
//     );
//   }
//
//   Future<void> startPayment({
//     required String orderId,
//     required String paymentSessionId,
//   }) async {
//
//     CFSession session = CFSessionBuilder()
//         .setEnvironment(CFEnvironment.SANDBOX)
//         .setOrderId(orderId)
//         .setPaymentSessionId(paymentSessionId)
//         .build();
//
//     CFWebCheckoutPayment payment =
//     CFWebCheckoutPaymentBuilder()
//         .setSession(session)
//         .build();
//
//     cfService.doPayment(payment);
//   }
//
//   void onPaymentVerify(String orderId) {
//     debugPrint("✅ SUCCESS: $orderId");
//   }
//
//   void onPaymentError(CFErrorResponse error, String orderId) {
//     debugPrint("❌ FAILED: ${error.getMessage()}");
//   }
// }