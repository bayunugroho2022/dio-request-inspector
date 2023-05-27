import 'package:dio_request_inspector/common/enums.dart';
import 'package:dio_request_inspector/presentation/dashboard/provider/dashboard_notifier.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/item_response_widget.dart';
import 'package:dio_request_inspector/presentation/detail/page/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardNotifier>(
      create: (context) => DashboardNotifier(),
      child: Consumer<DashboardNotifier>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    provider.clearAllResponses();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
              title: const Text('Http Activities'),
              backgroundColor: Colors.purple.withOpacity(0.6),
            ),
            body: buildBody(context, provider),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, DashboardNotifier provider) {
    if (provider.getAllResponsesState == RequestState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (provider.getAllResponses.isEmpty) {
      return const Center(
        child: Text('No Http Activities'),
      );
    } else {
      return ListView.builder(
        itemCount: provider.getAllResponses.length,
        itemBuilder: (context, index) {
          var data = provider.getAllResponses[index];
          return InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    data: data,
                  ),
                ),
              );
            },
            child: ItemResponseWidget(data: data),
          );
        },
      );
    }
  }
}
