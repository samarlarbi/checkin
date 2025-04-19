import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/Scan_Page/scanner.dart';
import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/widgets/addAttendee/view/AddAttendeeView.dart';
import 'package:checkin/widgets/attendees_screen/view/invitationsPage.dart';
import 'package:checkin/widgets/statistics_Page/view/statisticsView.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/scanner': (context) => const ScannerScreen(),
        '/invitations': (context) => const Invitations(),
        '/statistics': (context) => const StaticsView(),
        '/addattendee': (context) => AddAttendeeView(),
        '/myTicketView': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>?;
          return MyTicketView(ticketno: args?['ticketno'] ?? '');
        }, 
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _activeIndex = 0;
  final List<Widget> _pages = [
    Invitations(),
    ScannerScreen(),
    StaticsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_activeIndex], // Display content based on selected tab
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(
            Icons.assignment,
            color: Colors.white,
            size: 25,
          ),
          Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.pie_chart_rounded,
            color: Colors.white,
            size: 25,
          ),
        ],
        inactiveIcons: const [
          Text("Attendees"),
          Text("Scanner"),
          Text("Statistics"),
        ],
        color: Colors.white,
        circleColor: Primary,
        height: 60,
        circleWidth: 60,
        shadowColor: Colors.grey,
        circleShadowColor: Colors.grey,
        elevation: 10,

        activeIndex: _activeIndex, // Dynamically change active index
        onTap: (index) {
          setState(() {
            _activeIndex = index; // Update the selected tab index
          });
        },
      ),
    );
  }
}
