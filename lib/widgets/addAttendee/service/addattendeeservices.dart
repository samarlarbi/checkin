import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class AddAttendeeService {
  final HttpClient api;

  AddAttendeeService() : api = HttpClient();

  Future<dynamic> addAttendee(attendee) async {
    try {
      print("service---$attendee");
      String endpoint = EndPoint.registration;
      var response = await api.post(endpoint, body: attendee);
      print("attendde-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching form: $e");
      throw Exception("Error adding attendee: $e");
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
      throw Exception("Error adding attendee: $e");
    }
  }
}
