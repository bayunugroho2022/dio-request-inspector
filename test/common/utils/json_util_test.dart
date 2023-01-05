import 'package:dio_request_inspector/common/utils/json_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late JsonUtil jsonUtil;
  setUp(() {
    jsonUtil = JsonUtil();
  });


  // test encodeRawJson when rawJson is Map<String, dynamic>
  group('encodeRawJson', () {
    test('should return String when rawJson is Map<String, dynamic>', () async {
      // arrange
      final testMap = {'test': 'test'};
      // act
      final result = jsonUtil.encodeRawJson(testMap);
      // assert
      expect(result, '{"test":"test"}');
    });
  });

  // test encodeRawJson when rawJson is List<dynamic>
  group('encodeRawJson', () {
    test('should return String rawJson is List<dynamic>', () async {
      // arrange
      final testList = ['test', 'test'];
      // act
      final result = jsonUtil.encodeRawJson(testList);
      // assert
      expect(result, '["test","test"]');
    });
  });

  // test encodeRawJson when rawJson is String empty
  group('encodeRawJson', () {
    test('should return null when rawJson is empty', () async {
      // arrange
      const testString = '';
      // act
      final result = jsonUtil.encodeRawJson(testString);
      // assert
      expect(result, null);
    });
  });

  // test encodeRawJson when rawJson is String notEmpty
  group('encodeRawJson', () {
    test('should return String when rewJson is String', () async {
      // arrange
      const testString = 'test';
      // act
      final result = jsonUtil.encodeRawJson(testString);
      // assert
      expect(result, 'test');
    });
  });

}
