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
                onpressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(
                                  leading: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.arrow_back))))));
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
