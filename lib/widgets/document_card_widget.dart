import 'package:apiplayground/models/document_model.dart';
import 'package:apiplayground/views/document_detail_screen.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentDetailScreen(document: document)),
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.network(document.imageUrl ?? 'assets/asset3.png'),
            Text(document.title),
            Text(document.author),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
