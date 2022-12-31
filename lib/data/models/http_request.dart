class HttpRequest {
  final int? id;
  final int? createdAt;
  final String? baseUrl;
  final String? path;
  final String? params;
  final String? method;
  final String? server;
  final String? requestHeader;
  final String? requestBody;
  final String? client;
  final bool? secure;
  final int? requestSize;
  final int? requestHashCode;

  HttpRequest({
    this.id,
    this.createdAt,
    this.baseUrl,
    this.path,
    this.params,
    this.method,
    this.server,
    this.requestHeader,
    this.requestBody,
    this.client,
    this.secure,
    this.requestSize,
    this.requestHashCode,
  });
}
