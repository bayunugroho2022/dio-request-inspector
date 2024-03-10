
<p align="center">
    <img src="https://user-images.githubusercontent.com/91040581/210127198-791f085b-61b8-4a77-8168-986c9a90d806.png" width="200" height="185">
</p>

<div align="center">

[![pub package](https://img.shields.io/pub/v/dio_request_inspector.svg)](https://pub.dartlang.org/packages/dio_request_inspector)
[![License: BSD 3-Clause](https://img.shields.io/github/license/bayunugroho2022/dio-request-inspector.svg?style=flat)](https://github.com/bayunugroho2022/dio-request-inspector/blob/master/LICENSE)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/bayunugroho2022/dio-request-inspector)

</div>

<h3 align="center">Dio Requests Inspector Package</h3>


<h1 align="center">Effortlessly Debug Your Flutter Network Requests</h1>

<p align="center">
  "Dio Request Inspector" is a handy open-source tool for **monitoring and analyzing HTTP requests** in Flutter applications using the Dio package. It provides real-time insights, detailed request information, and filtering capabilities, making it easy to **track and troubleshoot server interactions**.
</p>

<div align="center">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/3b5df5c3-95d1-4072-9cca-464f12a507d7" width="260">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/14f40aef-9bac-4173-9c13-4207b976841e" width="250">
<img src="https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/b4d62644-c356-4119-bc58-06dc2a340458" width="250">

</div>

<br clear="left"/>

<br>

## Get Started

**Installation**

Add the dependency to your `pubspec.yaml`:

You can use the command to add dio_request_inspector as a dependency with the latest stable version:

```console
$ flutter pub add dio_request_inspector
```

Or you can manually add dio_request_inspector into the dependencies section in your pubspec.yaml:

```yaml
dependencies:
  dio_request_inspector: ^replace-with-latest-version
```

The latest version is: [![pub package](https://img.shields.io/pub/v/dio_request_inspector.svg)](https://pub.dartlang.org/packages/dio_request_inspector)

### Basic Usage

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

4. Integrate with MaterialApp (version >= 3.0.0)
Wrap your `MaterialApp` with `DioRequestInspectorMain` and utilize the `navigatorObservers` property to enable automatic navigation to the inspector UI:

```dart
DioRequestInspectorMain(
  inspector: dioRequestInspector,
  child: MaterialApp(
    // Your MaterialApp configuration
    navigatorObservers: [
      DioRequestInspector.navigatorObserver,
    ],
  ),
)
```


### See Inspector UI
Run your app and long press on the screen to open the inspector UI.