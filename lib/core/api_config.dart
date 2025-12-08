import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://phplaravel-1517766-5835172.cloudwaysapps.com/api/";

  /// ------------------- GET -------------------
  static Future<dynamic> getRequest(
      String endpoint, {
        Map<String, String>? headers,
      }) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          if (headers != null) ...headers,
        },
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- POST -------------------
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body,{
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          if (headers != null) ...headers,
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- PUT -------------------
  static Future<dynamic> putRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- DELETE -------------------
  static Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + endpoint));
      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- MULTIPART (Image Upload) -------------------
  static Future<dynamic> multipartRequest(
      String endpoint,
      Map<String, String> fields,
      File file,
      String fileField,
      ) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(baseUrl + endpoint),
      );

      // Add fields
      request.fields.addAll(fields);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fileField, file.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- RESPONSE HANDLER -------------------
  static dynamic _processResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        data['status_code'] = response.statusCode;
        return data;
      }

      return {
        "status_code": response.statusCode,
        "data": data,
      };
    } catch (e) {
      throw Exception("Invalid Response Format: ${response.body}");
    }
  }
}
