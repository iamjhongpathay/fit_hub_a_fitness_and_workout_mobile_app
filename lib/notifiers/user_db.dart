
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/models/user.dart';

class UserDatabaseService {

  final String uid;
  UserDatabaseService({ this.uid });

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('userDetails');

  Future updateUserData(
      String firstname,
      lastname,
      gender,
      email,
      role,
      goal,
      heartCondition,
      chestPain,
      highBloodPressure,
      highCholesterol,
      medicalCondition,
      healthComment,
      age,
      height,
      weight,
      bmi,
      bmiMessage,
      coachingFor,
      selectedDate

      ) async {
    return await userCollection.doc(uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'email': email,
      'role': role,
      'goal': goal,
      'heartCondition': heartCondition,
      'chestPain': chestPain,
      'highBloodPressure': highBloodPressure,
      'highCholesterol': highCholesterol,
      'medicalCondition': medicalCondition,
      'healthComment': healthComment,
      'age': age,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'bmiMessage': bmiMessage,
      'coachingFor': coachingFor,
      'selectedDate': selectedDate,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        firstname: snapshot.get('firstname'),
        lastname: snapshot.get('lastname'),
        gender: snapshot.get('gender'),
        email: snapshot.get('email'),
        role: snapshot.get('role'),
        goal: snapshot.get('goal'),
        heartCondition: snapshot.get('heartCondition'),
        chestPain: snapshot.get('chestPain'),
        highBloodPressure: snapshot.get('highBloodPressure'),
        highCholesterol: snapshot.get('highCholesterol'),
        medicalCondition: snapshot.get('medicalCondition'),
        healthComment: snapshot.get('healthComment'),
        age: snapshot.get('age'),
        height: snapshot.get('height'),
        weight: snapshot.get('weight'),
        bmi: snapshot.get('bmi'),
        bmiMessage: snapshot.get('bmiMessage'),
        coachingFor: snapshot.get('coachingFor'),
      selectedDate: snapshot.get('selectedDate')



    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}