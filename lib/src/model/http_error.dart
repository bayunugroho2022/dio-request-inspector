// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class HttpError with EquatableMixin {
  dynamic error;
  StackTrace? stackTrace;

  @override
  List<Object?> get props => [error, stackTrace];
}
