import 'package:apiplayground/models/documents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Document document;

  const DocumentDetailScreen({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Enhanced UI feature
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Add share functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Adds rounded corners to the image
                child: Image.network(
                  document.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                document.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepPurple),
              ),
            ),
            Text(
              'By ${document.author}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16.0),
            Text(
              document.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HtmlWidget(
                document.content,
                onTapUrl: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $url')),
                    );
                  }
                  return true;
                },
              ),
            ),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: document.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.edit),
        onPressed: () {
          // Add edit functionality here
        },
      ),
    );
  }
}
