// ignore_for_file: file_names

import 'dart:io';

import 'package:checkin/utils/table.dart';
import 'package:flutter/material.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  TextEditingController searchController = TextEditingController();

  final AttendeeController _controller = AttendeeController();
  int currentPage = 0;
  // FocusNode pour le champ de recherche :
  final FocusNode _focusNode = FocusNode();
  Future<void>? _checkinFuture;

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

  Future<void> exportDataToCsv(List<Map<String, dynamic>> attendees) async {
    List<List<dynamic>> csvData = [
      [
        'ID',
        'Name',
        'Email',
        'Phone',
        'Study Level',
        'Specialization',
        'Faculty',
        'Team',
        'Ticket No',
        'Done',
        'Had Meal',
        'Workshops Attended'
      ]
    ];

    for (var attendee in attendees) {
      String workshopsAttended = attendee['ticket']['workshops']
          .where((w) => w['hasAttended'] == true)
          .map((w) => w['workshop']['name'])
          .join(', ');

      csvData.add([
        attendee['id'],
        attendee['name'],
        attendee['email'],
        attendee['phone'],
        attendee['studyLevel'],
        attendee['specialization'],
        attendee['fac']['name'],
        attendee['team']['name'],
        attendee['ticket']['ticketNo'],
        attendee['ticket']['done'],
        attendee['ticket']['hadMeal'],
        workshopsAttended,
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print(' Storage permission denied');
      return;
    }

    // Get Downloads directory
    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      print(' Downloads folder not found');
      return;
    }

    // Save file in Downloads folder
    final path = '${downloadsDir.path}/attendees.csv';
    final file = File(path);
    await file.writeAsString(csv);

    print('CSV saved at: $path');
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
                    fetchAttendees(); // Requête par défaut si aucun texte
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  " + _controller.attendees.length.toString() + " attendees",
                  style: TextStyle(color: Primary, fontSize: 15),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Primary),
                    ),
                    onPressed: () {
                      exportDataToCsv(
                          _controller.attendees.cast<Map<String, dynamic>>());
                    },
                    child: Row(
                      children: [
                        Text("Export"),
                        SizedBox(width: 5),
                        Icon(Icons.file_download_outlined, size: 20)
                      ],
                    )),
              ],
            ),
            FutureBuilder(
              future: fetchAttendees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: MyTable(tickets: _controller.attendees)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
