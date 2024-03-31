import 'package:apiplayground/models/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Tutorial document;

  const DocumentDetailScreen({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.imageUrl != null)
              Image.network(document.imageUrl!),
            Text(
              document.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.0),
            Text(
              'By ${document.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              document.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            HtmlWidget(
              document.content, // Use HtmlWidget to render the HTML content
              // You can customize styling and behavior as needed
            ),
             SizedBox(height: 8.0),
            Text(
              'Tags: ${document.tags.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
