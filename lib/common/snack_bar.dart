import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(
      {BuildContext? context,
      String? title,
      String? content,
      String? actionLabel,
      required Function()? action,
      Duration? duration}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$title'),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: Text('$content')),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.purple.withOpacity(0.6),
      duration: duration!,
      action: SnackBarAction(
        label: actionLabel ?? 'VIEW',
        textColor: Colors.white,
        onPressed: action!,
      ),
    );

    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }
}
