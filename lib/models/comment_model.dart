import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String postId;
  String parentCommentId;
  String content;
  int upvotes;
  int downvotes;

  Comment({
    required this.id,
    required this.postId,
    required this.parentCommentId,
    required this.content,
    required this.upvotes,
    required this.downvotes,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Comment(
      id: doc.id,
      postId: data['postId'] ?? '',
      parentCommentId: data['parentCommentId'] ?? '',
      content: data['content'] ?? '',
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
    );
  }
}
