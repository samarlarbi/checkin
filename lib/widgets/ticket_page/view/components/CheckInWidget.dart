import 'dart:convert'; // Nécessaire pour encoder en JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckInWidget extends StatefulWidget {
  final String ticketId;
  final bool initialStatus;

  const CheckInWidget({
    Key? key,
    required this.ticketId,
    required this.initialStatus,
  }) : super(key: key);

  @override
  _CheckInWidgetState createState() => _CheckInWidgetState();
}

class _CheckInWidgetState extends State<CheckInWidget> {
  late bool isCheckedIn;

  @override
  void initState() {
    super.initState();
    isCheckedIn = widget.initialStatus; // Initialiser le statut
  }

  Future<void> updateCheckInStatus() async {
    final url = Uri.parse(
        "https://ceremony-backend-to-deploy.onrender.com/api/v1/registration/confirm-general-checkin");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg"
        },
        body: json.encode({
          "ticketId": widget.ticketId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isCheckedIn = !isCheckedIn; // Inverser le statut local
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-in status updated successfully!")),
        );
      } else {
        throw Exception(
            "Failed to update check-in status. Status code: ${response.statusCode}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating check-in status: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = isCheckedIn == true ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "AttendeeChecked-In :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isCheckedIn ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isCheckedIn ? 'Yes' : 'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isCheckedIn ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Center(
          child: ElevatedButton(
            onPressed: updateCheckInStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCheckedIn ? Colors.red[600] : Colors.green[600],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isCheckedIn ? "Undo Check-In" : "Confirm Check-In",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
