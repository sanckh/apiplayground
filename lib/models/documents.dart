import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final String id;
  final String title;
  final String author;
  final String description;
  final String categoryName;
  final String categoryId;
  final String content;
  final List<String> tags;
  final Timestamp? updateDate;
  final Timestamp createDate;
  final String? imageUrl;

  Document({required this.id, required this.title, required this.author, required this.description, required this.categoryId, required this.categoryName, required this.content, required this.tags, this.updateDate, required this.createDate, this.imageUrl});

  factory Document.fromMap(Map<String, dynamic> data, String id) {
    return Document(
      id: id,
      title: data['title'],
      author: data['author'],
      description: data['description'],
      createDate: data['create_date'],
      updateDate: data['update_date'],
      categoryId: data['category_id'],
      categoryName: data['category_name'],
      content: data['content'],
      tags: List<String>.from(data['tags']),
      imageUrl: data['image_url'],
    );
  }

  factory Document.fromAlgolia(AlgoliaObjectSnapshot algoliaSnapshot) {
    Map<String, dynamic> data = algoliaSnapshot.data;
    return Document(
      id: algoliaSnapshot.objectID,
      title: data['title'],
      author: data['author'],
      description: data['description'],
      categoryId: data['category_id'],
      categoryName: data['category_name'],
      content: data['content'],
      tags: List<String>.from(data['tags']),
      updateDate: data['update_date'] != null ? Timestamp.fromMillisecondsSinceEpoch(data['update_date']) : null,
      createDate: Timestamp.fromMillisecondsSinceEpoch(data['create_date']),
      imageUrl: data['imageUrl'],
    );
  }
}
