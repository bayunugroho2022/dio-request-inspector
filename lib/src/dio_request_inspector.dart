import 'package:dio_request_inspector/src/common/storage.dart';
import 'package:dio_request_inspector/src/interceptor.dart';
import 'package:dio_request_inspector/src/page/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

class DioRequestInspector {
  static final DioRequestInspector _instance = DioRequestInspector._internal();
  static final HttpActivityStorage _storage = HttpActivityStorage();
  static final navigatorObserver = NavigatorObserver();

  bool isDebugMode;
  bool showFloating;
  Duration? duration;
  String? password;

  factory DioRequestInspector({
    required bool isDebugMode,
    Duration? duration = const Duration(milliseconds: 500),
 
    @Deprecated('will be removed in 3.1.5 or higher')
    bool showFloating = true,
    String? password = '',
  }) {
    _instance._init(isDebugMode, duration, showFloating, password);
    return _instance;
  }

  DioRequestInspector._internal()
      : isDebugMode = false,
        showFloating = true,
        duration = const Duration(milliseconds: 500),
        password = '';

  void _init(bool isDebugMode, Duration? duration, bool showFloating, String? password) {
    this.isDebugMode = isDebugMode;
    this.duration = duration;
    this.showFloating = showFloating;
    this.password = password;
  }

  Interceptor getDioRequestInterceptor() {
    return Interceptor(
      kIsDebug: isDebugMode,
      navigatorKey: navigatorObserver,
      duration: duration,
      storage: _storage,
    );
  }

  void goToInspector() {
    if (!isDebugMode) {
      return;
    }

   navigateToInspector();
  }

  void navigateToInspector() {
    navigatorObserver.navigator?.push(
      MaterialPageRoute<dynamic>(
        builder: (_) => DashboardPage(password: password ?? '', storage: _storage),
      ),
    );
  }
}
