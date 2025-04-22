import 'dart:async';
import 'dart:io';
import 'package:checkin/utils/tokenprovider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/utils/table.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';

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
  String errorMessage = "";
  Future<void>? futur;
  Timer? _refreshTimer; // Timer for auto-refresh

  @override
  void initState() {
    super.initState();
    futur = _refreshData();
    _startRefreshTimer(); // Start the auto-refresh timer
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Cancel the timer when widget is disposed
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String value) async {
    try {
      if (value.isEmpty) {
        setState(() {
          filteredAttendees = _controller.attendees;
          errorMessage = "";
        });
        return;
      }

      await _controller.searchAttendees(value);
      print("searching-----------------");
      setState(() {
        filteredAttendees = _controller.filterdattendee;
        errorMessage =
            filteredAttendees.isEmpty ? "No matching attendees found" : "";
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Search error: ${e.toString()}';
      });
    }
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          _refreshData(); // Refresh data every 30 seconds
        });
      }
    });
  }

  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text(
            "Storage permission is required to export data. Please enable it in your device settings."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }


Future<void> exportDataToCsv({
  required List<Map<String, dynamic>> attendees,
  required BuildContext context,
  bool openAfterSave = false,
}) async {
  try {
    // 1. Validate data
    if (attendees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No attendees to export')),
      );
      return;
    }

    // 2. Prepare CSV data
    final csvData = [
      [
        'ID', 'Name', 'Email', 'Phone', 'Study Level',
        'Specialization', 'Faculty', 'Team', 'Ticket No',
        'Done', 'Had Meal', 'Workshops Attended'
      ],
      ...attendees.map((attendee) {
        final workshops = ((attendee['ticket']?['workshops'] as List?) ?? [])
            .where((w) => w['hasAttended'] == true)
            .map((w) => w['workshop']?['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .join(', ');

        return [
          attendee['id']?.toString() ?? 'N/A',
          attendee['name']?.toString() ?? 'N/A',
          attendee['email']?.toString() ?? 'N/A',
          attendee['phone']?.toString() ?? 'N/A',
          attendee['studyLevel']?.toString() ?? 'N/A',
          attendee['specialization']?.toString() ?? 'N/A',
          attendee['fac']?['name']?.toString() ?? 'N/A',
          attendee['team']?['name']?.toString() ?? 'N/A',
          attendee['ticket']?['ticketNo']?.toString() ?? 'N/A',
          attendee['ticket']?['done']?.toString() ?? 'N/A',
          attendee['ticket']?['hadMeal']?.toString() ?? 'N/A',
          workshops.isEmpty ? 'None' : workshops,
        ];
      }),
    ];

    // 3. Get storage location
    String filePath;
    if (Platform.isAndroid) {
      // === Android: Save to Downloads folder ===
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission required')),
        );
        return;
      }

      Directory? downloadsDir;
      if (await Directory('/storage/emulated/0/Download').exists()) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getExternalStorageDirectory();
      }

      final saveDir = Directory('${downloadsDir!.path}/MyAppExports');
      if (!await saveDir.exists()) await saveDir.create();

      filePath = '${saveDir.path}/attendees_${DateTime.now().millisecondsSinceEpoch}.csv';
    } else {
      // === iOS/Desktop: Save to app directory ===
      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/attendees_${DateTime.now().millisecondsSinceEpoch}.csv';
    }

    // 4. Write file
    await File(filePath).writeAsString(const ListToCsvConverter().convert(csvData));

    // 5. User feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File saved: ${filePath.split('/').last}')),
    );


  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export failed: ${e.toString()}')),
    );
  }
}
  Future<void> fetchAttendees({String search = ""}) async {
    try {
      await _controller.fetchAttendees();

      setState(() {
        filteredAttendees = _controller.attendees;
        errorMessage = filteredAttendees.isEmpty ? "No attendees found" : "";
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch attendees: ${e.toString()}';
      });
    }
  }

  Future<void> _refreshData() async {
    try {
      await fetchAttendees();
      setState(() {
        filteredAttendees = _controller.attendees;
        errorMessage = filteredAttendees.isEmpty ? "No attendees found" : "";
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to refresh data: ${e.toString()}';
      });
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you sure you want to logout?"),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('yess'),
              onPressed: () {
                Logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Logout(BuildContext context) async {
    try {
      await Provider.of<AccessTokenProvider>(context, listen: false)
          .clearTokens();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Attendees",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: Image.asset(
          "assets/mic.png",
          height: 50,
        ),
        actions: [
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout , color: Colors.black),
            onPressed: () {
              _showErrorDialog(context, "Are you sure you want to logout?");
            },
          ),
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
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Enter ticket code',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              filteredAttendees = _controller.attendees;
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(Icons.search),
                        color: _focusNode.hasFocus ? Primary : Colors.grey,
                        onPressed: () {
                          _focusNode.unfocus();
                        },
                      ),
                    ],
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
    attendees:  filteredAttendees.cast<Map<String, dynamic>>(),
    context: context,
    openAfterSave: true, // Auto-open file on Android
  );} else {
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
                _refreshTimer?.cancel(); // Cancel current timer
                setState(() {
                  futur = _refreshData();
                });
                _startRefreshTimer(); // Restart timer
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
