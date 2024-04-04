import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/documents.dart';
import 'package:apiplayground/widgets/document_card_widget.dart';

class DocumentationCards extends StatelessWidget {
  final List<AlgoliaObjectSnapshot> algoliaSnapshots;
  final bool hasSearched; // Add a flag to indicate if a search has been initiated

  const DocumentationCards({
    Key? key,
    required this.algoliaSnapshots,
    this.hasSearched = false, // Default to false, indicating no search has been performed yet
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show "Use a filter to begin your search" if no search has been performed
    if (algoliaSnapshots.isEmpty && !hasSearched) {
      return Center(child: Text("Use a filter to begin your search"));
    }
    // Show "No results found" if a search has been performed but no results are found
    else if (algoliaSnapshots.isEmpty && hasSearched) {
      return Center(child: Text("No results found"));
    }
    // Render the list of results if there are any
    return ListView.builder(
      itemCount: algoliaSnapshots.length,
      itemBuilder: (context, index) {
        Document document = Document.fromAlgolia(algoliaSnapshots[index]);
        return DocumentCard(document: document);
      },
    );
  }
}
