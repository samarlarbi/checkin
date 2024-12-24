import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class AttendeeService {
  final HttpClient api;

  AttendeeService(this.api);

  Future<List<Map<String, dynamic>>> getAttendees() async {
    try {
      var response = await api.get(EndPoint.getallAttendees);
      print("*******" + response['attendees'].toString());
      if (response != null && response['attendees'] != null) {
        return List<Map<String, dynamic>>.from(response['attendees']);
      } else {
        print("Error: Response does not contain 'attendees' key or is invalid");
        return [];
      }
    } catch (e) {
      print("Error fetching checked invitations: $e");
      return [];
    }
  }
}
