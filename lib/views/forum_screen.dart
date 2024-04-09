import 'package:apiplayground/widgets/forum_search_results_widget.dart';
import 'package:apiplayground/widgets/search_widget.dart';
import 'package:apiplayground/widgets/topics_list_widget.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    // Get the current search query
    String searchQuery = _searchController.text;
    // Navigate to the ForumSearchResultsScreen with the search query
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ForumSearchResultsScreen(searchQuery: searchQuery),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              onSearch: (query) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForumSearchResultsScreen(searchQuery: query),
                ));
              },
            ),
            Expanded(child: TopicsList()),
          ],
        ),
      ),
    );
  }
}
