import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/data/models/http_error.dart';
import 'package:dio_request_inspector/data/models/http_request.dart';
import 'package:dio_request_inspector/data/models/http_response.dart';
import 'package:rxdart/rxdart.dart';

List<HttpActivity> _activities = <HttpActivity>[];

final _dataSubject = BehaviorSubject<List<HttpActivity>>();

abstract class LocalDataSource {
  Future<String> saveResponse(HttpResponse httpResponse);

  Future<String> saveRequest(HttpRequest httpRequest);

  Future<String> saveActivity(HttpActivity httpActivity);

  Stream<List<HttpActivity>> get getAllResponse => _dataSubject.stream;

  Future<String> saveError(HttpError error, HttpResponse httpResponse);

  Stream<List<HttpActivity>> clearAllLog();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<String> saveResponse(HttpResponse httpResponse) {
    HttpActivity httpActivity = _activities.firstWhere(
      (data) => data.request?.requestHashCode == httpResponse.requestHashCode,
      orElse: () => HttpActivity(),
    );

    httpActivity.response = httpResponse;

    _dataSubject.add(_activities);
    return Future.value('success');
  }

  @override
  Future<String> saveRequest(HttpRequest httpRequest) {
    _activities.add(HttpActivity(request: httpRequest));
    _dataSubject.add(_activities);
    return Future.value('success');
  }

  @override
  Future<String> saveError(HttpError httpError, HttpResponse httpResponse) {
    HttpActivity httpActivity = _activities.firstWhere(
        (data) => data.request?.requestHashCode == httpError.errorHashCode,
        orElse: () => HttpActivity());

    httpActivity.error = httpError;
    httpActivity.response = httpResponse;
    _dataSubject.add(_activities);
    return Future.value('success save error');
  }

  @override
  Stream<List<HttpActivity>> get getAllResponse => _dataSubject.stream;

  @override
  Stream<List<HttpActivity>> clearAllLog() {
    _activities.clear();
    _dataSubject.value = _activities;
    return _dataSubject.stream;
  }

  @override
  Future<String> saveActivity(HttpActivity httpActivity) {
    _dataSubject.add(_activities);

    return Future.value('success');
  }
}
