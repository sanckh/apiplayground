import 'package:apiplayground/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserProfile(User user) async {
    return _usersRef.doc(user.id).update(user.toJson());
  }

  Future<User?> getUserProfile(String userId) async {
    DocumentSnapshot doc = await _usersRef.doc(userId).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }

  Future updateUserAvatar(String userId, String avatar) async {
    DocumentReference userRef = _usersRef.doc(userId);
    await userRef.update({
      'avatar': avatar,
    });
  }

  Future<String> fetchUsernameByUserId(String userId) async {
  final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!userDoc.exists) {
    print("User document does not exist for ID: $userId");
    throw Exception("User not found for ID: $userId");
  } else {
    final data = userDoc.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('username')) {
      final String username = data['username'];
      print("Fetched username: $username for userID: $userId");
      return username;
    } else {
      print("Username field is missing for user ID: $userId");
      throw Exception("Username field is missing for user ID: $userId");
    }
  }
}


    String? getUserId() {
    final auth.User? user = auth.FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}
