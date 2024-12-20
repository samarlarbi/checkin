import 'dart:async';
import 'package:blobs/blobs.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/utils/myButton.dart';
import 'package:checkin/widgets/Scan_Page/scanner.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner_screen extends StatefulWidget {
  const Scanner_screen({super.key});

  @override
  State<Scanner_screen> createState() => _Scanner_screenState();
}

class _Scanner_screenState extends State<Scanner_screen> {
  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
                Image.network(
                    cacheHeight:
                        (MediaQuery.of(context).size.width * 0.8).round(),
                    cacheWidth:
                        (MediaQuery.of(context).size.width * 0.8).round(),
                    'https://budgetcoinz.com/wp-content/uploads/2022/11/QR-Code-Generator.png')
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
              MyButton(
                title: "Enter code",
                color: light,
                width: MediaQuery.of(context).size.width * 0.7,
              )
            ],
          ),
        ),
      ),
    );
  }
}
