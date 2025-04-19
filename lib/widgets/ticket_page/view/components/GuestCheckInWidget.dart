import 'dart:convert'; // Pour encoder et décoder JSON
import 'package:checkin/Api/EndPoint.dart';
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
ApiKey.token,        },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Color.fromARGB(153, 52, 52, 52),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  ElevatedButton(
                    onPressed: updateGuestCheckInStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCheckedIn == false
                          ? Color.fromRGBO(224, 89, 87, 1)
                          : const Color.fromARGB(255, 121, 201, 125),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            isCheckedIn == false ? "Unchecked" : "Check-In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            isCheckedIn == false
                                ? Icons.cancel
                                : Icons.check_circle,
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
