import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://example.com/api/";

  /// ------------------- GET -------------------
  static Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + endpoint));
      return _processResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  /// ------------------- POST -------------------
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {"Content-Type": "application/json"},
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
        headers: {"Content-Type": "application/json"},
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
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception("Bad Request: ${response.body}");
      case 401:
        throw Exception("Unauthorized");
      case 403:
        throw Exception("Forbidden");
      case 404:
        throw Exception("Not Found");
      case 500:
        throw Exception("Internal Server Error");
      default:
        throw Exception("Error: ${response.statusCode} ${response.body}");
    }
  }
}


// void testApi() async {
//     try {
//       /// Example: GET
//       var getData = await ApiService.getRequest("users");
//       print("GET Response: $getData");

//       /// Example: POST
//       var postData = await ApiService.postRequest("login", {
//         "email": "test@gmail.com",
//         "password": "123456"
//       });
//       print("POST Response: $postData");

//       /// Example: DELETE
//       var deleteData = await ApiService.deleteRequest("users/1");
//       print("DELETE Response: $deleteData");

//       /// Example: Multipart (Image Upload)
//       File file = File("/storage/emulated/0/Download/test.png");
//       var uploadData = await ApiService.multipartRequest(
//         "upload",
//         {"user_id": "123"},
//         file,
//         "image",
//       );
//       print("UPLOAD Response: $uploadData");

//       setState(() {
//         result = "All API calls successful! Check console.";
//       });
//     } catch (e) {
//       setState(() {
//         result = e.toString();
//       });
//     }
//   }
