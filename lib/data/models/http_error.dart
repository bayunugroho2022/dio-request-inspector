class HttpError {
  final int? id;
  final int? createdAt;
  final String? stackTrace;
  final int? errorStatusCode;
  final int? errorHashCode;
  final String? errorMessage;

  HttpError({
    this.id,
    this.createdAt,
    this.stackTrace,
    this.errorStatusCode,
    this.errorHashCode,
    this.errorMessage,
  });
}
