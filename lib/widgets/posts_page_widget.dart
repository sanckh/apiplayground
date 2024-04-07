import 'package:apiplayground/models/post_model.dart';
import 'package:apiplayground/services/firebase_service.dart';
import 'package:apiplayground/widgets/create_post_widget.dart';
import 'package:apiplayground/widgets/post_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatelessWidget {
  final String topicId;

  PostsPage({required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: FirebaseService().fetchPosts(topicId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<Post> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Post post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailsPage(postId: post.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the CreatePostScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(topicId: topicId),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Post',
      ),
    );
  }
}
