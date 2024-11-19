import 'package:dio_request_inspector/dio_request_inspector.dart';

final DioRequestInspector inspector = DioRequestInspector(
  isDebugMode: true,
  duration: const Duration(milliseconds: 500),
  password: '123456',
);

final void Function() toInspector = inspector.toInspector;