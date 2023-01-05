
import 'package:dio_request_inspector/common/utils/byte_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ByteUtil byteUtil;

  setUp(() {
    byteUtil = ByteUtil();
  });

  // test stringToBytes
  group('stringToBytes', () {
    test('should return 4 when value is test', () async {
      // arrange
      const testString = 'test';
      // act
      final result = byteUtil.stringToBytes(testString);
      // assert
      expect(result, 4);
    });
  });

  // test totalTransferSize when isRaw false
  group('totalTransferSize', () {
    test('should return 0.45 kb when is raw', () async {
      // arrange
      const requestSize = 231;
      const responseSize = 234;

      // act
      final result = byteUtil.totalTransferSize(requestSize, responseSize, false);

      // assert
      expect(result, "0.45 kb");
    });
  });

  // test totalTransferSize when isRaw true
  group('totalTransferSize', () {
    test('should return 0.45 kb when is raw', () async {
      // arrange
      const requestSize = 231;
      const responseSize = 234;

      // act
      final result = byteUtil.totalTransferSize(requestSize, responseSize, true);

      // assert
      expect(result, "465 kb");
    });
  });
}