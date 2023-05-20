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
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$title',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            '$content',
            style: const TextStyle(color: Colors.white),
          )),
        ],
      ),
      behavior: SnackBarBehavior.fixed,
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
