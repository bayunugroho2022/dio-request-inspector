class HttpResponse {
  final int? id;
  final int? createdAt;
  final Map<String, List<String>>? responseHeader;
  final String? responseBody;
  final int? responseStatusCode;
  final String? responseStatusMessage;
  final int? responseSize;
  final int? duration;
  final String? errorLog;
  final int? requestHashCode;
  final String? contentType;

  HttpResponse({
    this.id,
    this.createdAt,
    this.responseHeader,
    this.responseBody,
    this.responseStatusCode,
    this.responseStatusMessage,
    this.errorLog,
    this.duration = 0,
    this.responseSize,
    this.requestHashCode,
    this.contentType,
  });
}
