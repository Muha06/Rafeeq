import 'package:flutter/material.dart';
 
class AppNav {
  AppNav._(); // private constructor

  /// Push a page and return a Future of the result
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, MaterialPageRoute(builder: (_) => page));
  }

  /// Pop the current page with an optional result
  static Future<void> pop<T>(BuildContext context, [T? result]) async {
    Navigator.pop<T>(context, result);
  }

  /// Push a dialog and return the result
  static Future<T?> pushDialog<T>(BuildContext context, Widget dialog) {
    return showDialog<T>(context: context, builder: (_) => dialog);
  }
}
