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

  Future<DocumentReference> addPost(String topicId, String title, String content, String userId) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('post');
    return posts.add({
      'topic_id': topicId,
      'title': title,
      'content': content,
      'created_on': Timestamp.now(),
      'updated_on': '',
      'user_id': userId,
    });
  }

    Future<DocumentReference> addComment(String postId, String userId, String content, {String parentCommentId = ''}) async {
    CollectionReference comments = FirebaseFirestore.instance.collection('comment');
    return comments.add({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_comment_id': parentCommentId,
      'upvotes': 0,
      'downvotes': 0,
      'netvotes' : 0,
      'created_on': Timestamp.now(),
    });
  }

Future<void> castVote({
  required String userId, 
  required String itemId, 
  required String voteType, 
  required String itemType
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Construct a unique document ID using the item type, item ID, and user ID
  String docId = '$itemType-$itemId-$userId';

  // Define the document reference in the 'votes' collection
  DocumentReference voteRef = firestore.collection('vote').doc(docId);

  // Prepare the vote data
  Map<String, dynamic> voteData = {
    'user_id': userId,
    'item_id': itemId,
    'vote_type': voteType,
    'item_type': itemType, // This helps to differentiate between a vote on a post or a comment
  };

  // Write the vote data to Firestore
  await voteRef.set(voteData);
}

Future<void> updateVoteCount(String itemId, int change, String itemType) async {
  final DocumentReference itemRef = FirebaseFirestore.instance
      .collection(itemType)
      .doc(itemId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(itemRef);

    if (!snapshot.exists) {
      throw Exception("$itemType does not exist!");
    }

    int currentVotes = (snapshot.data() as Map<String, dynamic>)['netvotes'] ?? 0;
    transaction.update(itemRef, {'netvotes': currentVotes + change});
  });
}




}
