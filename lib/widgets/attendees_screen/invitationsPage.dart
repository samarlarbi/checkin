import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/searchField.dart';
import 'package:checkin/utils/table.dart';
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  TextEditingController searchController = TextEditingController();
  final AttendeeController _controller = AttendeeController();
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

  Future<void> _fetchAttendee() async {
    await _controller.fetchAttendee();
    setState(() {});
    print(_controller.attendee);
  }

  @override
  Widget build(BuildContext context) {
    print("----------" + _controller.attendee.toString());

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
            _controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : _controller.errorMessage.isNotEmpty
                    ? Center(child: Text('Error: ${_controller.errorMessage}'))
                    : MyTable(tickets: _controller.attendee),
          ],
        ),
      ),
    );
  }
}
