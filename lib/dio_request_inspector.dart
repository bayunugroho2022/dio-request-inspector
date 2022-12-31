library dio_request_inspector;

import 'package:dio_request_inspector/common/injection.dart' as di;
import 'package:dio_request_inspector/common/interceptor.dart';
import 'package:dio_request_inspector/presentation/dashboard/page/dashboard_page.dart';
import 'package:flutter/material.dart';

class DioRequestInspector {
  GlobalKey<NavigatorState>? navigatorKey;

  GlobalKey<NavigatorState> get getNavigatorKey => navigatorKey!;

  final bool isDebugMode;

  DioRequestInspector({required this.isDebugMode}) {
    navigatorKey = GlobalKey<NavigatorState>();
    di.init();
  }

  void navigateToDetail() {
    if (!isDebugMode) {
      return;
    }

    Navigator.push<void>(
      navigatorKey!.currentState!.context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );

  }

  Interceptor getDioRequestInterceptor() {
    return Interceptor(kIsDebug: isDebugMode);
  }
}
