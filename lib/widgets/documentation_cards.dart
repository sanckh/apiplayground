import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/documents.dart'; // Import your Document model
import 'package:apiplayground/widgets/document_card_widget.dart';

class DocumentationCards extends StatelessWidget {
  final List<AlgoliaObjectSnapshot> algoliaSnapshots;

  const DocumentationCards({Key? key, required this.algoliaSnapshots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: algoliaSnapshots.length,
      itemBuilder: (context, index) {
        // Map AlgoliaObjectSnapshot to your Document model
        Document document = Document.fromAlgolia(algoliaSnapshots[index]);
        // Use your existing DocumentCard widget
        return DocumentCard(document: document);
      },
    );
  }
}