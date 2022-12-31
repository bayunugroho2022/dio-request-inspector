import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Map<String, dynamic> listToMap(List list) {
  Map<String, dynamic> map = {};
  for (var i = 0; i < list.length; i++) {
    map[list[i].toString()] = list[i];
  }
  return map;
}

extension JsonExtension on String? {
  String get prettify {
    if (this != null) {
      try {
        var decoded = json.decode(this!);
        var encoder = const JsonEncoder.withIndent('  ');
        return encoder.convert(decoded);
      } catch (e) {
        return 'N/A-Cannot Parse';
      }
    }
    return 'N/A';
  }
}

extension JsonChecker on String {
  bool get isJson {
    try {
      json.decode(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

extension JsonStringExtension on String {
  Map<String, dynamic> get toJson {
    try {
      return json.decode(this) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}

extension DateTimeExtension on int {
  String get toDateTime {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    var d12 = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
    return d12;
  }
}

extension IntToByteExtension on int? {
  static const int bytePerLevel = 1024;
  static const String kiloByteSymbol = 'kb';
  static NumberFormat doubleFormat = NumberFormat("###.##");

  String byteToKiloByte() {
    final value = this ?? 0;
    var result = (value / bytePerLevel);
    return '${doubleFormat.format(result)} $kiloByteSymbol';
  }
}

extension ColorExtension on int {
  Color get colorByStatusCode {
    if (this >= 200 && this < 300) {
      return Colors.green;
    } else if (this >= 300 && this < 400) {
      return Colors.blue;
    } else if (this >= 400 && this < 500) {
      return Colors.orange;
    } else if (this >= 500 && this < 600) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}

extension UriExtension on Uri {
  Map<String, String> get parameters {
    var map = <String, String>{};
    queryParameters.forEach((key, value) {
      map[key] = value;
    });
    return map;
  }
}

extension ColorByMethod on String {
  Color get colorByMethod {
    switch (this) {
      case 'POST':
        return Colors.green;
      case 'GET':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}