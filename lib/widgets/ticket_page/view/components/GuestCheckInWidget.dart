import 'dart:convert'; // Pour encoder et décoder JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuestCheckInWidget extends StatefulWidget {
  final Map<String, dynamic> relative; // Détails d'un invité
  const GuestCheckInWidget({Key? key, required this.relative})
      : super(key: key);

  @override
  _GuestCheckInWidgetState createState() => _GuestCheckInWidgetState();
}

class _GuestCheckInWidgetState extends State<GuestCheckInWidget> {
  late bool isCheckedIn;

  @override
  void initState() {
    super.initState();
    isCheckedIn = widget.relative['isCheckedIn']; // Initialiser le statut
  }

  Future<void> updateGuestCheckInStatus() async {
    final url = Uri.parse(
        "https://ceremony-backend-to-deploy.onrender.com/api/v1/registration/confirm-general-checkin/${widget.relative['id']}");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg"
        },
        body: json.encode({
          "relativeId": widget.relative['id'],
          "isCheckedIn": !isCheckedIn, // Basculer le statut actuel
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isCheckedIn = !isCheckedIn; // Mettre à jour le statut local
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Guest check-in status updated successfully!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        );
      } else {
        throw Exception(
            "Failed to update guest check-in status. Status code: ${response.statusCode}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error updating guest check-in status: $error",
            style: TextStyle(fontSize: 14),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Color.fromARGB(153, 52, 52, 52),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne pour le nom
            Text(
              widget.relative['name'], // Afficher le nom
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),

            // Ligne pour le statut "Checked-In"
            Text(
              "Checked-In: ${isCheckedIn ? 'Yes' : 'No'}", // Afficher le statut
              style: TextStyle(
                fontSize: 14,
                color: isCheckedIn ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            // Ligne pour le bouton
            ElevatedButton(
              onPressed: updateGuestCheckInStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isCheckedIn ? Colors.red[600] : Colors.green[600],
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isCheckedIn ? "Undo Check-In" : "Confirm Check-In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 18),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        isCheckedIn ? Colors.red[100] : Colors.green[100],
                    child: Icon(
                      isCheckedIn ? Icons.cancel : Icons.check_circle,
                      size: 30,
                      color: isCheckedIn ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
