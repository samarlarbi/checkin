import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onpressed;
  final String title;

  final Color color;

  final double width;
  const MyButton(
      {super.key,
      this.onpressed,
      required this.title,
      required this.color,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      
      style: ButtonStyle(
        alignment: Alignment.center,
      
        fixedSize: MaterialStateProperty.all<Size>(Size(width, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      ),
    );
  }
}
