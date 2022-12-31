import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/common/utils/byte_util.dart';
import 'package:dio_request_inspector/common/utils/json_util.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/data/models/http_error.dart';
import 'package:dio_request_inspector/data/models/http_request.dart';
import 'package:dio_request_inspector/data/models/http_response.dart';
import 'package:dio/dio.dart';

List<HttpResponse> _responses = [];
List<HttpRequest> _requests = [];
List<HttpError> _errors = [];
List<HttpActivity> _activities = <HttpActivity>[];

abstract class LocalDataSource {
  Future<String> saveResponse(Response response);

  Future<String> saveRequest(RequestOptions options);

  List<HttpActivity> getAllResponse();

  Future<String> saveError(DioError error);
}

class LocalDataSourceImpl implements LocalDataSource {
  final _jsonUtil = JsonUtil();
  final _byteUtil = ByteUtil();

  @override
  Future<String> saveResponse(Response response) {
    final httpResponse = HttpResponse(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      responseHeader: response.headers.map,
      responseBody: _jsonUtil.encodeRawJson(response.data),
      responseStatusCode: response.statusCode,
      responseStatusMessage: response.statusMessage,
      responseSize: _byteUtil.stringToBytes(response.data.toString()),
      requestHashCode: response.requestOptions.hashCode,
    );
    _responses.addAll([httpResponse]);
    HttpActivity httpActivity = _activities.firstWhere(
        (data) =>
            data.request?.requestHashCode == response.requestOptions.hashCode,
        orElse: () => HttpActivity());
    httpActivity.response = httpResponse;
    return Future.value('success');
  }

  @override
  List<HttpActivity> getAllResponse() {
    return _activities;
  }

  @override
  Future<String> saveRequest(RequestOptions options) {
    final httpRequest = HttpRequest(
      baseUrl: options.baseUrl,
      path: options.uri.path,
      params: _jsonUtil.encodeRawJson(options.uri.parameters),
      method: options.method,
      server: options.uri.host,
      secure: options.uri.scheme == 'https',
      client: "Dio",
      requestHeader: _jsonUtil.encodeRawJson(options.headers),
      requestBody: _jsonUtil.encodeRawJson(options.data),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      requestSize: _byteUtil.stringToBytes(options.data.toString()),
      requestHashCode: options.hashCode,
    );
    _requests.addAll([httpRequest]);
    _activities.add(HttpActivity(request: httpRequest));
    return Future.value('success');
  }

  @override
  Future<String> saveError(DioError error) {
    HttpError httpError = HttpError(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      stackTrace: error.stackTrace.toString(),
      errorStatusCode: error.response?.statusCode,
      errorHashCode: error.requestOptions.hashCode,
      errorMessage: error.message,
    );
    _errors.addAll([httpError]);
    HttpActivity httpActivity = _activities.firstWhere(
        (data) =>
            data.request?.requestHashCode == error.requestOptions.hashCode,
        orElse: () => HttpActivity());
    httpActivity.error = httpError;
    httpActivity.response = HttpResponse(
      responseStatusCode: error.response?.statusCode,
      responseStatusMessage: error.response?.statusMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      responseBody: _jsonUtil.encodeRawJson(error.response?.data),
      responseHeader: error.response?.headers.map,
    );
    return Future.value('success error');
  }
}
