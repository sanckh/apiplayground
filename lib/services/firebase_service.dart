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

  Future<DocumentReference> addPost(
      String topicId, String title, String content, String userId) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('post');
    return posts.add({
      'topic_id': topicId,
      'title': title,
      'content': content,
      'created_on': Timestamp.now(),
      'updated_on': null,
      'user_id': userId,
      'upvotes': 0,
      'downvotes': 0,
      'netvotes': 0
    });
  }

  Future<DocumentReference> addComment(
      String postId, String userId, String content,
      {String parentCommentId = ''}) async {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comment');
    return comments.add({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_comment_id': parentCommentId,
      'upvotes': 0,
      'downvotes': 0,
      'netvotes': 0,
      'created_on': Timestamp.now(),
      'updated_on': null
    });
  }

  Future<void> castVote({
    required String userId,
    required String itemId,
    required String voteType,
    required String itemType,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String docId = '$itemType-$itemId-$userId';
    DocumentReference voteRef = firestore.collection('vote').doc(docId);

    DocumentSnapshot existingVote = await voteRef.get();

    if (existingVote.exists) {
      // Vote exists, check if vote type is different
      if (existingVote['vote_type'] != voteType) {
        await voteRef.update({'vote_type': voteType});
        await updateVoteCountsOnItemChange(
            itemId, itemType, existingVote['vote_type'], voteType);
      }
      // If the vote type is the same, do nothing
    } else {
      // No existing vote, create new vote record
      await voteRef.set({
        'user_id': userId,
        'item_id': itemId,
        'vote_type': voteType,
        'item_type': itemType,
      });
      // Update the item's vote counts for the new vote
      await updateVoteCountsOnNewItem(itemId, itemType, voteType);
    }
  }

  Future<void> updateVoteCountsOnNewItem(
      String itemId, String itemType, String voteType) async {
    final DocumentReference itemRef =
        FirebaseFirestore.instance.collection(itemType).doc(itemId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(itemRef);
      if (!snapshot.exists) {
        throw Exception("$itemType $itemId does not exist!");
      }

      int upvotes = snapshot['upvotes'] ?? 0;
      int downvotes = snapshot['downvotes'] ?? 0;
      if (voteType == 'up') {
        upvotes++;
      } else if (voteType == 'down') {
        downvotes++;
      }
      int netvotes = upvotes - downvotes;

      transaction.update(itemRef, {
        'upvotes': upvotes,
        'downvotes': downvotes,
        'netvotes': netvotes,
      });
    });
  }

  Future<void> updateVoteCountsOnItemChange(String itemId, String itemType,
      String oldVoteType, String newVoteType) async {
    final DocumentReference itemRef =
        FirebaseFirestore.instance.collection(itemType).doc(itemId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(itemRef);
      if (!snapshot.exists) {
        throw Exception("$itemType $itemId does not exist!");
      }

      int upvotes = snapshot['upvotes'] ?? 0;
      int downvotes = snapshot['downvotes'] ?? 0;
      // Adjusting based on the change of vote
      if (oldVoteType == 'up' && newVoteType == 'down') {
        upvotes--;
        downvotes++;
      } else {
        downvotes--;
        upvotes++;
      }
      int netvotes = upvotes - downvotes;

      transaction.update(itemRef, {
        'upvotes': upvotes,
        'downvotes': downvotes,
        'netvotes': netvotes,
      });
    });
  }
}
