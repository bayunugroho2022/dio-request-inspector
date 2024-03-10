import 'package:dio_request_inspector/common/enums.dart';
import 'package:dio_request_inspector/presentation/dashboard/provider/dashboard_notifier.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/item_response_widget.dart';
import 'package:dio_request_inspector/presentation/detail/page/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = '/dio-request-inspector/dashboard';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: ChangeNotifierProvider<DashboardNotifier>(
        create: (context) => DashboardNotifier(),
        child: Consumer<DashboardNotifier>(
          builder: (context, provider, child) {
            return Scaffold(
                backgroundColor: Colors.grey[200],
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    provider.clearAllResponses();
                  },
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                          topLeft: Radius.circular(100))),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                appBar: AppBar(
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {
                      if (provider.isSearch) {
                        provider.toggleSearch();
                        return;
                      }
    
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          provider.toggleSearch();
                        },
                        icon: Icon(
                          provider.isSearch ? Icons.close : Icons.search,
                          color: Colors.white,
                        )),
                    PopupMenuButton(
                        icon: const Icon(Icons.sort),
                        iconColor: Colors.white,
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: SortActivity.byTime,
                              child: Text('Time'),
                            ),
                            const PopupMenuItem(
                              value: SortActivity.byMethod,
                              child: Text('Method'),
                            ),
                            const PopupMenuItem(
                              value: SortActivity.byStatus,
                              child: Text('Status'),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          provider.sortAllResponses(value);
                        })
                  ],
                  title: !provider.isSearch
                      ? const Text('Http Activities',
                          style: TextStyle(color: Colors.white))
                      : TextField(
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          onChanged: (value) {
                            provider.search(value);
                          },
                          focusNode: provider.focusNode,
                          controller: provider.searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.white), // Set focused border color
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.white), // Set enabled border color
                            ),
                          ),
                        ),
                  backgroundColor: Colors.green,
                ),
                body: buildBody(context, provider));
          },
        ),
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
        itemCount: provider.isSearch
            ? provider.activityFromSearch.length
            : provider.getAllResponses.length,
        itemBuilder: (context, index) {
          var data = provider.isSearch
              ? provider.activityFromSearch[index]
              : provider.getAllResponses[index];
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
