import 'dart:async';
import 'package:blobs/blobs.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/utils/inputdialog.dart';
import 'package:checkin/utils/myButton.dart';
import 'package:checkin/widgets/Scan_Page/controller/checkincontroller.dart';
import 'package:checkin/widgets/Scan_Page/scanner.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../ticket_page/view/ticketPage.dart';

class Scanner_screen extends StatefulWidget {
  const Scanner_screen({super.key});

  @override
  State<Scanner_screen> createState() => _Scanner_screenState();
}

class _Scanner_screenState extends State<Scanner_screen> {
  String _scanBarcode = 'Unknown';
  String barcodeScanRes = "";
  String code = "";
  TextEditingController controller = TextEditingController();

  final CheckinController _controller = CheckinController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchAttendee(code) async {
    await _controller.fetchCheckin(code);
    setState(() {});
    print("****************************" + _controller.attendee.toString());

    if (_controller.attendee.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Checkin'),
            content: Text('Checkin failed'),
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
                  color: const Color.fromARGB(255, 69, 69, 69)))
        ],
        title: Text(
          "Scan QR code",
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
              Stack(alignment: Alignment.center, children: [
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
              ]),
              MyButton(
                title: "scan QR code",
                onpressed: () {
                  scanQR();
                },
                color: Primary,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(
                height: 10,
              ),
              DialogButton(
                onpressed: (input) async {
                  print(input);
                  await _fetchAttendee(input); // Fetch attendee with input code
                },
                controller: controller,
              )
            ],
          ),
        ),
      ),
    );
  }
}
