import 'package:dio_request_inspector/src/common/enum.dart';
import 'package:dio_request_inspector/src/common/storage.dart';
import 'package:dio_request_inspector/src/model/http_activity.dart';
import 'package:dio_request_inspector/src/page/dashboard/widget/item_response_widget.dart';
import 'package:dio_request_inspector/src/page/dashboard/widget/password_protection_dialog.dart';
import 'package:dio_request_inspector/src/page/detail/detail_page.dart';
import 'package:dio_request_inspector/src/page/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  final String password;
  final HttpActivityStorage storage;

  const DashboardPage({Key? key, this.password = '', required this.storage})
      : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<HttpActivity> filteredActivities = [];
  List<HttpActivity> allActivities = [];
  StreamSubscription<List<HttpActivity>>? activitiesSubscription;
  SortActivity currentSort = SortActivity.byTime;

  @override
  void initState() {
    super.initState();
    activitiesSubscription = widget.storage.activities.listen((activities) {
      setState(() {
        allActivities = activities;
        filteredActivities = activities;
        
        filteredActivities.sort((a, b) => b.createdTime.compareTo(a.createdTime));
      });
    });
  }

  @override
  void dispose() {
    activitiesSubscription?.cancel();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      isSearch = !isSearch;
      if (!isSearch) {
        searchController.clear();
        focusNode.unfocus();
        filteredActivities = allActivities;
      }
    });
  }

  void search(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredActivities = allActivities;
      } else {
        filteredActivities = allActivities
            .where((activity) =>
                activity.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void sortAllResponses(SortActivity sortType) {
    setState(() {
      currentSort = sortType;
      switch (sortType) {
        case SortActivity.byTime:
          filteredActivities.sort((a, b) => b.createdTime.compareTo(a.createdTime));
          break;
        case SortActivity.byMethod:
          filteredActivities.sort((a, b) => a.method.compareTo(b.method));
          break;
        case SortActivity.byStatus:
          filteredActivities.sort((a, b) => a.response?.status?.compareTo(b.response?.status ?? 0) ?? 0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          color: AppColor.primary,
          onPressed: () {
            if (isSearch) {
              toggleSearch();
              return;
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        actions: [
          IconButton(
            onPressed: toggleSearch,
            icon: Icon(
              isSearch ? Icons.close : Icons.search,
              color: AppColor.primary,
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.sort,
              color: AppColor.primary,
            ),
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
            onSelected: sortAllResponses,
          ),
        ],
        title: !isSearch
            ? Text('Http Activities', style: TextStyle(color: AppColor.primary))
            : TextField(
                style: TextStyle(color: AppColor.primary),
                autofocus: true,
                onChanged: search,
                focusNode: focusNode,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  focusColor: AppColor.primary,
                  hintStyle: TextStyle(color: AppColor.primary),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: StreamBuilder<List<HttpActivity>>(
            stream: widget.storage.activities,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              if (filteredActivities.isEmpty) {
                return const Text('No data');
              }

              return _buildBody(filteredActivities);
            },
          ),
        ),
      ),
    );
  }

  void dialogInputPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PasswordProtectionDialog(
          password: widget.password,
        );
      },
    );
  }
  
  Widget _buildBody(List<HttpActivity> filteredActivities) {
    return ListView.builder(
        itemCount: filteredActivities.length,
        itemBuilder: (context, index) {
          var data = filteredActivities[index];
          
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
