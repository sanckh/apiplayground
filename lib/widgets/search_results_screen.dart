import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:apiplayground/models/document_model.dart';
import 'package:apiplayground/services/algolia_service.dart';
import 'package:apiplayground/views/document_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  SearchResultsScreen({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: FutureBuilder(
        future: AlgoliaService.queryDocumentationData(searchQuery),
        builder: (context, AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No results found.'));
          } else {
            List<AlgoliaObjectSnapshot> searchResults = snapshot.data!;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                Document document = Document.fromAlgolia(searchResults[index]);
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: document.imageUrl != null
                        ? Image.network(document.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                        : null, // Consider a placeholder if no image
                    title: Text(document.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(document.description, overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DocumentDetailScreen(document: document),
                      ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
