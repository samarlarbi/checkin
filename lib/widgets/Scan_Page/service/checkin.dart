// import 'package:checkin/Api/EndPoint.dart';
// import 'package:checkin/Api/httpClient.dart';

// class AttendeeCheckinService {
//   final HttpClient api;

//   AttendeeCheckinService(this.api);

//   Future<Map<String, dynamic>> checkin(ticketId) async {
//     try {
//       final response = await api.put('${EndPoint.checkbycodeticket}/$ticketId');

//       if (response != null && response['attendee'] != null) {
//         print("******* ${response['attendee']}");
//         return Map<String, dynamic>.from(response['attendee']);
//       } else {
//         print("Error: Response does not contain 'attendees' key or is invalid");
//         return {};
//       }
//     } catch (e) {
//       print("Error fetching checked invitations: $e");
//       return {};
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendeeCheckinService {
  final String token;

  AttendeeCheckinService({required this.token});

  Future<Map<String, dynamic>> verifyQRCode(String data) async {
    final url = Uri.parse(
        "https://ceremony-backend-to-deploy.onrender.com/api/v1/registration/verify-qrcode/$data");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Handle different HTTP status codes
      if (response.statusCode == 200) {
        // Successfully verified the QR code
        try {
          // Decode the response body
          print("Response body: ${response.body}");
          return json.decode(response.body);
        } catch (e) {
          // Handle JSON parsing errors
          return {
            "error": "Failed to parse response body. Please try again later."
          };
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client-side error (e.g., bad request, unauthorized)
        return {
          "error":
              "Client error: Status code ${response.statusCode}. Please check your request."
        };
      } else if (response.statusCode >= 500) {
        // Server-side error (e.g., internal server error)
        return {
          "error":
              "Server error: Status code ${response.statusCode}. Please try again later."
        };
      } else {
        // Unexpected status code
        return {
          "error":
              "Unexpected error: Status code ${response.statusCode}. Please try again."
        };
      }
    } catch (e) {
      // Handle network or unexpected errors
      return {
        "error":
            "Network error: Unable to connect to the server. Please check your internet connection."
      };
    }
  }
}
