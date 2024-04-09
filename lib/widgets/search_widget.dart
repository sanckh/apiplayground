import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;

  SearchWidget({required this.onSearch});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
            onSubmitted: (_) => _handleSearch(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: _handleSearch,
        ),
      ],
    );
  }
}