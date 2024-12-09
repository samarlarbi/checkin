import 'package:checkin/widgets/Scan_Page/view/ScanPage.dart';
import 'package:checkin/utils/navbar.dart';
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
        '/scan': (context) => Scanner_screen(),
      },
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
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
        Screen0: Scanner_screen(),
        Screen1: Text("s 1 "),
        Screen2: Text("s , 2 "),
      ),
    ));
  }
}
