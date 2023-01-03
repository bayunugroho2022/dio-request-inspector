import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboard {
  static void copy({String text = '', BuildContext? context}) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
    });
  }
}
