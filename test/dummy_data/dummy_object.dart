import 'package:dio/dio.dart';

final saveRequest = Response(
  requestOptions: RequestOptions(
    path: 'test/dummy_data/dummy_object.dart',
    method: 'GET',
    baseUrl: 'https://github.com',
));

final saveError = DioError(
  requestOptions: RequestOptions(
    path: 'test/dummy_data/dummy_object.dart',
    method: 'GET',
    baseUrl: 'https://github.com',
  ),
  error: 'error',
);