import 'package:apiplayground/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/comment_model.dart';
import 'package:apiplayground/services/firebase_service.dart';

class CommentWidget extends StatelessWidget {
  final String postId;
  final Comment comment;

  const CommentWidget({
    Key? key,
    required this.postId,
    required this.comment,
  }) : super(key: key);

  void _vote(bool isUpvote) async {
    String? userId = UserService().getUserId();

    try {
      // Cast or update the vote
      await FirebaseService().castVote(
        userId: userId!,
        itemId: comment.id,
        voteType: isUpvote ? 'up' : 'down',
        itemType: 'comment',
      );
      // UI feedback or state update might be required here if you're displaying vote counts dynamically

    } catch (error) {
      // Handle errors, such as showing an error message
      print("Error casting vote: $error");
    }
  }

  void _showReplyDialog(BuildContext context) {
  TextEditingController _replyController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Reply to Comment"),
        content: TextField(
          controller: _replyController,
          decoration: InputDecoration(hintText: "Type your reply here..."),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Reply"),
            onPressed: () async {
              if (_replyController.text.isNotEmpty) {
                String? userId = UserService().getUserId();
                if (userId != null) {
                  await FirebaseService().addComment(
                    postId,
                    userId,
                    _replyController.text,
                    parentCommentId: comment.id,
                  );
                  Navigator.of(context).pop(); // Close the dialog
                  // Optionally, trigger a state update to show the new comment
                }
              }
            },
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<String>(
          future: UserService().fetchUsernameByUserId(comment.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              // Handle the error state or log the error
              return Text("Error fetching username");
            }
            String username = snapshot.data!;
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 4),
                      Text(comment.content),
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
                          Text('Votes: ${comment.netvotes}'),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () => _showReplyDialog(context),
                          ),
                        ],
                      ),
                    ]),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: StreamBuilder<List<Comment>>(
            stream: FirebaseService()
                .fetchComments(postId, parentCommentId: comment.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              List<Comment> childComments = snapshot.data!;
              return Column(
                children: childComments
                    .map((childComment) =>
                        CommentWidget(postId: postId, comment: childComment))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
