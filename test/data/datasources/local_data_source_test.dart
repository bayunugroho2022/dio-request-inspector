import 'package:dio_request_inspector/data/datasources/local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_object.dart';

void main() {
  late LocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = LocalDataSourceImpl();
  });

  // save response
  group('save response', () {
    test('should return success message when save response is success',
        () async {
      // arrange
      // act
      final result = await dataSource.saveResponse(saveRequest);
      // assert
      expect(result, 'success');
    });
  });

  // save request
  group('save request', () {
    test('should return success message when save request is success',
        () async {
      // arrange
      // act
      final result = await dataSource.saveRequest(saveRequest.requestOptions);
      // assert
      expect(result, 'success');
    });
  });

  // save error
  group('save error', () {
    test('should return success message when save error is success', () async {
      // arrange
      // act
      final result = await dataSource.saveError(saveError);
      // assert
      expect(result, 'success error');
    });
  });

  // get all response
  group('get all response', () {
    test('should return list of response', () async {
      // arrange
      // act
      final result = dataSource.getAllResponse();
      // assert
      expect(result, isA<List>());
    });
  });
}
