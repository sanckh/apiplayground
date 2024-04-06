import 'package:apiplayground/models/comment_model.dart';
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
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('tag').get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['tag_name'],
      };
    }).toList();
  }

  Stream<List<Topic>> fetchTopics() {
    return FirebaseFirestore.instance
        .collection('topic')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Topic.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Post>> fetchPosts(String topicId) {
    return FirebaseFirestore.instance
        .collection('post')
        .where('topic_id', isEqualTo: topicId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  Future<Post> fetchPostDetails(String postId) async {
    var doc =
        await FirebaseFirestore.instance.collection('post').doc(postId).get();
    return Post.fromFirestore(doc);
  }

  Stream<List<Comment>> fetchComments(String postId,
      {String? parentCommentId}) {
    Query query = FirebaseFirestore.instance
        .collection('comment')
        .where('post_id', isEqualTo: postId);

    if (parentCommentId != null) {
      query = query.where('parent_comment_id', isEqualTo: parentCommentId);
    } else {
      query = query.where('parent_comment_id', isEqualTo: "");
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList());
  }

  Future<String> fetchUsernameByUserId(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
   if (userDoc.exists && userDoc.data() is Map<String, dynamic> && (userDoc.data() as Map<String, dynamic>).containsKey('username')) {
      return (userDoc.data() as Map<String, dynamic>)['username'] as String;
    } else {
      throw Exception('User not found for ID: $userId');
    }
  }
}
