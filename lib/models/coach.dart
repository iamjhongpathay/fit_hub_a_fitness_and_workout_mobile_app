import 'package:cloud_firestore/cloud_firestore.dart';

class Coach{
  String id;
  String coachName;
  List categoryDetails = [];
  String expertise;
  String aboutCoach;
  String image;
  Timestamp createdAt;
  Timestamp updatedAt;

  Coach();

  Coach.fromMap(Map<String, dynamic> data){
    id = data['id'];
    coachName = data['coachName'];
    categoryDetails = data['categoryDetails'];
    expertise = data['expertise'];
    aboutCoach = data['aboutCoach'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'coachName': coachName,
      'categoryDetails': categoryDetails,
      'expertise': expertise,
      'aboutCoach': aboutCoach,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}