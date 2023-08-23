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
  FocusNode focusNode = FocusNode();  
  
  DashboardNotifier({this.getLogUseCase, this.clearLogUseCase}) {
    getLogUseCase = di.GetIt.I<GetLogUseCase>();
    clearLogUseCase = di.GetIt.I<ClearLogUseCase>();
    fetchAllResponses();
  }

  List<HttpActivity> _getAllResponses = <HttpActivity>[];

  List<HttpActivity> get getAllResponses => _getAllResponses;

  List<HttpActivity> _activityFromSearch = <HttpActivity>[];

  List<HttpActivity> get activityFromSearch => _activityFromSearch;

  RequestState _getAllResponsesState = RequestState.empty;

  RequestState get getAllResponsesState => _getAllResponsesState;

  String _message = '';

  TextEditingController searchController = TextEditingController();

  String get message => _message;

  bool isSearch = false;

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
        
          notifyListeners();
        });
      },      
    );
    
      _getAllResponsesState = RequestState.loaded;
      notifyListeners();
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

  void sortAllResponses(SortActivity value) {
    switch (value) {
      case SortActivity.byTime:
        _getAllResponses.sort(
          (call1, call2) =>
              call2.request?.createdAt?.compareTo(call1.request!.createdAt!) ??
              -1,
        );
        break;
      case SortActivity.byMethod:
        _getAllResponses.sort(
          (call1, call2) =>
              call1.request?.method?.compareTo(call2.request!.method!) ?? -1,
        );
        break;
      case SortActivity.byStatus:
        _getAllResponses.sort(
          (call1, call2) =>
              call1.response?.responseStatusCode
                      ?.compareTo(call2.response!.responseStatusCode!) ??
                  -1,
        );
        break;
    }

    notifyListeners();
  }

  void toggleSearch() {
    isSearch = !isSearch;
    notifyListeners();

    if (isSearch) {
      focusNode.requestFocus();
      searchController.text = '';
      search(searchController.text);
      return;
    } 
  }

  void search(String value) {
    if (value.isEmpty) {
      _activityFromSearch = _getAllResponses;
      notifyListeners();
      return;
    }
    _activityFromSearch = _getAllResponses
        .where((element) =>
            element.request?.path?.contains(value) ?? false)
        .toList();

    notifyListeners();
  }
  
}
