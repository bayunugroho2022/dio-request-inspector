import 'package:dio_request_inspector/common/injection.dart';
import 'package:dio_request_inspector/common/snack_bar.dart';
import 'package:dio_request_inspector/domain/usecases/save_error_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_request_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_response_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Interceptor extends InterceptorsWrapper {
  SaveResponseUseCase? saveResponseUseCase;
  SaveRequestUseCase? saveRequestUseCase;
  SaveErrorUseCase? saveErrorUseCase;
  final bool kIsDebug;
  final bool showFloating;
  final Duration? duration;
  GlobalKey<NavigatorState>? navigatorKey;
  void Function()? navigateToDetail;

  Interceptor({
    this.saveResponseUseCase,
    this.saveRequestUseCase,
    this.saveErrorUseCase,
    this.kIsDebug = false,
    this.showFloating = true,
    this.navigatorKey,
    this.duration,
    this.navigateToDetail,
  }) {
    saveErrorUseCase = locator<SaveErrorUseCase>();
    saveResponseUseCase = locator<SaveResponseUseCase>();
    saveRequestUseCase = locator<SaveRequestUseCase>();
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (kIsDebug) {
      if (saveRequestUseCase != null) {
        await saveRequestUseCase!.execute(options);
      }
      _showSnackBar(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kIsDebug) {
      if (saveResponseUseCase != null) {
        await saveResponseUseCase!.execute(response);
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kIsDebug) {
      if (saveErrorUseCase != null) {
        await saveErrorUseCase!.execute(err);
      }
    }
    handler.next(err);
    super.onError(err, handler);
  }

  void _showSnackBar(RequestOptions options) {
    if (!showFloating) {
      return;
    }

    SnackBarHelper.showSnackBar(
      context: navigatorKey?.currentState?.context,
      duration: duration,
      title: options.method,
      content: options.path,
      action: navigateToDetail,
    );
  }
}
