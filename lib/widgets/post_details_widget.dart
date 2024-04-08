import 'package:apiplayground/services/user_service.dart';
import 'package:apiplayground/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/post_model.dart'; // Import your Post model
import 'package:apiplayground/models/comment_model.dart'; // Import your Comment model
import 'package:apiplayground/services/firebase_service.dart'; // Import your Firebase service

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({Key? key, required this.postId}) : super(key: key);

void _vote(bool isUpvote) async {
    String? userId = UserService().getUserId();

    try {
      // Cast or update the vote
      await FirebaseService().castVote(
        userId: userId!,
        itemId: postId,
        voteType: isUpvote ? 'up' : 'down',
        itemType: 'post',
      );

      // UI feedback or state update might be required here if you're displaying vote counts dynamically

    } catch (error) {
      // Handle errors, such as showing an error message
      print("Error casting vote: $error");
    }
  }


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
              future: FirebaseService().fetchPostDetails(
                  postId), // Implement this method in FirebaseService
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
                      Text(post.title,
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 8),
                      Text(post.content),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () => _vote(true),
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_down),
                            onPressed: () => _vote(false),
                          ),
                          Text('Votes: ${post.netvotes}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            Text('Comments', style: Theme.of(context).textTheme.titleLarge),
            StreamBuilder<List<Comment>>(
              stream: FirebaseService().fetchComments(postId,
                  parentCommentId: ""), // Fetch root-level comments
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<Comment> comments = snapshot.data!;
                return ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling within ListView
                  shrinkWrap:
                      true, // Required to display inside a SingleChildScrollView
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(
                        postId: postId, comment: comments[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
