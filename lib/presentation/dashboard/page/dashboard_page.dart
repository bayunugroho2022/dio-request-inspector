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
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Http Activities'),
          backgroundColor: Colors.purple.withOpacity(0.6),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<DashboardNotifier>(context, listen: false).fetchAllResponses();
              },
            ),
          ],
        ),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<DashboardNotifier>(
      builder: (context, provider, child) {
        if (provider.getAllResponsesState == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (provider.getAllResponses.isEmpty) {
          return const Center(
            child: Text('No Http Activities'),
          );
        }
        return ListView.builder(
          itemCount: provider.getAllResponses.length,
          itemBuilder: (context, index) {
            var data = provider.getAllResponses[index];
            return InkWell(
                onTap: () {
                  Navigator.push<void>(context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        data: data,
                      ),
                    ),
                  );
                },
                child: ItemResponseWidget(data: data));
          },
        );
      },
    );
  }

}
