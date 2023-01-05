import 'dart:convert';

class JsonUtil {

  String? encodeRawJson(dynamic rawJson) {
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
}
