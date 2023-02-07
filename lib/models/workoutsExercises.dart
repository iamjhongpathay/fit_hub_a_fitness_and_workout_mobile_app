import 'package:cloud_firestore/cloud_firestore.dart';
class WorkoutsExercises {
  String id;
  String title;
  String coachName;
  String workoutsExercisesCategory;
  List details = [];
  String competencyLevel;
  String description;
  String thumbnailUrl;
  String videoUrl;
  Timestamp createdAt;
  Timestamp updatedAt;

  WorkoutsExercises();

  WorkoutsExercises.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    coachName = data['coachName'];
    workoutsExercisesCategory = data['workoutsExercisesCategory'];
    details = data['details'];
    competencyLevel = data['competencyLevel'];
    description = data['description'];
    thumbnailUrl = data['thumbnailUrl'];
    videoUrl = data['videoUrl'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'coachName': coachName,
      'workoutsExercisesCategory' : workoutsExercisesCategory,
      'details': details,
      'competencyLevel': competencyLevel,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}