import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_constant.dart';
import 'app_string.dart';
import 'package:libdding/core/utils.dart';

class ApiServices {
  ApiServices();

  /// Raw JSON request
  Future<dynamic> makeRequestRaw({
    required String endPoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      if (!await _isInternetAvailable()) {
        Utils.showSnackbar(
          title: AppStrings.alert,
          message: AppStrings.pleaseCheckYourInternetOrWifiConnection,
          isSuccess: false,
        );
        throw Exception('No internet connection');
      }

      final String finalUrl = "${AppConstants.baseUrl}$endPoint";
      final uri = Uri.parse(finalUrl);

      Map<String, String> defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      print('➡️ Request: [$method] $finalUrl');
      if (body != null) print('📦 Body: ${jsonEncode(body)}');

      http.Response response;
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(uri, body: jsonEncode(body), headers: defaultHeaders);
          break;
        case 'PUT':
          response = await http.put(uri, body: jsonEncode(body), headers: defaultHeaders);
          break;
        case 'PATCH':
          response = await http.patch(uri, body: jsonEncode(body), headers: defaultHeaders);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: defaultHeaders);
          break;
        case 'GET':
          response = await http.get(uri, headers: defaultHeaders);
          break;
        default:
          throw Exception('Unsupported method: $method');
      }

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('❌ Error in makeRequestRaw: $e');
      rethrow;
    }
  }

  Future<dynamic> makeRequestFormData({
    required String endPoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? formData,
    List<http.MultipartFile>? files,
  }) async {
    try {
      if (!await _isInternetAvailable()) {
        Utils.showSnackbar(
          title: AppStrings.alert,
          message: AppStrings.pleaseCheckYourInternetOrWifiConnection,
          isSuccess: false,
        );
        throw Exception('No internet connection');
      }

      final String finalUrl = "${AppConstants.baseUrl}$endPoint";
      final uri = Uri.parse(finalUrl);

      print('➡️ Request: [$method] $finalUrl');
      if (body != null) print('📦 Body: $body');
      if (formData != null) print('📝 Form Data: $formData');
      if (files != null && files.isNotEmpty) print('📂 Files: ${files.length} file(s)');

      http.Response response;
      Map<String, String> defaultHeaders = {...?headers};

      if (method.toUpperCase() == 'GET') {
        response = await http.get(uri, headers: defaultHeaders);
      } else if (method.toUpperCase() == 'POST') {
        if (formData != null || body != null || files != null) {
          var request = http.MultipartRequest('POST', uri);
          request.headers.addAll(defaultHeaders);

          // ✅ Add formData fields
          if (formData != null) request.fields.addAll(formData);

          // ✅ Add body as form fields (convert all values to String)
          if (body != null) {
            body.forEach((key, value) {
              request.fields[key] = value.toString();
            });
          }

          // ✅ Add files
          if (files != null) request.files.addAll(files);

          var streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
        } else {
          response = await http.post(uri,
              body: jsonEncode(body),
              headers: {
                'Content-Type': 'application/json',
                ...defaultHeaders,
              });
        }
      } else if (method.toUpperCase() == 'PUT') {
        response = await http.put(uri,
            body: jsonEncode(body),
            headers: {
              'Content-Type': 'application/json',
              ...defaultHeaders,
            });
      } else if (method.toUpperCase() == 'PATCH') {
        response = await http.patch(uri,
            body: jsonEncode(body),
            headers: {
              'Content-Type': 'application/json',
              ...defaultHeaders,
            });
      } else if (method.toUpperCase() == 'DELETE') {
        response = await http.delete(uri, headers: defaultHeaders);
      } else {
        throw Exception('Unsupported method: $method');
      }

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 204) {
        return null;
      } else {
        var responseBody;
        try {
          responseBody = jsonDecode(response.body);
        } catch (_) {
          responseBody = {'message': 'Invalid response'};
        }
        String message = responseBody['message'] ?? 'Request failed';
        throw Exception(message);
      }
    } catch (e) {
      print('❌ Error in makeRequestFormData: $e');
      rethrow;
    }
  }

  /// Internet check
  Future<bool> _isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    if (kIsWeb) {
      return true;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
