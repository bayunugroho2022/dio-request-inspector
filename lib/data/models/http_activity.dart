import 'package:dio_request_inspector/data/models/http_error.dart';

import 'http_request.dart';
import 'http_response.dart';

class HttpActivity {
  HttpRequest? request;
  HttpResponse? response;
  HttpError? error;

  HttpActivity({
    this.request,
    this.response,
    this.error,
  });
}
