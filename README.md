
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
"Dio Request Inspector" is a handy open-source tool for monitoring and analyzing HTTP requests in Flutter using the Dio package. It provides real-time monitoring, detailed request information, and filtering capabilities, making it easy to track and troubleshoot server interactions in your Flutter projects.
  <br>
  <br>
</p>

<div align="center">

<img src="https://user-images.githubusercontent.com/91040581/210163954-9687c5e7-6790-47f5-a773-03a63ebabebf.jpeg" width="250">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/abb13152-f56a-486d-9fd2-15ebec5fe24e" width="250">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/14f40aef-9bac-4173-9c13-4207b976841e" width="250">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/17ca16fd-588d-4147-8ff0-e437e98769f2" width="250">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/b4d62644-c356-4119-bc58-06dc2a340458" width="250">

</div>

<br clear="left"/>

<br>

## Features
✔️ Real-time monitoring of HTTP requests in your Flutter application. <br><br>
✔️ Detailed information about each request, including URL, request method, headers, and payload data.<br><br>
✔️ Filter and search functionality to quickly find relevant requests based on criteria such as URL, method, or status code.<br><br>
✔️ Easy integration with Flutter projects using the Dio package.<br><br>
✔️ Intuitive and user-friendly UI for seamless request exploration and analysis.<br><br>

## Get started

### Add dependency

You can use the command to add dio_request_inspector as a dependency with the latest stable version:

```console
$ dart pub add dio_request_inspector
```

Or you can manually add dio_request_inspector into the dependencies section in your pubspec.yaml:

```yaml
dependencies:
  dio_request_inspector: ^replace-with-latest-version
```


The latest version is: [![pub package](https://img.shields.io/pub/v/dio_request_inspector.svg)](https://pub.dartlang.org/packages/dio_request_inspector)

### Super simple to use

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

## Contributing

If you would like to contribute to this project, please feel free to submit a pull request.