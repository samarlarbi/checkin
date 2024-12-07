import 'package:blobs/blobs.dart';
import 'package:checkin/colors.dart';
import 'package:checkin/widgets/myButton.dart';
import 'package:flutter/material.dart';

class Scanner_screen extends StatelessWidget {
  const Scanner_screen({super.key});

  @override
  Widget build(BuildContext context) {
    BlobController blobCtrl = BlobController();

    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        title: Text("Scan QR code"),
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
                    styles: BlobStyles(color: Primary.withOpacity(0.2)),
                    size: 350,
                    id: ['10-4-0952400'],
                    controller: blobCtrl,
                  ),
                ),
                Image.network(
                    cacheHeight: 350,
                    'https://budgetcoinz.com/wp-content/uploads/2022/11/QR-Code-Generator.png')
              ]),
              MyButton(
                title: "scan QR code",
                color: Primary,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                title: "scan QR code",
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
