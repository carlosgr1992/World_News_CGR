import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeData> {
  ThemeNotifier() : super(ThemeData.light());

  void toggleTheme() {
    value = value.brightness == Brightness.dark ? ThemeData.light() : ThemeData.dark();
  }
}
