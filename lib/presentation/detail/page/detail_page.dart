import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/detail/provider/detail_notifier.dart';
import 'package:dio_request_inspector/presentation/detail/widget/card_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/dio-request-inspector/detail';

  final HttpActivity data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: ChangeNotifierProvider<DetailNotifier>(
          create: (context) => DetailNotifier(
                data: data,
              ),
          builder: (context, child) {
            Color colorByStatusCode = data.response?.responseStatusCode?.colorByStatusCode ?? Colors.red;
            return Scaffold(
              appBar: _appBar(context, colorByStatusCode),
              floatingActionButton: _floatingActionButton(context, colorByStatusCode),
              body: _buildBody(context),
            );
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<DetailNotifier>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _overviewWidget(provider.overviews),
              _requestWidget(provider.requests),
              _responseWidget(provider.responses),
              _errorWidget(provider.errors),
            ],
          ),
        );
      },
    );
  }

  Widget _responseWidget(List<Widget> responses) {
    return ExpansionTile(
        initiallyExpanded: responses.whereType<CardItem>().isNotEmpty,
        title: const Text('Response'),
        children: responses);
  }

  Widget _errorWidget(List<Widget> errors) {
    return Visibility(
      visible: errors.isNotEmpty,
      child: ExpansionTile(
          initiallyExpanded: errors.isNotEmpty,
          title: const Text('Error'),
          children: errors),
    );
  }

  Widget _requestWidget(List<Widget> requests) {
    return ExpansionTile(title: const Text('Request'), children: requests);
  }

  Widget _overviewWidget(List<Widget> overviews) {
    return ExpansionTile(title: const Text('Overview'), children: overviews);
  }

  Widget _floatingActionButton(BuildContext context, Color colorByStatusCode) {
    return FloatingActionButton(
      onPressed: () {
        context.read<DetailNotifier>().share();
      },
    backgroundColor: colorByStatusCode,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100))),
    child: const Icon(Icons.share, color: Colors.white),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, Color colorByStatusCode) {
    return AppBar(
        title: const Text('Detail Activity', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: colorByStatusCode);
  }
}
