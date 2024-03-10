import 'dart:convert';

import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/common/share.dart';
import 'package:dio_request_inspector/common/utils/date_time_util.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/detail/widget/overview_item_widget.dart';
import 'package:dio_request_inspector/presentation/detail/widget/card_item_widget.dart';
import 'package:dio_request_inspector/presentation/detail/widget/response_header_widget.dart';
import 'package:flutter/material.dart';

class DetailNotifier extends ChangeNotifier {
  HttpActivity? data;
  final ShareActivity? shareActivity = ShareActivity();

  DetailNotifier({this.data}) {
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
    const showCopyButton = true;

    // overview
    _overviews = <Widget>[];
    final duration = _dateTimeUtils.milliSecondDifference(
        data?.request?.createdAt, data?.response?.createdAt);
    _overviews.add(
        ListRowWidget(name: "Method: ", value: "${data?.request?.method}"));
    _overviews.add(ListRowWidget(
        name: "Host: ",
        value: data!.request!.secure!
            ? "https://${data?.request!.server!}"
            : "http://${data?.request!.server!}"));
    _overviews.add(
        ListRowWidget(name: "Endpoint: ", value: '${data?.request?.path}'));
    _overviews.add(ListRowWidget(name: "Duration:", value: duration));
    _overviews
        .add(ListRowWidget(name: "Client:", value: '${data?.request?.client}'));
    _overviews
        .add(ListRowWidget(name: "Secure:", value: '${data?.request?.secure}'));
    _overviews.add(const ListRowWidget(space: 10));

    // request
    _requests = <Widget>[];
    _requests.add(CardItem(
        name: "Started: ",
        value: '${data?.request?.createdAt?.toDateTime}',
        showCopyButton: showCopyButton));
    _requests.add(CardItem(
        name: "Bytes sent: ",
        value: '${data?.request?.requestSize.byteToKiloByte()}',
        showCopyButton: showCopyButton));
    _requests.add(CardItem(
        name: "Header:",
        value: data?.request?.requestHeader ?? "N/A",
        showCopyButton: showCopyButton));
    _requests.add(CardItem(
        name: "Query Parameter:",
        value: data?.request?.params ?? "N/A",
        showCopyButton: showCopyButton));
    _requests.add(CardItem(
        name: "Body:",
        value: data?.request?.requestBody ?? "N/A",
        showCopyButton: showCopyButton));

    // response
    _responses = <Widget>[];
    _responses.add(const ListRowWidget(space: 8));
    _responses.add(ListRowWidget(
        name: 'Received: ', value: '${data?.response?.createdAt?.toDateTime}'));
    _responses.add(ListRowWidget(
        name: "Status Code:", value: '${data?.response?.responseStatusCode}'));
    if (data?.response?.responseSize != null) {
      _responses.add(ListRowWidget(
          name: "Bytes received:",
          value: '${data?.response?.responseSize.byteToKiloByte()}'));
    }
    _responses.add(ResponseHeaderWidget(
      headers: data?.response?.responseHeader,
    ));

    var contentTypeList = data?.response?.responseHeader?["content-type"];
    if (contentTypeList != null && contentTypeList.any((contentType) => contentType.contains("image"))) {
      final uri = data!.request!.secure!
          ? "https://${data?.request!.server!}${data?.request?.path}"
          : "http://${data?.request!.server!}${data?.request?.path}";

      _responses.add(CardItem(
          name: "Body",
          isImage: true,
          value: uri, 
      ));
    } else {
      _responses.add(CardItem(
        name: "Body",
        value: data?.response?.responseBody ?? "N/A",
        showCopyButton: showCopyButton));
    }

    _responses.add(const ListRowWidget(space: 20));

    //error
    _errors = <Widget>[];
    if (data?.error?.errorMessage != null) {
      _errors.add(CardItem(
          name: "Error: ",
          value: data?.error?.errorMessage,
          showCopyButton: showCopyButton));
    }
    notifyListeners();
  }

  void share() {
    shareActivity?.data(data!);
  }
}
