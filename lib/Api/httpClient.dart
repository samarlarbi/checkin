import 'dart:convert'; // For JSON decoding
import 'package:checkin/Api/EndPoint.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static const String baseUrl =
      EndPoint.baseUrl; // Replace with your API base URL.
  final int timeoutDuration = 15; // Timeout duration in seconds

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(url, headers: {
        ...?headers,
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTIzNDU2Nzg5IiwiaWF0IjoxNzM5MzczODc5fQ.oeAh7EoHx3APxKhrk_mNxwwlCYFifidxcA9xogGDZFA",
      }).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  // POST request
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http
          .put(url, headers: headers, body: body)
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http
          .delete(url, headers: headers, body: body)
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  // PATCH request
  Future<dynamic> patch(String endpoint,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http
          .patch(url,
              headers: {
                ...?headers,
                "Authorization":
                    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTIzNDU2Nzg5IiwiaWF0IjoxNzM5MzczODc5fQ.oeAh7EoHx3APxKhrk_mNxwwlCYFifidxcA9xogGDZFA",
              },
              body: body)
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  // A helper function to handle the response
  dynamic _handleResponse(http.Response response) {
    // If the status code is 200, decode the JSON data.
    if (response.statusCode == 200) {
      try {
        return json.decode(response.body); // Assuming the response body is JSON
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      // Handle other status codes (4xx, 5xx)
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
