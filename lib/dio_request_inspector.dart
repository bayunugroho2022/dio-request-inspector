library dio_request_inspector;

import 'package:dio_request_inspector/common/injection.dart' as di;
import 'package:dio_request_inspector/common/interceptor.dart';
import 'package:flutter/material.dart';

class DioRequestInspector {
  static final navigatorObserver = NavigatorObserver();

  final bool isDebugMode;
  final bool showFloating;
  final Duration? duration;

  DioRequestInspector({
    required this.isDebugMode,
    this.duration = const Duration(milliseconds: 500),
    this.showFloating = true,
  }) {
    di.init();
  }

  Interceptor getDioRequestInterceptor() {
    return Interceptor(
        kIsDebug: isDebugMode,
        navigatorKey: navigatorObserver,
        duration: duration,
        showFloating: showFloating);
  }
}
