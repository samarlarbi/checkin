import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class AttendeeService {
  final HttpClient api;

  AttendeeService() : api = HttpClient();

  Future<Map<String, dynamic>> getAttendees({
    int page = 1,
    String search = "",
  }) async {
    try {
      String endpoint = EndPoint.getallAttendees;
      if (search.isNotEmpty) {
        endpoint += "/verify-ticketId/" + search;
      }
      print('******************');
      print(endpoint);
      // Fetch data from API
      var response = await api.get(endpoint, headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTIzNDU2Nzg5IiwiaWF0IjoxNzM5MzczODc5fQ.oeAh7EoHx3APxKhrk_mNxwwlCYFifidxcA9xogGDZFA",
        "Content-Type": "application/json"
      });

      // Return the list of attendees

      if (search.isNotEmpty) {
        Map<String, dynamic> p = {};

        p=response;
        return p;
      }

      if (response != null && response['data'] != null) {
       

        return response;
      } else {
        print("Error: Response does not contain 'data' key or is invalid");
        return {};
      }
    } catch (e) {
      print("Error fetching attendees: $e");
      return {};
    }
  }
}
