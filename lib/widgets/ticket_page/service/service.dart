import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class GuestCheckinService {
  final HttpClient api;

  GuestCheckinService(this.api);

  Future<Map<String, dynamic>> checkin(attendeeid) async {
    try {
      final response = await api.put('${EndPoint.checkinguest}/$attendeeid');

      if (response != null && response['attendee'] != null) {
        print("******* ${response['attendee']}");
        return Map<String, dynamic>.from(response['attendee']);
      } else {
        print("Error: Response does not contain 'Guests' key or is invalid");
        return {};
      }
    } catch (e) {
      print("Error fetching checked invitations: $e");
      return {};
    }
  }
}
