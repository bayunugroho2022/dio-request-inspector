import 'dart:async';

import 'package:dio_request_inspector/common/enums.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';

import 'package:get_it/get_it.dart' as di;
import 'package:dio_request_inspector/domain/usecases/get_log_usecase.dart';
import 'package:flutter/material.dart';

class DashboardNotifier extends ChangeNotifier {
  GetLogUseCase? getLogUseCase;

  DashboardNotifier({this.getLogUseCase}) {
    getLogUseCase = di.GetIt.I<GetLogUseCase>();
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

    final result = await getLogUseCase!.execute();

    result.fold(
      (failure) {
        _getAllResponsesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (responses) {
        _getAllResponsesState = RequestState.loaded;
        _getAllResponses = responses;
        _getAllResponses.sort(
              (call1, call2) =>
          call2.request?.createdAt?.compareTo(call1.request!.createdAt!) ?? -1,
        );
        notifyListeners();
      },
    );
  }
}