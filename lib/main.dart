import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/utils/navbar.dart';
import 'package:checkin/widgets/checked_invitations/view/checkedInvitaionsPage.dart';
import 'package:checkin/widgets/invitations_screen/invitationsPage.dart';
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
        '/scan': (context) => Scanner_screen(),
        '/invitations': (context) => Invitations(),
        '/ticket': (context) => MyTicketView(),
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
  var tickets = [
    {
      'number': 12345,
      'person': "kkkkkkk Salem",
      'type': 1,
      'paiment': true,
      'nbguest': 0,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": true
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'nbguest': 2,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": true
    },
    {
      'number': 12345,
      'nbguest': 2,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'type': 2,
      'nbguest': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'nbguest': 2,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'type': 2,
      'nbguest': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      'nbguest': 2,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'nbguest': 2,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'type': 2,
      'nbguest': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'person': "Ahmed Salem",
      'nbguest': 2,
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'nbguest': 2,
      'number': 12345,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": false
    },
    {
      'number': 12345,
      'nbguest': 2,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": true
    },
    {
      'number': 12345,
      'nbguest': 1,
      'person': "Ahmed Salem",
      'type': 2,
      'paiment': true,
      "checked": true
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Navbar(
        Screen0: Scanner_screen(),
        Screen1: Invitations(
          tickets: tickets,
        ),
        Screen2: CheckedInvitationsPage(
          tickets: tickets,
        ),
      ),
    ));
  }
}
