import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/utils/navbar.dart';
import 'package:checkin/widgets/checked_tickets/view/checkedTicketsPage.dart';
import 'package:checkin/widgets/attendees_screen/invitationsPage.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const   MyApp());
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
        Screen2: CheckedTicketsPage(),
      ),
    ));
  }
}
