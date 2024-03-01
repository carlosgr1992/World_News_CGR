import 'package:flutter/material.dart';
import 'dart:convert';


class ButtonBarCustom extends StatelessWidget {
  final VoidCallback onListPressed;
  final VoidCallback onGridPressed;

  ButtonBarCustom({required this.onListPressed, required this.onGridPressed});


  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: onListPressed,
          child: Text('Lista'),
        ),
        ElevatedButton(
          onPressed: onGridPressed,
          child: Text('Grid'),
        ),

      ],
    );
  }



}
