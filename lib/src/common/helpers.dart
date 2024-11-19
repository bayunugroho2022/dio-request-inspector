import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Helper {
  static const int _kilobyteAsByte = 1000;
  static const int _megabyteAsByte = 1000000;
  static const int _secondAsMillisecond = 1000;
  static const int _minuteAsMillisecond = 60000;
  static const String _bytes = "B";
  static const String _kiloBytes = "kB";
  static const String _megaBytes = "MB";
  static const String _milliseconds = "ms";
  static const String _seconds = "s";
  static const String _minutes = "min";

  static void copyToClipboard({String text = '', BuildContext? context, String message = 'Copied to clipboard'}) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  static String formatBytes(int bytes) => switch (bytes) {
        int bytes when bytes < 0 => '-1 $_bytes',
        int bytes when bytes <= _kilobyteAsByte => '$bytes $_bytes',
        int bytes when bytes <= _megabyteAsByte =>
          '${_formatDouble(bytes / _kilobyteAsByte)} $_kiloBytes',
        _ => '${_formatDouble(bytes / _megabyteAsByte)} $_megaBytes',
      };

  static String _formatDouble(double value) => value.toStringAsFixed(2);

  static String formatTime(int timeInMillis) {
    if (timeInMillis < 0) {
      return '-1 $_milliseconds';
    }
    if (timeInMillis <= _secondAsMillisecond) {
      return '$timeInMillis $_milliseconds';
    }
    if (timeInMillis <= _minuteAsMillisecond) {
      return '${_formatDouble(timeInMillis / _secondAsMillisecond)} $_seconds';
    }

    final Duration duration = Duration(milliseconds: timeInMillis);

    return '${duration.inMinutes} $_minutes ${duration.inSeconds.remainder(60)} $_seconds '
        '${duration.inMilliseconds.remainder(1000)} $_milliseconds';
  }

  static String? encodeRawJson(dynamic rawJson) {
    if (rawJson == null) {
      return null;
    }
    
    if (rawJson is Map<String, dynamic>) {
      return (rawJson.isNotEmpty) ? json.encode(rawJson) : null;
    } else if (rawJson is List<dynamic>) {
      return (rawJson.isNotEmpty) ? json.encode(rawJson) : null;
    }
    if (rawJson is String) {
      return rawJson.isNotEmpty ? rawJson : null;
    } else {
      return rawJson.toString();
    }
  }

  static Map<String, dynamic> decodeRawJson(String json) {
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  } 
}
