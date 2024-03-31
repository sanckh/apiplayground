import 'package:cloud_firestore/cloud_firestore.dart';

class Tutorial {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final String content;
  final List<String> tags;
  final Timestamp? updateDate;
  final Timestamp createDate;
  final String? imageUrl;

  Tutorial({required this.id, required this.title, required this.author, required this.description, required this.category, required this.content, required this.tags, this.updateDate, required this.createDate, this.imageUrl});

  factory Tutorial.fromMap(Map<String, dynamic> data, String id) {
    return Tutorial(
      id: id,
      title: data['title'],
      author: data['author'],
      description: data['description'],
      createDate: data['create_date'],
      updateDate: data['update_date'],
      category: data['category'],
      content: data['content'],
      tags: List<String>.from(data['tags']),
      imageUrl: data['image_url'],
    );
  }
}
