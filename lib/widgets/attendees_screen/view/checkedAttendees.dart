// ignore_for_file: file_names

import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/utils/table.dart';
import 'package:flutter/material.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';

class ChecketAttendees extends StatefulWidget {
  const ChecketAttendees({super.key});

  @override
  State<ChecketAttendees> createState() => _ChecketAttendeesState();
}

class _ChecketAttendeesState extends State<ChecketAttendees> {
  TextEditingController searchController = TextEditingController();

  final AttendeeController _controller = AttendeeController();
  int currentPage = 0;
  // FocusNode pour le champ de recherche :
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  fetchAttendees({String search = ""}) async {
    try {
      final response = await _controller.fetchAttendees(search: search);
      print("response:**** " + _controller.attendees.toString());
      return response;
    } catch (e) {
      print("Erreur: $e");
    } finally {}
  }

  Future<void> _refreshData() async {
    fetchAttendees(search: searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: const MyAppBar(
        title: "All Invitations",
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            // Champ de recherche
            Container(
              color: Background,
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: TextField(
                controller: searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter ticket code',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: _focusNode.hasFocus ? Primary : Colors.grey,
                    onPressed: () {
                      // Lancer la recherche uniquement si le champ n'est pas vide
                      if (searchController.text.trim().isNotEmpty) {
                        fetchAttendees(search: searchController.text.trim());
                      } else {
                        fetchAttendees(); // Requête par défaut si aucun texte
                      }
                    },
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Primary, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  // Lancer la recherche uniquement si le champ n'est pas vide
                  if (searchController.text.trim().isNotEmpty) {
                    fetchAttendees(search: searchController.text.trim());
                  } else {
                    fetchAttendees(); 
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: fetchAttendees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final checkedAttendees = _controller.attendees
                      .where((attendee) =>
                          attendee[ApiKey.ticket][ApiKey.checked] == true)
                      .toList();
                  return RefreshIndicator(
                      onRefresh: _refreshData,
                      child:
                          Container(child: MyTable(tickets: checkedAttendees)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
