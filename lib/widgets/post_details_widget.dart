import 'package:flutter/material.dart';
import 'package:apiplayground/models/post_model.dart'; // Import your Post model
import 'package:apiplayground/models/comment_model.dart'; // Import your Comment model
import 'package:apiplayground/services/firebase_service.dart'; // Import your Firebase service

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Post>(
              future: FirebaseService().fetchPostDetails(postId), // Implement this method in FirebaseService
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Text('No post found');
                }
                Post post = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 8),
                      Text(post.content),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            // Placeholder for comments list
            Text('Comments', style: Theme.of(context).textTheme.headline6),
            // FutureBuilder or StreamBuilder for comments will go here
          ],
        ),
      ),
    );
  }
}
