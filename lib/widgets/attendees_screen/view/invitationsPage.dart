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
  String errorMessage = ""; // Track errors to display in UI
  Future<void>? futur;
  // Show an error dialog for permission requests
  @override
  void initState() {
    super.initState();
    futur = _refreshData();
  }

  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text(
            "Storage permission is required to export data. Please enable it in your device settings."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings to allow the user to change permissions
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> exportDataToCsv(List<Map<String, dynamic>> attendees) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();

      if (!status.isGranted) {
        // If permission is denied, show an error message
        _showPermissionDialog();
        return;
      }

      // Prepare CSV data
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

      // Loop through attendees and prepare CSV rows
      for (var attendee in attendees) {
        String workshopsAttended = attendee['ticket']['workshops']
            .where((w) => w['hasAttended'] == true)
            .map((w) => w['workshop']['name'])
            .join(', ');

        csvData.add([
          attendee['id'] ?? 'N/A',
          attendee['name'] ?? 'N/A',
          attendee['email'] ?? 'N/A',
          attendee['phone'] ?? 'N/A',
          attendee['studyLevel'] ?? 'N/A',
          attendee['specialization'] ?? 'N/A',
          attendee['fac']['name'] ?? 'N/A',
          attendee['team']['name'] ?? 'N/A',
          attendee['ticket']['ticketNo'] ?? 'N/A',
          attendee['ticket']['done'] ?? 'N/A',
          attendee['ticket']['hadMeal'] ?? 'N/A',
          workshopsAttended.isEmpty ? 'None' : workshopsAttended,
        ]);
      }

      // Convert to CSV format
      String csv = const ListToCsvConverter().convert(csvData);

      // Get the application documents directory path
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/attendees_data.csv'; // Save the file as attendees_data.csv
      final file = File(path);

      // Write the CSV data to the file
      await file.writeAsString(csv);

      // Confirm the file has been saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV exported to: $path')),
      );
    } catch (e) {
      // Handle any exceptions
      print('Error exporting data');
      setState(() {
        errorMessage = 'Error exporting data';
      });
    }
  }

  Future<void> fetchAttendees({String search = ""}) async {
    try {
      await _controller.fetchAttendees();

      setState(() {
        filteredAttendees = _controller.attendees;
        errorMessage =
            filteredAttendees.length == 0 ? "No attendees found" : "";
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch attendees';
      });
      return;
    }
  }

  Future<void> _refreshData() async {
    try {
      await fetchAttendees();
      print(_controller.attendees);
      setState(() {
        filteredAttendees = _controller.attendees;
        errorMessage =
            filteredAttendees.length == 0 ? "No attendees found" : "";
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Failed to refresh data';
      });
      return;
    }
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
              padding: EdgeInsets.only(bottom: 10, top: 20),
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
                          filteredAttendees =
                              _controller.attendees.where((attendee) {
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
                  "  " + _controller.totalItems.toString() + " attendees",
                  style: TextStyle(color: Primary, fontSize: 15),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Primary),
                  ),
                  onPressed: () {
                    if (filteredAttendees.isNotEmpty) {
                      exportDataToCsv(
                          filteredAttendees.cast<Map<String, dynamic>>());
                    } else {
                      setState(() {
                        errorMessage = 'No attendees available to export.';
                      });
                    }
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
            Expanded(
                child: RefreshIndicator(
              onRefresh: () {
                setState(() {
                  futur = _refreshData();
                });
                return futur ?? Future.value();
              },
              child: FutureBuilder(
                future: futur,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || errorMessage.isNotEmpty) {
                    return ListView(children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: const Color.fromARGB(255, 108, 106, 106),
                                size: 50),
                            const SizedBox(height: 10),
                            Text(
                              errorMessage.isNotEmpty
                                  ? errorMessage
                                  : 'Error: ${snapshot.error}',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 108, 106, 106),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ]);
                  } else {
                    return MyTable(tickets: filteredAttendees);
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
