import 'package:flutter/material.dart';

extension BuildContextExtenstion on BuildContext {
  ThemeData get thene => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showSnackBar(
    String text,
  ) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        content: Text(text)));
  }
  /**
   * 
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("google")));
   * 
   */
}
