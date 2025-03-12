import 'package:dio_request_inspector/src/common/storage.dart';
import 'package:dio_request_inspector/src/interceptor.dart';
import 'package:dio_request_inspector/src/page/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

class DioRequestInspector {
  static final DioRequestInspector _instance = DioRequestInspector._internal();
  static final HttpActivityStorage _storage = HttpActivityStorage();
  static final navigatorObserver = NavigatorObserver();

  bool isInspectorEnabled;
  String? password;
  bool? showSummary;

  factory DioRequestInspector({
    required bool isInspectorEnabled,
    String? password = '',
    bool? showSummary = true,
  }) {
    _instance._init(isInspectorEnabled, password, showSummary);
    return _instance;
  }

  DioRequestInspector._internal()
      : isInspectorEnabled = false,
        password = '',
        showSummary = true;

  void _init(bool isInspectorEnabled, String? password, bool? showSummary) {
    this.isInspectorEnabled = isInspectorEnabled;
    this.password = password;
    this.showSummary = showSummary;
  }

  Interceptor getDioRequestInterceptor() {
    return Interceptor(
      isInspectorEnabled: isInspectorEnabled,
      navigatorKey: navigatorObserver,
      storage: _storage,
    );
  }

  void goToInspector() {
    if (!isInspectorEnabled) {
      return;
    }

   navigateToInspector();
  }

  void navigateToInspector() {
    navigatorObserver.navigator?.push(
      MaterialPageRoute<dynamic>(
        builder: (_) => DashboardPage(password: password ?? '', storage: _storage, showSummary: showSummary ?? true),
      ),
    );
  }
}
