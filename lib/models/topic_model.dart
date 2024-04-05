import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String name;

  Topic({required this.id, required this.name});

  factory Topic.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Topic(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}
