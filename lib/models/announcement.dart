import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String id;
  String title;
  String subtitle;
  String description;
  String thumbnailUrl;
  Timestamp createdAt;
  Timestamp updatedAt;

  Announcement();

  Announcement.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    subtitle = data['subtitle'];
    description = data['description'];
    thumbnailUrl = data['thumbnailUrl'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}