import 'package:dio_request_inspector/dio_request_inspector.dart';

final DioRequestInspector inspector = DioRequestInspector(
  isInspectorEnabled: true,
  password: '123456', // remove this line if you don't need password
  showSummary: false,
);

final void Function() toInspector = inspector.goToInspector;