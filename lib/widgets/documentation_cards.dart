import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/documents.dart';
import 'package:apiplayground/widgets/document_card_widget.dart';

class DocumentationCards extends StatelessWidget {
  final List<AlgoliaObjectSnapshot> algoliaSnapshots;

  const DocumentationCards({Key? key, required this.algoliaSnapshots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return algoliaSnapshots.isEmpty
        ? Center(child: Text("No results found"))
        : ListView.builder(
            itemCount: algoliaSnapshots.length,
            itemBuilder: (context, index) {
              Document document = Document.fromAlgolia(algoliaSnapshots[index]);
              return DocumentCard(document: document);
            },
          );
  }
}
