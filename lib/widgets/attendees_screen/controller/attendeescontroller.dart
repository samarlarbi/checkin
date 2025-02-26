
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

      print("Fetched JSON data: $jsonData");

      if (jsonData.isEmpty) {
        print("No more attendees found. Current attendees list: $attendees");
      } else {
        attendees = jsonData.toList();

        print("Updated attendees list: $attendees");

      }
    } catch (e) {
      errorMessage = "Error fetching data: $e";
      print(errorMessage);
    }

    isLoading = false;
  }
}
