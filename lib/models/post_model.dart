import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String topicId;
  String content;
  Timestamp createdOn;
  String title;
  Timestamp? updatedOn;
  int upvotes;
  int downvotes;
  int netvotes;


  Post({required this.id, 
  required this.topicId, 
  required this.content, 
  required this.title, 
  required this.createdOn, 
  this.updatedOn, 
  required this.upvotes,
  required this.downvotes,
  required this.netvotes, });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
      id: doc.id,
      topicId: data['topic_id'] ?? '',
      content: data['content'] ?? '',
      title: data['title'] ?? '',
      createdOn: data['created_on'],
      updatedOn: data['updated_on'],
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      netvotes: data['netvotes'] ?? 0,
    );
  }

  factory Post.fromAlgolia(AlgoliaObjectSnapshot algoliaSnapshot) {
    Map<String, dynamic> data = algoliaSnapshot.data;
    return Post(
      id: algoliaSnapshot.objectID,
      title: data['title'],
      topicId: data['topic_id'] ?? '',
      content: data['content'] ?? '',
      updatedOn: data['update_on'] != null ? Timestamp.fromMillisecondsSinceEpoch(data['update_on']) : null,
      createdOn: Timestamp.fromMillisecondsSinceEpoch(data['created_on']),
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      netvotes: data['netvotes'] ?? 0,
    );
  }
}
