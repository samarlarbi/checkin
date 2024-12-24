import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/utils/navbar.dart';
import 'package:checkin/widgets/checked_tickets/view/checkedTicketsPage.dart';
import 'package:checkin/widgets/attendees_screen/invitationsPage.dart';
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
      "idticket": 12345,
      "typeticket": 3,
      "nbguests": 2,
      "attende": "John Doe",
      "date": "5-1-2024",
      "checkguests": 1,
      "email": "johndoe@example.com",
      "phone": "1234567890",
      "check": true
    },
    {
      "idticket": 23456,
      "typeticket": 1,
      "nbguests": 4,
      "attende": "Alice Smith",
      "date": "10-1-2024",
      "checkguests": 3,
      "email": "alice.smith@example.com",
      "phone": "9876543210",
      "check": false
    },
    {
      "idticket": 34567,
      "typeticket": 2,
      "nbguests": 1,
      "attende": "Bob Johnson",
      "date": "15-1-2024",
      "checkguests": 0,
      "email": "bob.johnson@example.com",
      "phone": "5558887777",
      "check": true
    },
    {
      "idticket": 45678,
      "typeticket": 4,
      "nbguests": 3,
      "attende": "Charlie Brown",
      "date": "20-1-2024",
      "checkguests": 2,
      "email": "charlie.brown@example.com",
      "phone": "4443332222",
      "check": false
    },
    {
      "idticket": 56789,
      "typeticket": 2,
      "nbguests": 5,
      "attende": "Emma Wilson",
      "date": "25-1-2024",
      "checkguests": 4,
      "email": "emma.wilson@example.com",
      "phone": "2223334444",
      "check": true
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Navbar(
        Screen0: Scanner_screen(),
        Screen1: Invitations(),
        Screen2: CheckedTicketsPage(),
      ),
    ));
  }
}
