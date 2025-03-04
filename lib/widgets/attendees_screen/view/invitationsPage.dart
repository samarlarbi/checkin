// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/utils/table.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  TextEditingController searchController = TextEditingController();
  final AttendeeController _controller = AttendeeController();
  final FocusNode _focusNode = FocusNode();
  List filteredAttendees = [];
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    fetchAttendees();
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
      print('Storage permission denied');
      return;
    }

    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      print('Downloads folder not found');
      return;
    }

    final path = '${downloadsDir.path}/attendees.csv';
    final file = File(path);
    await file.writeAsString(csv);

    print('CSV saved at: $path');
  }

  Future<void> fetchAttendees({String search = ""}) async {
    try {
      final response = await _controller.fetchAttendees(search: search);
      setState(() {
        filteredAttendees = _controller.attendees;
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  Future<void> _refreshData() async {
    fetchAttendees(search: searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "All Invitations",
        leading: false,
        action: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/addattendee");
            },
            icon: Icon(Icons.person_add_alt_1, color: Colors.grey),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              color: Background,
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Enter ticket code',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: _focusNode.hasFocus ? Primary : Colors.grey,
                    onPressed: () {
                      String query = searchController.text.trim();
                      setState(() {
                        if (query.isNotEmpty) {
                          filteredAttendees = _controller.attendees.where((attendee) {
                            return attendee['name'].contains(query) ||
                                   attendee['ticket']['ticketNo'].contains(query);
                          }).toList();
                        } else {
                          filteredAttendees = _controller.attendees;
                        }
                      });
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
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  " + _controller.totalItems.toString()+ " attendees",
                  style: TextStyle(color: Primary, fontSize: 15),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Primary),
                  ),
                  onPressed: () {
                    exportDataToCsv(filteredAttendees.cast<Map<String, dynamic>>());
                  },
                  child: Row(
                    children: [
                      Text("Export"),
                      SizedBox(width: 5),
                      Icon(Icons.file_download_outlined, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            RefreshIndicator(
              onRefresh: _refreshData,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: FutureBuilder(
                  future: _controller.fetchAttendees(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return MyTable(tickets: filteredAttendees);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
