import 'package:dio/dio.dart';
import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/common/utils/byte_util.dart';
import 'package:dio_request_inspector/common/utils/json_util.dart';
import 'package:dio_request_inspector/data/models/form_data.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/data/models/http_error.dart';
import 'package:dio_request_inspector/data/models/http_request.dart';
import 'package:dio_request_inspector/data/models/http_response.dart';

final _jsonUtil = JsonUtil();
final _byteUtil = ByteUtil();

extension HttpResponseMapper on Response {
  HttpResponse toHttpResponse() {
    return HttpResponse(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      responseHeader: headers.map,
      contentType: headers.map['content-type']?.first ?? 'Unknown',
      responseBody: _jsonUtil.encodeRawJson(data),
      responseStatusCode: statusCode,
      responseStatusMessage: statusMessage,
      responseSize: _byteUtil.stringToBytes(data.toString()),
      requestHashCode: requestOptions.hashCode,
    );
  }
}

extension HttpActivityMapper on HttpError {
  HttpActivity toHttpActivity(DioException e) {
    return HttpActivity(
        response: HttpResponse(
      responseStatusCode: e.response?.statusCode,
      responseStatusMessage: e.response?.statusMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      responseBody: e.response?.data,
      contentType: e.response?.headers.map['content-type']?.first ?? 'Unknown',
      responseHeader: e.response?.headers.map,
      responseSize: _byteUtil.stringToBytes(e.response?.data.toString() ?? ""),
      requestHashCode: e.requestOptions.hashCode,
    ));
  }
}

extension HttpRequestMapper on RequestOptions {
  HttpRequest toHttpRequest() {
    return HttpRequest(
      baseUrl: uri.origin,
      path: uri.path,
      params: _jsonUtil.encodeRawJson(uri.parameters),
      method: method,
      server: uri.host,
      secure: uri.scheme == 'https',
      client: "Dio",
      requestHeader: _jsonUtil.encodeRawJson(headers),
      requestBody: data is FormData
          ? _jsonUtil.encodeRawJson(getFormData(data))
          : _jsonUtil.encodeRawJson(data),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      requestSize: _byteUtil.stringToBytes(data.toString()),
      requestHashCode: hashCode,
    );
  }

  Map<String, dynamic> getFormData(data) {
    final List<FormDataFieldModel> fields = [];
    final List<FormDataFileModel> files = [];

    if (data.fields.isNotEmpty == true) {
      data.fields.forEach((entry) {
        fields.add(FormDataFieldModel(entry.key, entry.value));
      });
    }

    if (data.files.isNotEmpty == true) {
      data.files.forEach((entry) {
        files.add(
          FormDataFileModel(
            entry.value.filename,
            entry.value.contentType.toString(),
            entry.value.length,
          ),
        );
      });
    }

    final Map<String, dynamic> formData = {};
    for (var field in fields) {
      formData[field.name] = field.value;
    }

    List<Map<String, dynamic>> fileMaps = files.map((file) {
      return {
        'fileName': file.fileName,
        'contentType': file.contentType,
        'length': file.length,
      };
    }).toList();

    formData['files'] = fileMaps;

    return formData;
  }
}

List<dynamic> getFromData(RequestOptions options) {
  final fields = [];

  if (options.data.fields.isNotEmpty == true) {
    options.data.fields.forEach((entry) {
      fields.add({
        entry.key: entry.value,
      });
    });
    options.data.request.formDataFields = fields;
    return fields;
  } else {
    return fields;
  }
}

extension HttpErrorToResponseMapper on DioException {
  HttpResponse toHttpErrorFromResponse() {
    return HttpResponse(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      responseStatusCode: response?.statusCode,
      responseStatusMessage: response?.statusMessage,
      responseBody: _jsonUtil.encodeRawJson(response?.data),
      responseHeader: response?.headers.map,
    );
  }
}

extension HttpErrorMapper on DioException {
  HttpError toHttpError() {
    return HttpError(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      stackTrace: stackTrace.toString(),
      errorStatusCode: response?.statusCode,
      errorHashCode: requestOptions.hashCode,
      errorMessage: message,
      errorSize: _byteUtil.stringToBytes(message.toString()),
    );
  }
}
