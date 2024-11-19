import 'package:dio_request_inspector/src/common/copy.dart';
import 'package:dio_request_inspector/src/common/helpers.dart';
import 'package:dio_request_inspector/src/model/http_activity.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/item_column.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/item_row.dart';
import 'package:dio_request_inspector/src/page/resources/app_color.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final HttpActivity data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.primary,
            shape: const CircleBorder(),
            onPressed: () {
              Helper.copyToClipboard(
                context: context,
                text: Copy.getActivity(widget.data),
                message: 'Activity copied to clipboard',
              );
             },
            child: Icon(
              Icons.copy,
              color: AppColor.white,
            ),
          ),
          backgroundColor: AppColor.white,
          appBar: _appBar(context),
          body: _buildBody(context),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
        title: Text('Detail Activity',
            style: TextStyle(
              color: AppColor.primary,
            )),
        elevation: 3,
        surfaceTintColor: AppColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.code,
              size: 20,
              color: AppColor.primary,
            ),
            onPressed: () {
              Helper.copyToClipboard(
                context: context,
                text: Copy.getCurlCommand(widget.data),
                message: 'Curl command copied to clipboard',
              );
            },
          ),
        ],
        bottom: TabBar(
          labelStyle: TextStyle(color: AppColor.primary),
          indicatorColor: AppColor.primary,
          tabs: [
            Tab(
              text: 'Overview',
              icon: Icon(
                Icons.info,
                color: AppColor.primary,
              ),
            ),
            Tab(
              text: 'Request',
              icon: Icon(Icons.arrow_upward, color: AppColor.primary),
            ),
            Tab(
              text: 'Response',
              icon: Icon(Icons.arrow_downward, color: AppColor.primary),
            ),
            Tab(
              text: 'Error',
              icon: Icon(Icons.warning, color: AppColor.primary),
            ),
          ],
        ),
        backgroundColor: AppColor.white);
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        _overviewWidget(widget.data),
        _requestWidget(widget.data),
        _responseWidget(widget.data),
        _errorWidget(widget.data),
      ],
    );
  }

  Widget _overviewWidget(HttpActivity data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            ItemRow(name: 'Method', value: data.method),
            ItemRow(name: 'Server', value: data.server),
            ItemRow(name: 'Endpoint', value: data.endpoint),
            ItemRow(name: 'Time', value: data.request?.time.toString()),
            ItemRow(name: 'Started', value: data.response?.time.toString()),
            ItemRow(name: 'Duration', value: Helper.formatTime(data.duration)),
            ItemRow(
                name: 'Bytes Sent',
                value: Helper.formatBytes(data.request?.size ?? 0)),
            ItemRow(
                name: 'Bytes Received',
                value: Helper.formatBytes(data.response?.size ?? 0)),
            ItemRow(name: 'Secure', value: data.secure.toString()),
          ],
        ),
      ),
    );
  }

  Widget _requestWidget(HttpActivity data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            ItemColumn(name: 'Started :', value: data.request?.time.toString()),
            ItemColumn(
                name: 'Bytes Sent :',
                value: Helper.formatBytes(data.request?.size ?? 0)),
            ItemColumn(
                name: 'Header :',
                value: Helper.encodeRawJson(data.request!.headers)),
            ItemColumn(
                name: 'Query Parameters :',
                value: Helper.encodeRawJson(data.request?.queryParameters)),
            ItemColumn(
                name: 'Body :',
                value: data.request?.body,
                isImage: data.request?.contentType?.contains('image') ?? false),
          ],
        ),
      ),
    );
  }

  Widget _responseWidget(HttpActivity data) {
    var contentTypeList = data.response?.headers?["content-type"];
    final isImage = contentTypeList != null && contentTypeList.any((element) => element.contains('image'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            ItemRow(name: 'Received :', value: data.response?.time.toString()),
            ItemRow(name: 'Status Code :', value: data.response?.status.toString()),
            ItemRow(name: 'Bytes Received :', value: Helper.formatBytes(data.response?.size ?? 0)),
            ItemRow(name: 'Headers', value: Helper.encodeRawJson(data.response?.headers), useHeaderFormat: true),
            if (!isImage) ItemColumn(name: 'Body :', value: data.response?.body),
            if (isImage) ItemColumn(name: 'Body :', value: '', isImage: isImage, showCopyButton: false,),
          ],
        ),
      ),
    );
  }

  Widget _errorWidget(HttpActivity data) {
    if (data.error?.error == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: AppColor.primary, size: 60),
              SizedBox(height: 14),
              Text('No error found', style: TextStyle(color: AppColor.primary, fontSize: 20)),
            ],
          ),
        ),
      );
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ItemColumn(name: 'Error :', value: data.error?.error.toString()),
          ],
        ),
      ),
    );
  }
}
