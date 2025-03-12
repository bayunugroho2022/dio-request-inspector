import 'dart:async';

import 'package:dio_request_inspector/src/common/copy.dart';
import 'package:dio_request_inspector/src/common/extensions.dart';
import 'package:dio_request_inspector/src/common/helpers.dart';
import 'package:dio_request_inspector/src/model/http_activity.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/item_column.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/item_row.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/search_app_bar.dart';
import 'package:dio_request_inspector/src/page/detail/widgets/search_highlight.dart';
import 'package:dio_request_inspector/src/page/resources/app_color.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final HttpActivity data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late SearchHighlightWidget _highlightTextController;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  Timer? _debounceTimer;
  late TabController _tabController;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    final response = widget.data.response?.body ?? '';
    _highlightTextController = SearchHighlightWidget(
      text: response.isJson ? response.prettify : response,
      scrollController: _scrollController,
      selectedTextBackgroundColor: Colors.orange,
      highlightTextBackgroundColor: Colors.yellow,
      selectedHighlightedTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 19,
      ),
      highlightedTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 19,
      ),
    );

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 2) {
        setState(() {
          _showSearch = true;
        });
      } else {
        setState(() {
          _showSearch = false;
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 0), () {
      _highlightTextController.highlightSearchTerm(query);
    });
  }

  @override
  void dispose() {
    _highlightTextController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "button_copy_curl",
                backgroundColor: AppColor.primary,
                shape: const CircleBorder(),
                onPressed: () {
                  Helper.copyToClipboard(
                    context: context,
                    text: Copy.getCurlCommand(widget.data),
                    message: 'Curl command copied to clipboard',
                  );
                 },
                child: Icon(
                  Icons.code,
                  color: AppColor.white,
                ),
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                heroTag: "button_copy_activity",
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
            ],
          ),
          backgroundColor: AppColor.white,
          appBar: SearchAppBar(
            tabController: _tabController,
            showSearch: _showSearch,
            controller: _searchController,
            onSearch: (value) => _onSearchChanged(value),
            onNextSearch: () {
              _highlightTextController.highlightNext();
            },
            onPreviousSearch: () {
              _highlightTextController.highlightPrevious();
            },
          ),
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
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
      controller: _highlightTextController.scrollController,
      physics: const BouncingScrollPhysics(),
      child: ValueListenableBuilder<List<HighlightSpanWidget>>(
        valueListenable: _highlightTextController.highlightsNotifier,
        builder: (context, highlights, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                ItemRow(name: 'Received :', value: data.response?.time.toString()),
                ItemRow(name: 'Status Code :', value: data.response?.status.toString()),
                ItemRow(name: 'Bytes Received :', value: Helper.formatBytes(data.response?.size ?? 0)),
                ItemRow(name: 'Headers', value: Helper.encodeRawJson(data.response?.headers), useHeaderFormat: true),
                if (!isImage) ItemColumn(
                  name: 'Body :',
                  value: data.response?.body,
                  child: TextField(
                    readOnly: true,
                    controller: _highlightTextController,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: (value) {
                      _onSearchChanged(_searchController.text.trim());
                    },
                  ),
                ),
                if (isImage) ItemColumn(name: 'Body :', value: '', isImage: isImage, showCopyButton: false,),
              ],
            ),
          );
        }
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
