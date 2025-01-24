import 'dart:convert';
import 'package:checkin/widgets/attendees_screen/models/Attendee.dart';
import 'package:http/http.dart' as http;

class AttendeeController {
  List<Attendee> attendee = [];
  bool isLoading = false;
  String errorMessage = "";

  final int pageSize = 10; // Nombre d'invités à afficher par page

  Future<void> fetchAttendee({required int page}) async {
    isLoading = true;
    errorMessage = "";

    try {
      final response = await http.get(
        Uri.parse(
            'https://ceremony-backend-to-deploy.onrender.com/api/v1/registration?currentPage=$page&sizePerPage=$pageSize'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg"
        },
      );

      if (response.statusCode == 200) {
        print("Response status code: ${response.statusCode}");
        List jsonData = json.decode(response.body)['data'];

        // Traitement des données avant de les mapper
        List processedData = jsonData.map((e) {
          // Remplacer les valeurs null avant de mapper les données
          e['ticket']['justification'] = e['ticket']['justification'] ??
              ''; // Remplacer null par une chaîne vide
          return e;
        }).toList();

        if (page == 1) {
          attendee = processedData.map((e) => Attendee.fromJson(e)).toList();
          print("----------------------------" + attendee.toString());
        } else {
          attendee
              .addAll(processedData.map((e) => Attendee.fromJson(e)).toList());
        }
      } else {
        errorMessage = "Failed to load data.";
      }
    } catch (e) {
      errorMessage = "Error fetching data: $e";
    }

    isLoading = false;
  }
}
