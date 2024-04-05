import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String topicId;
  String content;
  Timestamp createdOn;
  String title;
  Timestamp updatedOn;


  Post({required this.id, required this.topicId, required this.content, required this.title, required this.createdOn, required this.updatedOn });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
      id: doc.id,
      topicId: data['topicId'] ?? '',
      content: data['content'] ?? '',
      title: data['title'] ?? '',
      createdOn: data['created_on'],
      updatedOn: data['updated_on']
    );
  }
}
