import 'package:apiplayground/models/document_model.dart';
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
        title: SelectableText(document.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
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
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 800 ? 800 : MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(24.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Page-like background color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (document.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      document.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SelectableText(
                    document.title,
                    style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.deepPurple),
                  ),
                ),
                SelectableText(
                  'By ${document.author}',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16.0),
                SelectableText(
                  document.description,
                  style: Theme.of(context).textTheme.bodyText2,
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
                          SnackBar(content: SelectableText('Could not launch $url')),
                        );
                      }
                      return true;
                    },
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: document.tagIds.map((tag) => Chip(label: SelectableText(tag))).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
