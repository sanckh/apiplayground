import 'package:apiplayground/models/post_model.dart';
import 'package:apiplayground/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<List<Map<String, dynamic>>> getCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('category')
        .orderBy('sort_order')
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['category_name'],
        'sortOrder': data['sort_order'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getTags() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tag')
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['tag_name'],
      };
    }).toList();
  }

  Stream<List<Topic>> fetchTopics() {
    return FirebaseFirestore.instance.collection('topic').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Topic.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Post>> fetchPosts(String topicId) {
  return FirebaseFirestore.instance.collection('post')
    .where('topic_id', isEqualTo: topicId)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
}

}
