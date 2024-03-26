import 'package:algolia/algolia.dart';
import 'package:apiplayground/services/algolia_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  SearchResultsScreen({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder(
          future: AlgoliaService.queryData(searchQuery),
          builder: (BuildContext context,
              AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found.'));
            } else {
              List<AlgoliaObjectSnapshot> searchResults = snapshot.data!;
              return ListView(
                children: searchResults.map((doc) {
                  final data = doc.data;
                  return ListTile(
                    title: Text(data['title'] ??
                        'No title'), // Replace 'title' with the field name you have in Algolia
                    subtitle: Text(data['author'] ??
                        'No Author'), // Replace 'description' with your field name
                    // Add onTap or other interactive elements as needed
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
