import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String userId;
  String postId;
  String parentCommentId;
  String content;
  int upvotes;
  int downvotes;
  int netvotes;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.parentCommentId,
    required this.content,
    required this.upvotes,
    required this.downvotes,
    required this.netvotes,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Comment(
      id: doc.id,
      userId: data['user_id'] ?? '',
      postId: data['post_id'] ?? '',
      parentCommentId: data['parent_comment_id'] ?? '',
      content: data['content'] ?? '',
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      netvotes: data['netvotes'] ?? 0,
    );
  }
}
