import 'package:dio_request_inspector/src/page/resources/app_color.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showSearch;
  final Function(String value) onSearch;
  final TextEditingController controller;
  final Function() onNextSearch;
  final Function() onPreviousSearch;
  final TabController tabController;

  SearchAppBar({
    Key? key,
    required this.showSearch,
    required this.onSearch,
    required this.controller,
    required this.onNextSearch,
    required this.onPreviousSearch, 
    required this.tabController,
  })  : preferredSize =
            const Size.fromHeight(kToolbarHeight + kTextTabBarHeight + 16),
        super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching && widget.showSearch
          ? TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: "Search response body ..",
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black),
              onSubmitted: (value) => widget.onSearch(value),
            )
          : Text(
              'Detail Activity',
              style: TextStyle(color: AppColor.primary),
            ),
      elevation: 3,
      surfaceTintColor: AppColor.white,
      leading: IconButton(
        onPressed: () {
          if (_isSearching) {
            _toggleSearch();
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icon(Icons.arrow_back, color: AppColor.primary),
      ),
      actions: _isSearching && widget.showSearch
          ? [
              IconButton(
                icon: const Icon(Icons.arrow_upward, color: Colors.black),
                onPressed: () {
                  widget.onPreviousSearch();
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: Colors.black),
                onPressed: () {
                  widget.onNextSearch();
                },
              ),
            ]
          : [
              if (widget.showSearch)
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: _toggleSearch,
                ),
            ],
      bottom: TabBar(
        controller: widget.tabController,
        labelStyle: TextStyle(color: AppColor.primary),
        indicatorColor: AppColor.primary,
        tabs: [
          Tab(
            text: 'Overview',
            icon: Icon(Icons.info, color: AppColor.primary),
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
      backgroundColor: AppColor.white,
    );
  }
}
