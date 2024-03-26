import 'package:apiplayground/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final SearchService _searchService = SearchService();

  SearchResultsScreen({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder(
        future: _searchService.performSearch(searchQuery),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No results found.'));
          } else {
            List<DocumentSnapshot> searchResults = snapshot.data!;
            return ListView(
              children: searchResults.map((doc) => ListTile(
                title: Text(doc['title']), // Replace with actual data field
                subtitle: Text(doc['description']), // Replace with actual data field
                // Add onTap or other interactive elements as needed
              )).toList(),
            );
          }
        },
      ),
    );
  }
}