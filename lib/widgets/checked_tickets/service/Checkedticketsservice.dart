import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class CheckedTicketsService {
  final HttpClient api;

  CheckedTicketsService(this.api);

  Future<List<Map<String, dynamic>>> getCheckedTickets() async {
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
