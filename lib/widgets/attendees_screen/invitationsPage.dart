import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/searchField.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/attendees_screen/models/Attendee.dart';

import '../../utils/table.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  TextEditingController searchController = TextEditingController();
  final AttendeeController _controller = AttendeeController();
  bool isLoading = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendee();
  }

  // Fonction pour charger les invités de la page donnée
  Future<void> _fetchAttendee() async {
    setState(() {
      isLoading = true;
    });
    await _controller.fetchAttendee();
    setState(() {
      isLoading = false;
    });
  }

  // Fonction pour changer la page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "All Invitations",
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SearchField(),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              color: Background,
              child: Text(
                _controller.attendee.length == 0
                    ? "No Invitations"
                    : _controller.attendee.length.toString() + " Invitations",
                style: TextStyle(
                  color: Primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            isLoading
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Primary,
                    )),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        // Affichage des invités
                        MyTable(tickets: _controller.attendee)

                        // Pagination
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
