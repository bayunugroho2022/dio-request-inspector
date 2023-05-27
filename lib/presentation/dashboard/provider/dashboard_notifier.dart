import 'dart:async';

import 'package:dio_request_inspector/common/enums.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/domain/usecases/clear_log_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/get_log_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' as di;

class DashboardNotifier extends ChangeNotifier {
  GetLogUseCase? getLogUseCase;
  ClearLogUseCase? clearLogUseCase;
  StreamSubscription<List<HttpActivity>>? _subscription;

  DashboardNotifier({this.getLogUseCase, this.clearLogUseCase}) {
    getLogUseCase = di.GetIt.I<GetLogUseCase>();
    clearLogUseCase = di.GetIt.I<ClearLogUseCase>();
    fetchAllResponses();
  }

  List<HttpActivity> _getAllResponses = <HttpActivity>[];

  List<HttpActivity> get getAllResponses => _getAllResponses;

  RequestState _getAllResponsesState = RequestState.empty;

  RequestState get getAllResponsesState => _getAllResponsesState;

  String _message = '';

  String get message => _message;

  Future<void> fetchAllResponses() async {
    _getAllResponsesState = RequestState.loading;
    notifyListeners();

    final result = await getLogUseCase?.execute();

    result?.fold(
      (failure) {
        _getAllResponsesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (responses) {
        _subscription = responses.listen((event) {
          _getAllResponses = event;
          _getAllResponses.sort(
            (call1, call2) =>
                call2.request?.createdAt?.compareTo(call1.request!.createdAt!) ??
                -1,
          );
          _getAllResponsesState = RequestState.loaded;
          notifyListeners();
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void clearAllResponses() async {
    final result = await clearLogUseCase?.execute();

    result?.fold(
      (failure) {
        _getAllResponsesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (responses) {
        _getAllResponses = [];
        _getAllResponsesState = RequestState.loaded;
        notifyListeners();
      },
    );
  }
  
}
