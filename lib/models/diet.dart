import 'package:cloud_firestore/cloud_firestore.dart';

class DietDetails{
  String id;
  String title;
  String kcal;
  String levelToDo;
  List ingredients = [];
  List nutritionList = [];
  List stepByStep = [];
  String category;
  String description;
  String videoUrl;
  String thumbnailUrl;
  Timestamp createdAt;
  Timestamp updatedAt;

  DietDetails();

  DietDetails.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    kcal = data['kcal'];
    levelToDo = data['levelToDo'];
    ingredients = data['ingredients'];
    nutritionList = data['nutritionList'];
    category = data['category'];
    stepByStep = data['stepByStep'];
    description = data['description'];
    videoUrl = data['videoUrl'];
    thumbnailUrl = data['thumbnailUrl'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title': title,
      'kcal' : kcal,
      'levelToDo': levelToDo,
      'ingredients': ingredients,
      'nutritionList': nutritionList,
      'category': category,
      'stepByStep': stepByStep,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}