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
}
