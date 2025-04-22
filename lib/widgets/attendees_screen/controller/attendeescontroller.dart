import '../service/attendeeservice.dart';

class AttendeeController {
  List attendees = [];
  List filterdattendee = [];
  int totalItems = 0;
  bool isLoading = false;
  String errorMessage = "";

  final AttendeeService attendeeService;

  AttendeeController() : attendeeService = AttendeeService();

  Future<void> searchAttendees(String search) async {
    try {
      isLoading = true;
      errorMessage = "";

      final response = await attendeeService.search(search);

      if (response is List) {
        // API is returning list directly
        filterdattendee = List.from(response);
        if (filterdattendee.isEmpty) {
          errorMessage = "No matching attendees found";
        }
      } else if (response is Map<String, dynamic>) {
        // Handle case where API returns wrapped response
        filterdattendee = List.from(response["data"] ?? []);
        if (filterdattendee.isEmpty) {
          errorMessage = "No matching attendees found";
        }
      } else {
        errorMessage = "Invalid server response format";
        filterdattendee = [];
      }
    } catch (e) {
      errorMessage = "Search error: ${e.toString()}";
      filterdattendee = [];
      print("Search error details: $e");
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchAttendees() async {
    try {
      isLoading = true;
      errorMessage = ""; // Reset error message

      final jsonData = await attendeeService.getAttendees();

      if (jsonData.isEmpty || jsonData["data"] == null) {
        errorMessage = "No attendees found";
        attendees = []; // Clear attendees list
        totalItems = 0;
        print(errorMessage);
        return;
      }

      attendees = List.from(jsonData["data"] ?? []);
      totalItems = jsonData["totalItems"] ?? 0;
    } catch (e) {
      errorMessage = "Error fetching attendees: ${e.toString()}";
      print(errorMessage);
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
