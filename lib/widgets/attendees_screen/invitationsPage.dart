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
  int currentPage = 1;
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
    await _controller.fetchAttendee(page: currentPage);
    setState(() {
      isLoading = false;
    });
  }

  // Fonction pour changer la page
  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
    _fetchAttendee();
  }

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
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: currentPage > 1
                                  ? () => _changePage(currentPage - 1)
                                  : null,
                            ),
                            // Affichage des numéros de pages
                            Text(
                              'Page $currentPage',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () => _changePage(currentPage + 1),
                            ),
                          ],
                        ),
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
