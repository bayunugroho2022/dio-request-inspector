
<p align="center">
    <img src="https://user-images.githubusercontent.com/91040581/210127198-791f085b-61b8-4a77-8168-986c9a90d806.png" width="200" height="185">
</p>

<div align="center">

[![pub package](https://img.shields.io/pub/v/dio_request_inspector.svg)](https://pub.dartlang.org/packages/dio_request_inspector)
[![License: BSD 3-Clause](https://img.shields.io/github/license/bayunugroho2022/dio-request-inspector.svg?style=flat)](https://github.com/bayunugroho2022/dio-request-inspector/blob/master/LICENSE)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/bayunugroho2022/dio-request-inspector)

</div>

<h3 align="center">Dio Requests Inspector Package</h3>

<p align="center">
Debug and Sharing your HTTP Request/Response with UI Inspector.
  <br>
  <br>
</p>

<div align="center">
<img src="https://user-images.githubusercontent.com/91040581/210163954-9687c5e7-6790-47f5-a773-03a63ebabebf.jpeg" width="250">
<img src="https://user-images.githubusercontent.com/91040581/210498527-c94d872a-041e-4c5b-a161-fa29e1584769.jpeg" width="250">
<img src="https://user-images.githubusercontent.com/91040581/210498536-647d6895-1f83-4f06-a331-def8220195a3.jpeg" width="250">
<img src="https://user-images.githubusercontent.com/91040581/210498540-5d83652a-10ab-4a17-a389-ab07da8dd3ab.jpeg" width="250">    
<img src="https://user-images.githubusercontent.com/91040581/210127721-aaaa3e63-da48-4cd7-8ce8-019f2dffb902.jpeg" width="250">
</div>

<br clear="left"/>

<br>

## How to use
1. Create DioRequestInspector instance
```dart 
DioRequestInspector dioRequestInspector = DioRequestInspector(isDebugMode: true);
```
2. Add DioRequestInterceptor to your Dio instance
```dart
_dio.interceptors.add(dioRequestInspector.getDioRequestInterceptor());
```
3. Wrap your MaterialApp with DioRequestInspectorMain
```dart
DioRequestInspectorMain(inspector: dioRequestInspector, child: MyApp())
```
4. add NavigatorKey to your MaterialApp for direct to Inspector UI
```dart
navigatorKey: dioRequestInspector.navigatorKey,
```

## Example
```dart
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:dio_request_inspector/presentation/main/page/main_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

DioRequestInspector dioRequestInspector =
DioRequestInspector(isDebugMode: true);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DioRequestInspectorMain(
      inspector: dioRequestInspector, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Request Inspector',
      navigatorKey: dioRequestInspector.getNavigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Dio _dio;

  @override
  void initState() {
    _dio = Dio();
    _dio.interceptors.add(dioRequestInspector.getDioRequestInterceptor());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Request Inspector Example'),
        backgroundColor: Colors.purple.withOpacity(0.6),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _getRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("GET Request"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _getImageRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("GET Image Request"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _postRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("POST Request"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _errorRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("Error Request"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _seeInspector,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("See Inspector"),
            ),
          ],
        ),
      ),
    );
  }

  void _getRequest() {
    _dio.get<void>("https://63aea217ceaabafcf17f16b1.mockapi.io/get");
  }

  void _postRequest() {
    _dio.post("https://httpbin.org/post", data: {"name": "dio", "age": 25});
  }

  void _errorRequest() {
    _dio.get<void>("https://httpbin.org/status/404");
  }

  void _seeInspector() {
    dioRequestInspector.navigateToDetail();
  }

  void _getImageRequest() {
    _dio.get<void>("https://httpbin.org/image/png");
  }
}

```


## Note
- set ```isDebugMode``` to false if your app is in production
- tap ```Long press``` on your screen to show DioRequestInspector UI
