import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';
import 'package:http/http.dart' as http;

class AttendeeService {
  final HttpClient api;

  AttendeeService() : api = HttpClient();

  Future<Map<String, dynamic>> getAttendees() async {
    try {
      String endpoint = EndPoint.getallAttendees;
      // if (search.isNotEmpty) {
      //   endpoint += "/verify-ticketId/" + search;
      // }

      // Fetch data from API
      var response = await api.get(endpoint);

      // Return the list of attendees

      // if (search.isNotEmpty) {
      //   Map<String, dynamic> p = {};

      //   p = response;
      //   return p;
      // }

      if (response != null && response['data'] != null) {
        return response;
      } else {
        print("Error: Response does not contain 'data' key or is invalid");
        throw Exception("! no data !");
      }
    } catch (e) {
      throw Exception("! Serveur inaccessible. Vérifiez votre connexion !" +e.toString());
    }
  }
}
