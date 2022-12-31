class DateTimeUtil {
  String milliSecondDifference(
    int? startTime,
    int? endTime,
  ) {
    var start = (startTime != null)
        ? DateTime.fromMillisecondsSinceEpoch(startTime)
        : DateTime.now();
    var end = (endTime != null)
        ? DateTime.fromMillisecondsSinceEpoch(endTime)
        : DateTime.now();
    var diff = end.difference(start).inMilliseconds;
    return '$diff ms';
  }
}
