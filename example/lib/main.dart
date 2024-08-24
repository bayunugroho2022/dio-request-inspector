import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dio_request_inspector_setting.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DioRequestInspectorMain(inspector: inspector, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dio Request Inspector',
      navigatorObservers: [
        DioRequestInspector.navigatorObserver,
      ],
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
    _dio.interceptors.add(inspector.getDioRequestInterceptor());
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
              child: const Text("GET Request", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _getImageRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("GET Image Request", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _postRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("POST Request", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _errorRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("Error Request", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _openInspector,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.6),
              ),
              child: const Text("Open Inspector", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
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

  void _getImageRequest() {
    _dio.get<void>("https://httpbin.org/image/png");
  }

  void _openInspector() => toInspector();
}
