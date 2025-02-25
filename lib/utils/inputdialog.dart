// ignore_for_file: prefer_const_constructors

import 'package:checkin/utils/searchField.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'myButton.dart';

class DialogButton extends StatelessWidget {
  final Function(String?) onpressed;
  final TextEditingController? controller;
  const DialogButton({super.key, required this.onpressed, this.controller});

  Future<String?> showInputDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Primary,
          title: Text(
            'Enter Ticket Code',
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter ticket code',
                suffixIcon: Icon(
                  Icons.search,
                  color: Primary,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Primary, width: 2),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                print(controller.text + "--------");
                onpressed(
                    controller.text); 
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onpressed: () async {
        String? result = await showInputDialog(context);
        if (result != null && result.isNotEmpty) {
          print('User input: $result');
        } else {
          print('Dialog dismissed or empty input');
        }
      },
      title: 'Enter Code',
      color: light,
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }
}
