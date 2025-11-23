import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';


class Http {
  static const String _baseUrl = 'http://10.0.2.2:8000'; 

  // --- Helper method to merge default and custom headers ---
  static Map<String, String> _buildHeaders(
      {Map<String, String>? customHeaders, bool isJson = false}) {
    final Map<String, String> finalHeaders = {};

    // 1. Add JSON content type if required
    if (isJson) {
      finalHeaders['Content-Type'] = 'application/json';
    }

    // 2. Merge in custom headers (e.g., Authorization tokens)
    if (customHeaders != null) {
      finalHeaders.addAll(customHeaders);
    }

    return finalHeaders;
  }

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(uri, headers: _buildHeaders(customHeaders: headers));
    return _handleResponse(response);
  }

  // Helper method to make a POST request with JSON body
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      uri,
      headers: _buildHeaders(customHeaders: headers, isJson: true),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a POST request where data MUST be sent as query parameters (e.g., /claim)
  static Future<Map<String, dynamic>> postWithQueryParams(
      String endpoint, Map<String, dynamic> queryParams,
      {Map<String, String>? headers}) async {
    
    final baseUri = Uri.parse(_baseUrl);
    final isHttps = baseUri.scheme == 'https';

    // 1. Convert all values in the query map to strings for URL encoding
    final stringQueryParams =
        queryParams.map((key, value) => MapEntry(key, value.toString()));

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
      headers: _buildHeaders(customHeaders: headers),
    );
    return _handleResponse(response);
  }

  

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    bool isMultipart = false,
    File? file,
    String? fileFieldName,
    Map<String, String>? headers,
    Uint8List? fileBytes,
    String? fileName,
    String? fileMimeType,
    }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');

    // -----------------------
    // CASE 1: MULTIPART PUT
    // -----------------------
    if (isMultipart) {
      if (data is! Map<String, dynamic>) {
        throw ArgumentError("Multipart PUT requires 'data' to be Map<String, dynamic>.");
      }

      // MultipartRequest
      final request = http.MultipartRequest('PUT', uri);

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        ...(headers ?? {})
      });

      // Add all text fields properly
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add file
      if (fileBytes != null && fileFieldName != null) {
        final contentType = MediaType.parse(fileMimeType ?? 'image/jpeg');
        request.files.add(
          http.MultipartFile.fromBytes(
            fileFieldName,
            fileBytes,
            filename: fileName ?? 'upload.jpg',
            contentType: contentType,
          ),
        );
      }
      // Send multipart request
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      return _handleResponse(response);
    }

    // -----------------------
    // CASE 2: Normal JSON PUT
    // -----------------------
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...(headers ?? {})
      },
      body: json.encode(data ?? {}),
    );

    return _handleResponse(response);

  } catch (e) {
    return {
      "status": "failed",
      "message": "PUT request error: $e",
      "data": null
    };
  }
}


  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.delete(uri, headers: _buildHeaders(customHeaders: headers));
    return _handleResponse(response);
  }

  // Handle the HTTP response, including error parsing and status code checking
  static Map<String, dynamic> _handleResponse(http.Response response) {
    // Check for success status codes (200-299)
    if (response.statusCode < 200 || response.statusCode >= 300) {
      // --- Handle Error Response (Status 300+) ---
      try {
        final body = json.decode(response.body);

        if (body is Map<String, dynamic>) {
          // Attempt to extract FastAPI validation error message (status 422)
          if (body.containsKey('detail')) {
            final detail = body['detail'];
            if (detail is List && detail.isNotEmpty) {
              return {
                "status": "error",
                "message": detail[0]['msg'] ?? "Validation error",
                "statusCode": response.statusCode,
              };
            }
          }
          // Return the entire error body otherwise
          return {
            "status": "error",
            "message": "API Error (Status ${response.statusCode}): ${body['message'] ?? 'Unknown Error'}",
            "data": body,
            "statusCode": response.statusCode,
          };
        }
      } catch (_) {
        // If JSON decoding fails for an error response
        return {
          "status": "error",
          "message":
              "Request failed with status ${response.statusCode}. Failed to parse error response.",
          "statusCode": response.statusCode,
        };
      }
    }

    // --- Handle Success Response (Status 200-299) ---
    try {
      if (response.body.isEmpty) {
        return {"status": "success", "message": "No content", "statusCode": response.statusCode};
      }
      final body = json.decode(response.body);

      return body is Map<String, dynamic>
          ? body
          : {
              "status": "success",
              "message": "Successfully retrieved data",
              "data": body,
              "statusCode": response.statusCode,
            };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to parse successful response body: $e",
        "statusCode": response.statusCode,
      };
    }
  }


  // Helper method to make a MULTIPART POST request (for file uploads)
  static Future<Map<String, dynamic>> multipartPost(
    String endpoint, 
    Map<String, String> fields, 
    File? imageFile,
    String imageFieldName, 
    {Map<String, String>? headers}
    ) async {

    final uri = Uri.parse('$_baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // Add optional custom headers to the request
    request.headers.addAll(_buildHeaders(customHeaders: headers));

    // Add text fields
    request.fields.addAll(fields);

    // Add file
    if (imageFile != null) {
      // Detect MIME type using the 'mime' package
      final mimeType = lookupMimeType(imageFile.path); 
      final contentType = mimeType != null 
        ? MediaType.parse(mimeType) 
        : MediaType('image', 'jpeg'); // Fallback

      // Explicitly pass the contentType to the MultipartFile
      request.files.add(
        await http.MultipartFile.fromPath(
            imageFieldName, 
            imageFile.path,
            contentType: contentType, 
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }


  // Helper method for sending Form-Data (application/x-www-form-urlencoded)
  static Future<Map<String, dynamic>> postForm(
    String endpoint,
    Map<String, String> formData,
    {Map<String, String>? headers}
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        ...(headers ?? {})
      },
      body: formData,
    );

    return _handleResponse(response);
  }

}