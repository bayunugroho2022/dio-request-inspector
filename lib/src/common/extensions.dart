import 'dart:convert';

extension IntToByteExtension on int? {
  static const int bytePerLevel = 1024;
  static const String kiloByteSymbol = 'kb';

  String byteToKiloByte() {
    final value = this ?? 0;
    var result = (value / bytePerLevel);
    return '${_formatDouble(result)} $kiloByteSymbol';
  }

  double byteToKiloByteDouble() {
    final value = this ?? 0;
    var result = (value / bytePerLevel);
    return result;
  }

  String _formatDouble(double value) {
    return value.toStringAsFixed(2);
  }
}

extension JsonExtension on String? {
  String get prettify {
    if (this != null) {
      try {
        var decoded = json.decode(this!);
        var encoder = const JsonEncoder.withIndent('  ');
        var prettyJson = encoder.convert(decoded);
        return prettyJson;
      } catch (e) {
        return 'N/A-Cannot Parse';
      }
    }
    return 'N/A';
  }

  bool get isJson {
    try {
      json.decode(this!);
      return true;
    } catch (_) {
      return false;
    }
  }

  String toJson() {
    return json.encode(this);
  }

  Map<String, dynamic> toMap() {
    if (this == null) {
      return <String, dynamic>{};
    }
    return json.decode(this!);
  }
}