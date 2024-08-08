import 'dart:convert';

import 'package:flutter/material.dart';

class DriParser {
  static const String _jsonContentTypeSmall = 'content-type';
  static const String _jsonContentTypeBig = 'Content-Type';
  static const String _stream = 'Stream';
  static const String _applicationJson = 'application/json';
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static String _parseJson(dynamic json) {
    try {
      return _encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  static dynamic _decodeJson(dynamic body) {
    try {
      return json.decode(body as String);
    } catch (_) {
      return body;
    }
  }

  static String formatBody({
    required BuildContext context,
    required dynamic body,
    String? contentType,
  }) {
    try {
      if (body == null) {
        return 'Body is empty';
      }

      String bodyContent = 'Body is empty';

      if (contentType == null ||
          !contentType.toLowerCase().contains(_applicationJson)) {
        final bodyTemp = body.toString();

        if (bodyTemp.isNotEmpty) {
          bodyContent = bodyTemp;
        }
      } else {
        if (body is String && body.contains('\n')) {
          bodyContent = body;
        } else {
          if (body is String) {
            if (body.isNotEmpty) {
              bodyContent = _parseJson(_decodeJson(body));
            }
          } else if (body is Stream) {
            bodyContent = _stream;
          } else {
            bodyContent = _parseJson(body);
          }
        }
      }

      return bodyContent;
    } catch (_) {
      return 'Body: ' + body.toString();
    }
  }

  static String? getContentType({
    Map<String, dynamic>? headers,
  }) {
    if (headers != null) {
      if (headers.containsKey(_jsonContentTypeSmall)) {
        return headers[_jsonContentTypeSmall];
      }
      if (headers.containsKey(_jsonContentTypeBig)) {
        return headers[_jsonContentTypeBig];
      }
    }
    return 'N/A';
  }

  static Map<String, String> parseHeaders({dynamic headers}) {
    if (headers is Map<String, String>) {
      return headers;
    }

    if (headers is Map<String, dynamic>) {
      return headers.map((key, value) => MapEntry(key, value.toString()));
    }

    throw ArgumentError("N/A");
  }
}
