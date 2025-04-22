import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';
import 'package:http/http.dart' as http;

class AttendeeService {
  final HttpClient api;

  AttendeeService() : api = HttpClient();

  Future<dynamic> search(String search) async {
    try {
      String endpoint = EndPoint.registration + '?search=' + search;
      print(endpoint);
      var response = await api.get(endpoint);

      if (response != null && response['data'] != null) {
        return response['data'];
      } else {
        print("Error: Response does not contain 'data' key or is invalid");
        throw Exception("! no data !");
      }
    } catch (e) {
      throw Exception(
          "! Serveur inaccessible. Vérifiez votre connexion !" + e.toString());
    }
  }

  Future<Map<String, dynamic>> getAttendees() async {
    try {
      String endpoint = EndPoint.getallAttendees;

      var response = await api.get(endpoint);

      if (response != null && response['data'] != null) {
        return response;
      } else {
        print("Error: Response does not contain 'data' key or is invalid");
        throw Exception("! no data !");
      }
    } catch (e) {
      throw Exception(
          "! Serveur inaccessible. Vérifiez votre connexion !" + e.toString());
    }
  }
}
