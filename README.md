<p align="center">
    <img src="https://user-images.githubusercontent.com/91040581/210127198-791f085b-61b8-4a77-8168-986c9a90d806.png" width="200" height="185">
</p>

<h3 align="center">Dio Requests Inspector</h3>

<p align="center">
A HTTP inspector for Dio, which can intercept and log HTTP requests and responses.
  <br>
  <br>
  <br>
  <br>
</p>

![ss](https://github.com/bayunugroho2022/dio-request-inspector/assets/91040581/efd6d3c9-c068-4fed-a94e-a30b9cd616ab)
<br>

## Features

- [X] Intercept and log HTTP requests and responses
- [X] Secure HTTP requests with passwords
- [X] Filter logs by request time, method, and status
- [X] Search logs by path
- [X] Easily share request and response data
- [X] Beautify JSON data
- [X] Beautiful user interface

## How to use

- Add the package with command

```bash
flutter pub add dio_request_inspector
```

- add `navigatorObservers` to your `MaterialApp`

```dart
navigatorObservers: [
  DioRequestInspector.navigatorObserver,
],
```

- Wrap your `myApp` with `DioRequestInspectorMain`

```dart
void main() {
  runApp(DioRequestInspectorMain(
    isDebugMode: true,
    child: MyApp(),
  ));
}
```

- add interceptor to your Dio instance

```dart
final DioRequestInspector inspector = DioRequestInspector(
  isDebugMode: true,
  duration: const Duration(milliseconds: 500),
  showFloating: true,
  password: '123456',
);

dio.interceptors.add(inspector.getDioRequestInterceptor());
```

see detail example

## Note

- tap ```Long press``` on your screen to show DioRequestInspector UI
