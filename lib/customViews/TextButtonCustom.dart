import 'package:flutter/material.dart';

class TextButtonCustom extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  TextButtonCustom({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFFBAF9FF)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent.withOpacity(0.1)),
        side: MaterialStateProperty.all(BorderSide(color: Colors.lightBlueAccent)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
