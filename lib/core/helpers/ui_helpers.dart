import 'package:flutter/material.dart';

class AppNav {
  AppNav._();

  static void push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
