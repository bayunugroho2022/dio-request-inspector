
import 'package:equatable/equatable.dart';

class HttpResponse with EquatableMixin {
  int? status = 0;
  int size = 0;
  DateTime time = DateTime.now();
  String? body;
  Map<String, List<String>>? headers;

  @override
  List<Object?> get props => [
        status,
        size,
        time,
        body,
        headers,
      ];
}
