import 'package:dio_request_inspector/dio_request_inspector.dart';

final DioRequestInspector inspector = DioRequestInspector(
  isDebugMode: true,
  duration: const Duration(milliseconds: 500),
  showFloating: true,
  password: '123456', // remove this line if you don't need password
);

final void Function() toInspector = inspector.goToInspector;