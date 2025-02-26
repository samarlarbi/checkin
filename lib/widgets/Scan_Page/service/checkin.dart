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

import '../../../Api/EndPoint.dart';

class AttendeeCheckinService {
  final String token;

  AttendeeCheckinService({required this.token});
  
  get api => null;

   Future<Map<String, dynamic>> getTiketbyQRcode(qrcode) async {
    try {
      String endpoint = EndPoint.getticketbyqrcode + "/" + qrcode;
      final response = await api.get(endpoint);
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }
}
