import 'dart:convert'; // For JSON decoding
import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/utils/tokenprovider.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static String baseUrl = EndPoint.baseUrl; // Replace with your API base URL.
  final int timeoutDuration = 15; // Timeout duration in seconds

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      var token = await AccessTokenProvider.getToken();
      final Uri url = Uri.parse('$baseUrl/$endpoint');
      print('$baseUrl/$endpoint');
      final response = await http.get(url, headers: {
        ...?headers,
        "Content-Type": "application/json",
        "Authorization": "Bearer " + (token ?? ''),
      }).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      print(e);
      rethrow; // Propagate the error for further handling
    }
  }

  // POST request
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, Object? body}) async {
    print(body);
    try {
      var token = await AccessTokenProvider.getToken();

      final Uri url = Uri.parse('$baseUrl/$endpoint');
      print(url);
      print(jsonEncode(body));
      final response = await http
          .post(url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + (token ?? ''),
              },
              body: jsonEncode(body))
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
      var token = await AccessTokenProvider.getToken();

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
      var token = await AccessTokenProvider.getToken();

      final Uri url = Uri.parse('$baseUrl/$endpoint');
      final response = await http
          .patch(url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + (token ?? ''),
              },
              body: jsonEncode(body))
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      rethrow; // Propagate the error for further handling
    }
  }

  // A helper function to handle the response
  dynamic _handleResponse(http.Response response) {
    // If the status code is 200, decode the JSON data.
    if (response.statusCode < 300) {
      try {
        return json.decode(response.body); // Assuming the response body is JSON
      } catch (e) {
        return response.body; // Return the raw body if JSON decoding fails
      }
    } else if (response.statusCode == 401) {
      // Handle unauthorized access (401)
      throw Exception('Unauthorized access. Please check your credentials.');
    } else if (response.statusCode == 403) {
      // Handle forbidden access (403)
      throw Exception(
          'Forbidden access. You do not have permission to access this resource.');
    } else if (response.statusCode == 404) {
      // Handle not found (404)
      throw Exception('Resource not found.');
    } else {
      // Handle other status codes (4xx, 5xx)
      throw Exception('Request failed with status: ${response.statusCode} ');
    }
  }
}
