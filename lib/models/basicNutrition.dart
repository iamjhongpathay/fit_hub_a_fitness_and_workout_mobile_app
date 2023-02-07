import 'package:cloud_firestore/cloud_firestore.dart';

class BasicNutrition {
  String id;
  String title;
  String coachName;
  List details = [];
  String description;
  String videoUrl;
  String thumbnail;
  Timestamp createdAt;
  Timestamp updatedAt;

  BasicNutrition();

  BasicNutrition.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    coachName = data['coachName'];
    details = data['details'];
    description = data['description'];
    videoUrl = data['videoUrl'];
    thumbnail = data['thumbnail'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title': title,
      'coachName': coachName,
      'details': details,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}