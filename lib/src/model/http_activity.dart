import 'package:equatable/equatable.dart';

import 'http_error.dart';
import 'http_request.dart';
import 'http_response.dart';

class HttpActivity with EquatableMixin {
  HttpActivity(this.id);

  final int id;
  final DateTime createdTime = DateTime.now();
  String client = '';
  bool loading = true;
  bool secure = false;
  String method = '';
  String endpoint = '';
  String server = '';
  String uri = '';
  int duration = 0;

  HttpRequest? request;
  HttpResponse? response;
  HttpError? error;

  factory HttpActivity.empty() {
    return HttpActivity(0);
  }

  @override
  List<Object?> get props => [
        id,
        createdTime,
        client,
        loading,
        secure,
        method,
        endpoint,
        server,
        uri,
        duration,
        request,
        response,
        error,
      ];
}
