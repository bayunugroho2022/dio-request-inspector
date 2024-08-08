import 'dart:io' show Cookie;
import 'package:equatable/equatable.dart';
import 'form_data.dart';

class HttpRequest with EquatableMixin {
  int size = 0;
  DateTime time = DateTime.now();
  String? headers;
  String? body;
  String? contentType = '';
  List<Cookie> cookies = [];
  Map<String, dynamic> queryParameters = <String, dynamic>{};
  List<FormDataFile>? formDataFiles;
  List<FormDataField>? formDataFields;

  @override
  List<Object?> get props => [
        size,
        time,
        headers,
        body,
        contentType,
        cookies,
        queryParameters,
        formDataFiles,
        formDataFields,
      ];
}