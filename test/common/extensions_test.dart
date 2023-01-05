import 'package:dio_request_inspector/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // test listToMap
  group('listToMap', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final testList = [1, 2, 3];
      // act
      final result = listToMap(testList);
      // assert
      expect(result, {'1': 1, '2': 2, '3': 3});
    });
  });


  // test prettify when cant parse
  group('prettify', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      const testString = 'test';
      // act
      final result = testString.prettify;
      // assert
      expect(result, 'N/A-Cannot Parse');
    });
  });

  // test prettify when can parse
  group('prettify', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      const testString = '{"test": "test"}';
      // act
      final result = testString.prettify;
      // assert
      expect(result, '{\n  "test": "test"\n}');
    });
  });

  // test isJson if true
  group('isJson', () {
    test('should return false when isJson is true', () async {
      // arrange
      const testString = '{"test": "test"}';
      // act
      final result = testString.isJson;
      // assert
      expect(result, true);
    });
  });

  // test isJson if false
  group('isJson', () {
    test('should return false when isJson is false', () async {
      // arrange
      const testString = 'test';
      // act
      final result = testString.isJson;
      // assert
      expect(result, false);
    });
  });

  //test toDateTime from int
  group('toDateTime', () {
    test('should return String datetime', () async {
      // arrange
      const testInt = 1620000000;
      // act
      final result = testInt.toDateTime;
      // assert
      expect(result, '20-01-1970 01:00:00');
    });
  });

  //test colorByStatusCode when status code is 200
  group('colorByStatusCode', () {
    test('should return color when status code is 200', () async {
      // arrange
      const testInt = 200;
      // act
      final result = testInt.colorByStatusCode;
      // assert
      expect(result, Colors.green);
    });
  });

  //test colorByStatusCode when status code is 400
  group('colorByStatusCode', () {
    test('should return color when status code is 400', () async {
      // arrange
      const testInt = 400;
      // act
      final result = testInt.colorByStatusCode;
      // assert
      expect(result, Colors.orange);
    });
  });

  //test colorByStatusCode when status code is 500
  group('colorByStatusCode', () {
    test('should return color when status code is 500', () async {
      // arrange
      const testInt = 500;
      // act
      final result = testInt.colorByStatusCode;
      // assert
      expect(result, Colors.red);
    });
  });

  //test colorByStatusCode when status code is 600
  group('colorByStatusCode', () {
    test('should return color when status code is 600', () async {
      // arrange
      const testInt = 600;
      // act
      final result = testInt.colorByStatusCode;
      // assert
      expect(result, Colors.grey);
    });
  });


  // test colorByMethod when method is GET
  group('colorByMethod', () {
    test('should return color when method is GET', () async {
      // arrange
      const testString = 'GET';
      // act
      final result = testString.colorByMethod;
      // assert
      expect(result, Colors.blue);
    });
  });

  // test colorByMethod when method is POST
  group('colorByMethod', () {
    test('should return color when method is POST', () async {
      // arrange
      const testString = 'POST';
      // act
      final result = testString.colorByMethod;
      // assert
      expect(result, Colors.green);
    });
  });

  // test colorByMethod when method is PUT
  group('colorByMethod', () {
    test('should return color when method is PUT', () async {
      // arrange
      const testString = 'PUT';
      // act
      final result = testString.colorByMethod;
      // assert
      expect(result, Colors.orange);
    });
  });

  // test colorByMethod when method is PATCH
  group('colorByMethod', () {
    test('should return color when method is PATCH', () async {
      // arrange
      const testString = 'PATCH';
      // act
      final result = testString.colorByMethod;
      // assert
      expect(result, Colors.grey);
    });
  });

  // test colorByMethod when method is DELETE
  group('colorByMethod', () {
    test('should return color when method is DELETE', () async {
      // arrange
      const testString = 'DELETE';
      // act
      final result = testString.colorByMethod;
      // assert
      expect(result, Colors.red);
    });
  });

}
