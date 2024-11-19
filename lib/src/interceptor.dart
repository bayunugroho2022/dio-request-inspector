import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_request_inspector/src/common/helpers.dart';
import 'package:dio_request_inspector/src/common/storage.dart';
import 'package:dio_request_inspector/src/model/form_data.dart';
import 'package:dio_request_inspector/src/model/http_activity.dart';
import 'package:dio_request_inspector/src/model/http_error.dart';
import 'package:dio_request_inspector/src/model/http_request.dart';
import 'package:dio_request_inspector/src/model/http_response.dart';
import 'package:flutter/material.dart';

class Interceptor extends InterceptorsWrapper {
  final bool kIsDebug;
  final Duration? duration;
  final HttpActivityStorage storage;
  NavigatorObserver? navigatorKey;

  Interceptor({
    required this.kIsDebug,
    required this.storage,
    this.duration = const Duration(milliseconds: 500),
    this.navigatorKey,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kIsDebug) {
      handler.next(options);
      return;
    }

    final call = HttpActivity(options.hashCode);

    final uri = options.uri;
    call.method = options.method;
    var path = options.uri.path;
    if (path.isEmpty) {
      path = '/';
    }
    call
      ..endpoint = path
      ..server = uri.host
      ..client = 'Dio'
      ..uri = options.uri.toString();

    if (uri.scheme == 'https') {
      call.secure = true;
    }

    final request = HttpRequest();

    final mergedQueryParameters = <String, dynamic>{};

    uri.queryParameters.forEach((key, value) {
      if (mergedQueryParameters.containsKey(key)) {
        mergedQueryParameters[key] = [mergedQueryParameters[key], value].expand((e) => e is List ? e : [e]).toList();
      } else {
        mergedQueryParameters[key] = value;
      }
    });

    options.queryParameters.forEach((key, value) {
      if (!mergedQueryParameters.containsKey(key)) {
        mergedQueryParameters[key] = value;
      } 
    });
    
    final dynamic data = options.data;
    
    if (data == null) {
      request..size = 0;
    } else {
      if (data is FormData) {
        if (data.fields.isNotEmpty == true) {
          final fields = <FormDataField>[];
          final map = <String, String>{};

          for (var entry in data.fields) {
            fields.add(FormDataField(entry.key, entry.value));
            map[entry.key] = entry.value;
          }

          request.formDataFields = fields;
          request.body = jsonEncode(map); 
        }

        if (data.files.isNotEmpty == true) {
          final files = <FormDataFile>[];
          for (var entry in data.files) {
            files.add(
              FormDataFile(
                entry.value.filename,
                entry.value.contentType.toString(),
                entry.value.length,
              ),
            );
          }

          request.formDataFiles = files;
        }
      } else {
        request
          ..size = utf8.encode(data.toString()).length
          ..body = Helper.encodeRawJson(data);
      }
    }

    request
      ..time = DateTime.now()
      ..headers = Helper.encodeRawJson(options.headers)
      ..contentType = options.contentType.toString()
      ..queryParameters = mergedQueryParameters;

    call
      ..request = request
      ..response = HttpResponse();

    storage.addActivity(call);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kIsDebug) {
      handler.next(response);
      return;
    }

    final httpResponse = HttpResponse()..status = response.statusCode;

    if (response.data == null) {
      httpResponse..size = 0;
    } else {
      httpResponse
      ..body = Helper.encodeRawJson(response.data)
      ..size = utf8.encode(response.data.toString()).length;
    }

    httpResponse.time = DateTime.now();
    httpResponse.headers = response.headers.map;

    storage.addResponse(httpResponse, response.requestOptions.hashCode);
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (!kIsDebug) {
      handler.next(error);
      return;
    }

    final httpError = HttpError()..error = error.toString();
    if (error is Error) {
      final basicError = error as Error;
      httpError.stackTrace = basicError.stackTrace;
    }

    storage.addError(httpError, error.requestOptions.hashCode);
    final httpResponse = HttpResponse()..time = DateTime.now();
    if (error.response == null) {
      httpResponse.status = -1;
      storage.addResponse(httpResponse, error.requestOptions.hashCode);
    } else {
      httpResponse.status = error.response!.statusCode;

      if (error.response!.data == null) {
        httpResponse..size = 0;
      } else {
        httpResponse
          ..body = Helper.encodeRawJson(error.response?.data)
          ..size = utf8.encode(error.response!.data.toString()).length;
      }

      httpResponse.headers = error.response?.headers.map;
      storage.addResponse(
        httpResponse,
        error.response!.requestOptions.hashCode,
      );
    }
    handler.next(error);
  }
}
