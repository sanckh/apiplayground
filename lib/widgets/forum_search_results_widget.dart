import 'package:apiplayground/models/post_model.dart';
import 'package:apiplayground/widgets/post_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:apiplayground/services/algolia_service.dart';

class ForumSearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  ForumSearchResultsScreen({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: FutureBuilder(
        future: AlgoliaService.queryPostData(searchQuery),
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
                Post post = Post.fromAlgolia(searchResults[index]);
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(post.content, overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PostDetailsPage(postId: post.id),
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
