import 'package:checkin/widgets/attendees_screen/models/Attendee.dart';
import 'package:checkin/Api/httpClient.dart';
import 'package:checkin/Api/EndPoint.dart';
import '../service/attendeeservice.dart';

class AttendeeController {
  List attendees = [];
  bool isLoading = false;
  String errorMessage = "";

  final AttendeeService attendeeService;

  AttendeeController() : attendeeService = AttendeeService();
// get  all attendees or search by name
  Future<void> fetchAttendees({String search = ""}) async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = "";

    try {
      // Fetch data from the service
      List<Map<String, dynamic>> jsonData =
          await attendeeService.getAttendees(search: search);

      // Debugging: Print fetched data from the API
      print("Fetched JSON data: $jsonData");

      if (jsonData.isEmpty) {
        print("No more attendees found. Current attendees list: $attendees");
      } else {
        // Add the fetched attendees to the list
        attendees = jsonData.toList();

        // Debugging: Print the updated list of attendees
        print("Updated attendees list: $attendees");

        // Increment the current page for next fetch
      }
    } catch (e) {
      errorMessage = "Error fetching data: $e";
      print(errorMessage);
    }

    isLoading = false;
  }
}
