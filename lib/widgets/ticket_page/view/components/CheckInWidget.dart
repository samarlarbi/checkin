import 'dart:convert'; // Nécessaire pour encoder en JSON
import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/utils/colors.dart';
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
ApiKey.token,        },
        body: json.encode({
          "ticketId": widget.ticketId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isCheckedIn = !isCheckedIn; // Inverser le statut local
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Check-in status updated successfully!"),
            backgroundColor: Primary,
          ),
        );
      } else {
        throw Exception(
            "Failed to update check-in status. Status code: ${response.statusCode}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error updating check-in status: $error",
          ),
          backgroundColor: Primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = isCheckedIn == false
        ? Color.fromRGBO(224, 89, 87, 1)
        : const Color.fromARGB(255, 121, 201, 125);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                isCheckedIn ? 'Yes' : 'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isCheckedIn
                      ? const Color.fromARGB(255, 121, 201, 125)
                      : Color.fromRGBO(224, 89, 87, 1),
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
              fixedSize: Size.fromWidth(
                MediaQuery.of(context).size.width * 0.7,
              ),
              backgroundColor: isCheckedIn == false
                  ? Color.fromRGBO(224, 89, 87, 1)
                  : const Color.fromARGB(255, 121, 201, 125),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              isCheckedIn == false ? "Unchecked" : "Checked-In",
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
