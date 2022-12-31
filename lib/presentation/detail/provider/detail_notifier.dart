import 'dart:convert';

import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/common/utils/date_time_util.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/detail/widget/overview_item_widget.dart';
import 'package:dio_request_inspector/presentation/detail/widget/card_item_widget.dart';
import 'package:dio_request_inspector/presentation/detail/widget/response_header_widget.dart';
import 'package:flutter/material.dart';

class DetailNotifier extends ChangeNotifier {
  HttpActivity? data;

  DetailNotifier({required this.data}) {
    init();
  }
  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  final _dateTimeUtils = DateTimeUtil();

  List<Widget> _overviews = <Widget>[];

  List<Widget> get overviews => _overviews;

  List<Widget> _requests = <Widget>[];

  List<Widget> get requests => _requests;

  List<Widget> _responses = <Widget>[];

  List<Widget> get responses => _responses;

  List<Widget> _errors = <Widget>[];

  List<Widget> get errors => _errors;

  void init() {
    // overview
    _overviews = <Widget>[];
    final duration = _dateTimeUtils.milliSecondDifference(data?.request?.createdAt, data?.response?.createdAt);
    _overviews.add(ListRowWidget(name: "Method: ", value: "${data?.request?.method}"));
    _overviews.add(ListRowWidget(
        name: "Host: ",
        value: data!.request!.secure!
            ? "https://${data?.request!.server!}"
            : "http://${data?.request!.server!}"));
    _overviews.add(ListRowWidget(name: "Endpoint: ", value: '${data?.request?.path}'));
    _overviews.add(ListRowWidget(name: "Duration:", value: duration));
    _overviews.add(ListRowWidget(name: "Client:", value: '${data?.request?.client}'));
    _overviews.add(ListRowWidget(name: "Secure:", value: '${data?.request?.secure}'));
    _overviews.add(const ListRowWidget(space: 10));

    // request
    _requests = <Widget>[];
    _requests.add(CardItem(name: "Started: ", value: '${data?.request?.createdAt?.toDateTime}'));
    _requests.add(CardItem(name: "Bytes sent: ", value: '${data?.request?.requestSize.byteToKiloByte()}'));
    _requests.add(CardItem(name: "Header:", value: data?.request?.requestHeader ?? "N/A"));
    _requests.add(CardItem(name: "Query Parameter:", value: data?.request?.params ?? "N/A"));
    _requests.add(CardItem(name: "Body:", value: data?.request?.requestBody ?? "N/A",));

    // response
    _responses = <Widget>[];
    _responses.add(const ListRowWidget(space: 8));
    _responses.add(ListRowWidget(name: 'Received: ', value: '${data?.response?.createdAt?.toDateTime}'));
    _responses.add(ListRowWidget(name: "Status Code:", value: '${data?.response?.responseStatusCode}'));
    if (data?.response?.responseSize != null) _responses.add(ListRowWidget(name: "Bytes received:", value: '${data?.response?.responseSize.byteToKiloByte()}'));
    _responses.add(ResponseHeaderWidget(headers: data?.response?.responseHeader,));
    _responses.add(CardItem(name: "Body", value: data?.response?.responseBody ?? "N/A"));
    _responses.add(const ListRowWidget(space: 20));

    //error
    _errors = <Widget>[];
    if (data?.error?.errorMessage != null) _errors.add(CardItem(name: "Error: ", value: data?.error?.errorMessage));
    notifyListeners();
  }

  static String parseJson(dynamic json) {
    try {
      return encoder.convert(json);
    } catch (exception) {
      return json.toString();
    }
  }

}
