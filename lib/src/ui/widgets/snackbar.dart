import 'package:flutter/material.dart';

class SnackBarHelper {
  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}
