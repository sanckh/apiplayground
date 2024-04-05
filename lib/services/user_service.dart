import 'package:apiplayground/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
