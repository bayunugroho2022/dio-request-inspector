import 'package:dio_request_inspector/common/injection.dart';
import 'package:dio_request_inspector/domain/usecases/save_error_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_request_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_response_usecase.dart';
import 'package:dio/dio.dart';

class Interceptor extends InterceptorsWrapper {
  SaveResponseUseCase? saveResponseUseCase;
  SaveRequestUseCase? saveRequestUseCase;
  SaveErrorUseCase? saveErrorUseCase;
  final bool kIsDebug;

  Interceptor(
      {this.saveResponseUseCase,
      this.saveRequestUseCase,
      this.saveErrorUseCase,
      this.kIsDebug = false}) {
    saveErrorUseCase = locator<SaveErrorUseCase>();
    saveResponseUseCase = locator<SaveResponseUseCase>();
    saveRequestUseCase = locator<SaveRequestUseCase>();
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (kIsDebug) {
      await saveRequestUseCase!.execute(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kIsDebug) {
      await saveResponseUseCase!.execute(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kIsDebug) {
      await saveErrorUseCase!.execute(err);
    }
    handler.next(err);
    super.onError(err, handler);
  }
}
