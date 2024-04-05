import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String username;
  final String email;
  String avatar;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.avatar = 'assets/asset3.png',
      });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'avatar': avatar,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      username: data['username'],
      email: data['email'],
      avatar: data['avatar'] ??
          'assets/asset3.png', // Set default avatar if not provided
    );
  }
}
