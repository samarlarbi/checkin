import 'dart:convert';
import 'package:checkin/widgets/attendees_screen/models/Attendee.dart';
import 'package:http/http.dart' as http;

class AttendeeController {
  List<Attendee> attendee = [];
  bool isLoading = false;
  String errorMessage = "";

  final int pageSize = 10; // Number of attendees per page

  Future<void> fetchAttendee() async {
    isLoading = true;
    errorMessage = "";
    int currentPage = 1; // Start at page 1
    bool hasMoreData = true;

    try {
      // Fetch all pages in a loop
      while (hasMoreData) {
        final response = await http.get(
          Uri.parse(
              'https://ceremony-backend-to-deploy.onrender.com/api/v1/registration?currentPage=$currentPage&sizePerPage=$pageSize'),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg"
          },
        );

        if (response.statusCode == 200) {
          print("Response status code: ${response.statusCode}");
          List jsonData = json.decode(response.body)['data'];

          // Process the data before mapping
          List processedData = jsonData.map((e) {
            // Replace null values before mapping
            e['ticket']['justification'] = e['ticket']['justification'] ??
                ''; // Replace null with an empty string
            return e;
          }).toList();

          // If no more data is returned, exit the loop
          if (processedData.isEmpty) {
            hasMoreData = false;
          } else {
            // Add the new attendees to the existing list
            attendee.addAll(
                processedData.map((e) => Attendee.fromJson(e)).toList());
            currentPage++; // Move to the next page
          }
        } else {
          errorMessage = "Failed to load data.";
          hasMoreData = false; // Stop fetching on error
        }
      }
    } catch (e) {
      errorMessage = "Error fetching data: $e";
    }

    isLoading = false;
  }
}
