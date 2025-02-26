import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/utils/navbar.dart';
import 'package:checkin/widgets/addAttendee/view/AddAttendeeView.dart';
import 'package:checkin/widgets/attendees_screen/view/checkedAttendees.dart';
import 'package:checkin/widgets/attendees_screen/view/invitationsPage.dart';
import 'package:checkin/widgets/statics_screen/view/staticsView.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MyHomePage(),
        '/scan': (context) => ScannerScreen(),
        '/invitations': (context) => Invitations(),
        '/ticket': (context) => MyTicketView(),
        '/addattendee': (context) => AddAttendeeView()
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page_index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Navbar(
        Screen0: ScannerScreen(),
        Screen1: Invitations(),
        Screen2: StaticsView(),
      ),
    ));
  }
}
