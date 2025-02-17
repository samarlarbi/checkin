import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class AttendeeService {
  final HttpClient api;

  AttendeeService() : api = HttpClient();

  // Fetch attendees with optional pagination and search query
  Future<List<Map<String, dynamic>>> getAttendees({
    int page = 1,
    String search = "",
  }) async {
    try {
      // Construct the endpoint URL with pagination and search support
      String endpoint = EndPoint.getallAttendees;
      if (search.isNotEmpty) {
        endpoint += "&search=$search";
      }

      // Fetch data from API
      var response = await api.get(endpoint, headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTIzNDU2Nzg5IiwiaWF0IjoxNzM5MzczODc5fQ.oeAh7EoHx3APxKhrk_mNxwwlCYFifidxcA9xogGDZFA",
        "Content-Type": "application/json"
      });

      // Debugging output

      // Return the list of attendees
      if (response != null && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        print("Error: Response does not contain 'data' key or is invalid");
        return [];
      }
    } catch (e) {
      print("Error fetching attendees: $e");
      return [];
    }
  }
}
