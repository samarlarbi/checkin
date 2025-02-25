import 'package:flutter/material.dart';
import '../../../utils/MyAppBar.dart';
import '../../../utils/colors.dart';
import '../../../utils/searchField.dart';
import '../../../utils/table.dart';
import '../../attendees_screen/controller/attendeescontroller.dart'; // Assuming your table widget is here

class StaticsView extends StatefulWidget {
  const StaticsView({super.key});

  @override
  _StaticsViewState createState() => _StaticsViewState();
}

class _StaticsViewState extends State<StaticsView> {
  final AttendeeController _controller = AttendeeController();

  Future<void> _refreshData() async {
    await _controller.fetchAttendees();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "Statics",
        leading: false,
      ),
    );
  }
}
