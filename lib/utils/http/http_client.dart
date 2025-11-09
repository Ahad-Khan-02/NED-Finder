import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
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
    request.files.add(
      await http.MultipartFile.fromPath(
        imageFieldName, // Must match the field name in FastAPI: 'item_image'
        imageFile.path,
      ),
    );
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  return _handleResponse(response); // Reuse your existing response handler
}
}

//.\venv\Scripts\activate
// uvicorn main:app --reload
