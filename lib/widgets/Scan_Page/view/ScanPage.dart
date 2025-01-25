import 'dart:async';
import 'package:blobs/blobs.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/utils/inputdialog.dart';
import 'package:checkin/utils/myButton.dart';
import 'package:checkin/widgets/Scan_Page/controller/checkincontroller.dart';
import 'package:checkin/widgets/Scan_Page/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../ticket_page/view/ticketPage.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _scanBarcode = 'Unknown';
  String barcodeScanRes = "";
  TextEditingController controller = TextEditingController();

  // Ensure to pass a token here
  final CheckinController _controller = CheckinController(
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchAttendee(String code) async {
    print(
        "--------------------------------------------- \n Fetching attendee with code: $code");
    await _controller.fetchCheckin(code);
    setState(() {});

    if (_controller.attendee.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Check-in Failed'),
            content: Text('Check-in failed for code: $code'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Display more useful attendee information in the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Check-in Success'),
            content: Text('Attendee: ${_controller.attendee['name']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyTicketView(ticket: _controller.attendee)),
      );
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRess;
    try {
      print("-----------------------------------------------");
      barcodeScanRess = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        barcodeScanRes = barcodeScanRess;
      });
      if (barcodeScanRes != "-1") {
        await _fetchAttendee(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to scan barcode. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    BlobController blobCtrl = BlobController();

    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined,
                color: const Color.fromARGB(255, 69, 69, 69)),
          )
        ],
        title: Text(
          "Scan QR Code",
          style: TextStyle(color: const Color.fromARGB(255, 69, 69, 69)),
        ),
        centerTitle: true,
        backgroundColor: Background,
        elevation: 0,
      ),
      body: Container(
        color: Background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: Blob.fromID(
                      styles:
                          BlobStyles(color: Color.fromARGB(255, 204, 228, 228)),
                      size: MediaQuery.of(context).size.width * 0.8,
                      id: ['10-4-0952400'],
                      controller: blobCtrl,
                    ),
                  ),
                  Image.asset(
                      width: MediaQuery.of(context).size.width * 0.8,
                      "assets/homeimge.png")
                ],
              ),
              MyButton(
                title: "Scan QR Code",
                onpressed: () {
                  scanQR();
                },
                color: Primary,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
