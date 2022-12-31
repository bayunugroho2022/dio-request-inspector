import 'dart:convert';

class JsonUtil {

  static Map<String, dynamic>? tryDecodeRawJson(String? rawJson) {
    try {
      final decoded = json.decode(rawJson!);
      return decoded;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> tryEncodeJson(Map<dynamic, dynamic> map) {
    try {
      var encoded = json.encode(map);
      return Future.value(encoded);
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, String>? compileHeader(Map<String, String>? globalHeaders,
      Map<String, String>? headers,) {
    if (globalHeaders != null) {
      if (headers != null) {
        for (var key in headers.keys) {
          globalHeaders[key] = headers[key]!;
        }
        return globalHeaders;
      } else {
        return globalHeaders;
      }
    } else {
      return headers;
    }
  }

  String? encodeRawJson(dynamic rawJson) {
    if (rawJson is Map<String, dynamic>) {
      return (rawJson.isNotEmpty) ? json.encode(rawJson) : null;
    } else if (rawJson is List<dynamic>) {
      return (rawJson.isNotEmpty) ? json.encode(rawJson) : null;
    } if (rawJson is String) {
      return rawJson.isNotEmpty ? rawJson : null;
    } else {
      return rawJson.toString();
    }
  }
}
