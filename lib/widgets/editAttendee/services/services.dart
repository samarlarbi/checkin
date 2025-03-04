import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';
import 'package:checkin/models/attendee.dart';

class EditAttendeeServices {
  final HttpClient api;
  final ticketno;

  EditAttendeeServices(this.ticketno) : api = HttpClient();

  
  Future<Map<String, dynamic>> editAttendee( body) async {
    try {
      String endpoint = EndPoint.registration;
      final response = await api.patch(endpoint, body: body);
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }


  Future<Map<String, dynamic>> getTiketbyTicketno(ticketno) async {
    try {
      String endpoint = EndPoint.getticketbyticketno + "/" + ticketno;
      final response = await api.get(endpoint);
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> getFrom() async {
    try {
      String endpoint = EndPoint.getform;
      final response = await api.get(endpoint);
      print("form-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching form: $e");
      return {};
    }
  }
}
