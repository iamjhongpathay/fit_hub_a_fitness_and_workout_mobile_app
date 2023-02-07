import 'package:cloud_firestore/cloud_firestore.dart';
class HomeBanner{
  String id;
  String title;
  String description;
  String thumbnailUrl;
  Timestamp createdAt;
  Timestamp updatedAt;

  HomeBanner();

  HomeBanner.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    description = data['description'];
    thumbnailUrl = data['thumbnailUrl'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}