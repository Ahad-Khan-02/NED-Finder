import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';


class Http {
  static const String _baseUrl = 'http://10.0.2.2:8000'; // Replace with your API base URL
  
  // Device Type                	Base URL
  // Windows / Postman	http  ://127.0.0.1:8000
  // Android Emulator	http  ://10.0.2.2:8000
  // Physical Android Device	http  ://<your-pc-ip>:8000


  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // [NEW METHOD] Helper method to make a POST request where data MUST be sent as query parameters (e.g., /claim)
  static Future<Map<String, dynamic>> postWithQueryParams(
      String endpoint, Map<String, dynamic> queryParams) async {
    
    final baseUri = Uri.parse(_baseUrl);
    final isHttps = baseUri.scheme == 'https';

    // 1. Convert all values in the query map to strings for URL encoding
    final stringQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    // 2. Build the full, reliable URI using the correct scheme (http or https)
    final Uri uri;
    if (isHttps) {
      uri = Uri.https(
        baseUri.authority, // extracts the host (e.g., example.com)
        '/$endpoint', // the path (e.g., /claim)
        stringQueryParams,
      );
    } else {
      // Use Uri.http for local development servers like 127.0.0.1:8000
      uri = Uri.http(
        baseUri.authority, // extracts the host and port (e.g., 127.0.0.1:8000)
        '/$endpoint', // the path (e.g., /claim)
        stringQueryParams,
      );
    }


    final response = await http.post(
      uri,
      // IMPORTANT: No headers or body are included, as the data is already in the URI.
    );
    return _handleResponse(response);
  }



  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = json.decode(response.body);

      if (body is Map<String, dynamic>) {
        // If backend sends a validation error (422), convert it into a readable message
        if (body.containsKey('detail')) {
          final detail = body['detail'];
          if (detail is List && detail.isNotEmpty) {
            return {
              "status": "error",
              "message": detail[0]['msg'] ?? "Validation error"
            };
          }
        }
        return body;
      } else {
        return {
          "status": response.statusCode >= 200 && response.statusCode < 300 ? "success" : "error",
          "message": response.body
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to parse response"
      };
    }
  }



  // Helper method to make a MULTIPART POST request (for file uploads)
  static Future<Map<String, dynamic>> multipartPost(
  String endpoint, 
  Map<String, String> fields, 
  File? imageFile,
  String imageFieldName, // e.g., 'item_image'
  ) async {

  final uri = Uri.parse('$_baseUrl/$endpoint');
  final request = http.MultipartRequest('POST', uri);

  // Add text fields
  request.fields.addAll(fields);

  // Add file
  if (imageFile != null) {
    // 🎯 FIX 1: Detect MIME type using the 'mime' package
    final mimeType = lookupMimeType(imageFile.path); 
    final contentType = mimeType != null 
      ? MediaType.parse(mimeType) 
      : MediaType('image', 'jpeg'); // Fallback to image/jpeg if detection fails

    // 🎯 FIX 2: Explicitly pass the contentType to the MultipartFile
    request.files.add(
      await http.MultipartFile.fromPath(
          imageFieldName, 
          imageFile.path,
          contentType: contentType, // <--- THIS IS THE CRITICAL ADDITION
      ),
    );
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  return _handleResponse(response);
  }
}

//.\venv\Scripts\activate
// uvicorn main:app --reload
