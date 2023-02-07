
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fit_hub_mobile_application/models/announcement.dart';
import 'package:fit_hub_mobile_application/models/basicNutrition.dart';
import 'package:fit_hub_mobile_application/models/coach.dart';
import 'package:fit_hub_mobile_application/models/diet.dart';
import 'package:fit_hub_mobile_application/models/home_banner.dart';
import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/models/workoutsExercises.dart';
import 'package:fit_hub_mobile_application/notifiers/announcement_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<TheUser> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  //sign in with email & password
  Future signInEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      // if(user.emailVerified){
      //
      // }else{
      //   print('please verify your account');
      // }
      return _userFromFirebaseUser(user);
    }catch(e){
      print((e).toString());
      return null;
    }
  }

  //register with email & password
  Future registerEmailPassword(
      String firstname,
      String lastname,
      String gender,
      String email,
      String role,
      String password,
      String goal,
      String heartCondition,
      String chestPain,
      String highBloodPressure,
      String highCholesterol,
      String medicalCondition,
      String healthComment,
      String age,
      String height,
      String weight,
      String bmi,
      String bmiMessage,
      String coachingFor,
      String selectedDate
      ) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      // user.sendEmailVerification();

      await UserDatabaseService(uid: user.uid).updateUserData(
          firstname,
          lastname,
          gender,
          email,
          'User',
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
  );

      return _userFromFirebaseUser(user);
    }catch(e){
      print((e).toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}


getCoach(CoachNotifier coachNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('coachesDetails')
      .orderBy("createdAt", descending: false)
      .get();

  List<Coach> _coachList = [];

  snapshot.docs.forEach((document) {
    Coach coach = Coach.fromMap(document.data());
    _coachList.add(coach);
  });

  coachNotifier.coachList = _coachList;
}
uploadCoachAndImage(Coach coach, bool isUpdating, File localFile, Function coachUploaded) async{
  if(localFile != null){
    print('uploading image');

    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('Coaches/coachImages/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');
    _uploadCoach(coach, isUpdating, coachUploaded, imageUrl: url);
  }else {
    print('...skipping image upload');
    _uploadCoach(coach, isUpdating, coachUploaded);
  }
}
_uploadCoach(Coach coach,  bool isUpdating, Function coachUploaded, {String imageUrl}) async{
  CollectionReference coachRef = FirebaseFirestore.instance.collection('coachesDetails');

  if(imageUrl != null){
    coach.image = imageUrl;
  }
  if(isUpdating){
    coach.updatedAt = Timestamp.now();

    coachUploaded(coach);
    await coachRef.doc(coach.id).update(coach.toMap());
    print('coach with id: ${coach.id}');
  }else{
    coach.createdAt = Timestamp.now();

    DocumentReference documentRef = await coachRef.add(coach.toMap());

    coach.id = documentRef.id;
    print('uploaded coach successfully: ${coach.toString()}');

    await documentRef.set(coach.toMap(), SetOptions(merge: true));

    coachUploaded(coach);
  }
}
deleteCoach(Coach coach, Function coachDeleted) async{
  try {
    if (coach.image != null) {
      Reference storageRef = FirebaseStorage.instance.refFromURL(coach.image);
      print(storageRef.fullPath);

      await storageRef.delete();
      print('Image deleted!');


    }
    await FirebaseFirestore.instance.collection('coachesDetails').doc(coach.id).delete();
    coachDeleted(coach);
    print('Coach deleted!');
  }catch(e){
    print(e);
  }
}

//Basic Nutrition
getBasicNutrition(BasicNutritionNotifier basicNutritionNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('basicNutrition')
      .orderBy("createdAt", descending: true)
      .get();

  List<BasicNutrition> _basicNutritionList = [];

  snapshot.docs.forEach((document) {
    BasicNutrition basicNutrition = BasicNutrition.fromMap(document.data());
    _basicNutritionList.add(basicNutrition);
  });

  basicNutritionNotifier.basicNutritionList = _basicNutritionList;
}
uploadBasicNutritionThumbnailAndVideo(BasicNutrition basicNutrition, bool isUpdating, File localFile, File localVideoFile, Function basicNutritionUploaded) async{
  if(localFile != null && localVideoFile != null){
    print('uploading thumbnail and video');
    var fileExtension = path.extension(localFile.path);
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download url: $url');
    print('download vidUrl: $vidUrl');

    _uploadBasicNutrition(basicNutrition, isUpdating, basicNutritionUploaded, thumbnailUrl: url, videoUrl: vidUrl);
  }else if(localFile != null && localVideoFile == null){
    print('uploading thumbnail');
    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');

    _uploadBasicNutrition(basicNutrition, isUpdating, basicNutritionUploaded, thumbnailUrl: url);

  } else if(localFile == null && localVideoFile != null) {
    print('uploading video');
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download vidUrl: $vidUrl');

    _uploadBasicNutrition(basicNutrition, isUpdating, basicNutritionUploaded, videoUrl: vidUrl);

  } else {
    print('...skipping image upload');
    _uploadBasicNutrition(basicNutrition, isUpdating, basicNutritionUploaded);
  }
}
_uploadBasicNutrition(BasicNutrition basicNutrition, bool isUpdating, Function basicNutritionUploaded, {String thumbnailUrl, String videoUrl}) async{
  CollectionReference basicNutritionRef = FirebaseFirestore.instance.collection('basicNutrition');


  if(videoUrl != null){
    basicNutrition.videoUrl = videoUrl;
  }
  if(thumbnailUrl != null){
    basicNutrition.thumbnail = thumbnailUrl;
  }
  if(isUpdating){
    basicNutrition.updatedAt = Timestamp.now();

    basicNutritionUploaded(basicNutrition);
    await basicNutritionRef.doc(basicNutrition.id).update(basicNutrition.toMap());
    print('Basic Nutrition with id: ${basicNutrition.id}');
  }else{
    basicNutrition.createdAt = Timestamp.now();

    DocumentReference documentRef = await basicNutritionRef.add(basicNutrition.toMap());

    basicNutrition.id = documentRef.id;
    print('uploaded Basic Nutrition successfully: ${basicNutrition.toString()}');

    await documentRef.set(basicNutrition.toMap(), SetOptions(merge: true));

    basicNutritionUploaded(basicNutrition);
  }
}
deleteBasicNutrition(BasicNutrition basicNutrition, Function basicNutritionDeleted) async{
  try {
    if (basicNutrition.thumbnail != null && basicNutrition.videoUrl != null) {

      Reference storageVidRef = FirebaseStorage.instance.refFromURL(basicNutrition.videoUrl);
      print(storageVidRef.fullPath);
      await storageVidRef.delete();
      print('Video deleted!');

      Reference storageRef = FirebaseStorage.instance.refFromURL(basicNutrition.thumbnail);
      print(storageRef.fullPath);
      await storageRef.delete();
      print('Thumbnail deleted!');


    }
    await FirebaseFirestore.instance.collection('basicNutrition').doc(basicNutrition.id).delete();
    basicNutritionDeleted(basicNutrition);
    print('Basic Nutrition File deleted!');
  }catch(e){
    print(e);
  }
}

//Diet Details
getAllDietDetails(AllDietDetailsNotifier allDietDetailsNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('dietDetails')
      .get();

  List<DietDetails> _dietDetailsList = [];

  snapshot.docs.forEach((document) {
    DietDetails dietDetails = DietDetails.fromMap(document.data());
    _dietDetailsList.add(dietDetails);
  });

  allDietDetailsNotifier.dietDetailsList = _dietDetailsList;
}
uploadAllDietDetailsThumbnailAndVideo(DietDetails dietDetails, bool isUpdating, File localFile, File localVideoFile, Function dietDetailsUploaded) async{
  if(localFile != null && localVideoFile != null){
    print('uploading thumbnail and video');
    var fileExtension = path.extension(localFile.path);
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download url: $url');
    print('download vidUrl: $vidUrl');

    _uploadAllDietDetails(dietDetails, isUpdating, dietDetailsUploaded, thumbnailUrl: url, videoUrl: vidUrl);
  }else if(localFile != null && localVideoFile == null){
    print('uploading thumbnail');
    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');

    _uploadAllDietDetails(dietDetails, isUpdating, dietDetailsUploaded, thumbnailUrl: url);

  } else if(localFile == null && localVideoFile != null) {
    print('uploading video');
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download vidUrl: $vidUrl');

    _uploadAllDietDetails(dietDetails, isUpdating, dietDetailsUploaded, videoUrl: vidUrl);

  } else {
    print('...skipping image upload');
    _uploadAllDietDetails(dietDetails, isUpdating, dietDetailsUploaded);
  }
}
_uploadAllDietDetails(DietDetails dietDetails, bool isUpdating, Function dietDetailsUploaded, {String thumbnailUrl, String videoUrl}) async{
  CollectionReference dietDetailsRef = FirebaseFirestore.instance.collection('dietDetails');


  if(videoUrl != null){
    dietDetails.videoUrl = videoUrl;
  }
  if(thumbnailUrl != null){
    dietDetails.thumbnailUrl = thumbnailUrl;
  }
  if(isUpdating){
    dietDetails.updatedAt = Timestamp.now();

    dietDetailsUploaded(dietDetails);
    await dietDetailsRef.doc(dietDetails.id).update(dietDetails.toMap());
    print('Diet Details with id: ${dietDetails.id}');
  }else{
    dietDetails.createdAt = Timestamp.now();

    DocumentReference documentRef = await dietDetailsRef.add(dietDetails.toMap());

    dietDetails.id = documentRef.id;
    print('uploaded Diet Details successfully: ${dietDetails.toString()}');

    await documentRef.set(dietDetails.toMap(), SetOptions(merge: true));

    dietDetailsUploaded(dietDetails);
  }
}
deleteAllDietDetails(DietDetails dietDetails, Function dietDetailsDeleted) async{
  try {
    if (dietDetails.thumbnailUrl != null && dietDetails.videoUrl != null) {

      Reference storageVidRef = FirebaseStorage.instance.refFromURL(dietDetails.videoUrl);
      print(storageVidRef.fullPath);
      await storageVidRef.delete();
      print('Video deleted!');

      Reference storageRef = FirebaseStorage.instance.refFromURL(dietDetails.thumbnailUrl);
      print(storageRef.fullPath);
      await storageRef.delete();
      print('Thumbnail deleted!');
    }

    await FirebaseFirestore.instance.collection('dietDetails').doc(dietDetails.id).delete();
    dietDetailsDeleted(dietDetails);
    print('Diet Details File deleted!');
  }catch(e){
    print(e);
  }
}

getMeatsProteins(DietDetailsNotifier dietDetailsNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('dietDetails').where('category', isEqualTo: 'Meats & Proteins')
      .orderBy("createdAt", descending: true)
      .get();

  List<DietDetails> _dietDetailsList = [];

  snapshot.docs.forEach((document) {
    DietDetails dietDetails = DietDetails.fromMap(document.data());
    _dietDetailsList.add(dietDetails);
  });

  dietDetailsNotifier.dietDetailsList = _dietDetailsList;
}
getGrainsCereals(DietDetailsNotifier dietDetailsNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('dietDetails').where('category', isEqualTo: 'Grains & Cereals')
      .orderBy("createdAt", descending: true)
      .get();

  List<DietDetails> _dietDetailsList = [];

  snapshot.docs.forEach((document) {
    DietDetails dietDetails = DietDetails.fromMap(document.data());
    _dietDetailsList.add(dietDetails);
  });

  dietDetailsNotifier.dietDetailsList = _dietDetailsList;
}
getFruitsVeggies(DietDetailsNotifier dietDetailsNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('dietDetails').where('category', isEqualTo: 'Fruits & Veggies')
      .orderBy("createdAt", descending: true)
      .get();

  List<DietDetails> _dietDetailsList = [];

  snapshot.docs.forEach((document) {
    DietDetails dietDetails = DietDetails.fromMap(document.data());
    _dietDetailsList.add(dietDetails);
  });

  dietDetailsNotifier.dietDetailsList = _dietDetailsList;
}
uploadMeatsProteinsThumbnailAndVideo(DietDetails dietDetails, bool isUpdating, File localFile, File localVideoFile, Function dietDetailsUploaded) async{
  if(localFile != null && localVideoFile != null){
    print('uploading thumbnail and video');
    var fileExtension = path.extension(localFile.path);
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download url: $url');
    print('download vidUrl: $vidUrl');

    _uploadDietDetails(dietDetails, isUpdating, dietDetailsUploaded, thumbnailUrl: url, videoUrl: vidUrl);
  }else if(localFile != null && localVideoFile == null){
    print('uploading thumbnail');
    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Thumbnails/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');

    _uploadDietDetails(dietDetails, isUpdating, dietDetailsUploaded, thumbnailUrl: url);

  } else if(localFile == null && localVideoFile != null) {
    print('uploading video');
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('DietFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download vidUrl: $vidUrl');

    _uploadDietDetails(dietDetails, isUpdating, dietDetailsUploaded, videoUrl: vidUrl);

  } else {
    print('...skipping image upload');
    _uploadDietDetails(dietDetails, isUpdating, dietDetailsUploaded);
  }
}
_uploadDietDetails(DietDetails dietDetails, bool isUpdating, Function dietDetailsUploaded, {String thumbnailUrl, String videoUrl}) async{
  CollectionReference dietDetailsRef = FirebaseFirestore.instance.collection('dietDetails');


  if(videoUrl != null){
    dietDetails.videoUrl = videoUrl;
  }
  if(thumbnailUrl != null){
    dietDetails.thumbnailUrl = thumbnailUrl;
  }
  if(isUpdating){
    dietDetails.updatedAt = Timestamp.now();

    dietDetailsUploaded(dietDetails);
    await dietDetailsRef.doc(dietDetails.id).update(dietDetails.toMap());
    print('Diet Details with id: ${dietDetails.id}');
  }else{
    dietDetails.createdAt = Timestamp.now();

    DocumentReference documentRef = await dietDetailsRef.add(dietDetails.toMap());

    dietDetails.id = documentRef.id;
    print('uploaded Diet Details successfully: ${dietDetails.toString()}');

    await documentRef.set(dietDetails.toMap(), SetOptions(merge: true));

    dietDetailsUploaded(dietDetails);
  }
}
deleteDietDetails(DietDetails dietDetails, Function dietDetailsDeleted) async{
  try {
    if (dietDetails.thumbnailUrl != null && dietDetails.videoUrl != null) {

      Reference storageVidRef = FirebaseStorage.instance.refFromURL(dietDetails.videoUrl);
      print(storageVidRef.fullPath);
      await storageVidRef.delete();
      print('Video deleted!');

      Reference storageRef = FirebaseStorage.instance.refFromURL(dietDetails.thumbnailUrl);
      print(storageRef.fullPath);
      await storageRef.delete();
      print('Thumbnail deleted!');
    }

    await FirebaseFirestore.instance.collection('dietDetails').doc(dietDetails.id).delete();
    dietDetailsDeleted(dietDetails);
    print('Diet Details File deleted!');
  }catch(e){
    print(e);
  }
}


getHomeBanner(HomeBannerNotifier homeBannerNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('homeBanner')
      .get();

  List<HomeBanner> _homeBannerList = [];

  snapshot.docs.forEach((document) {
    HomeBanner homeBanner = HomeBanner.fromMap(document.data());
    _homeBannerList.add(homeBanner);
  });

  homeBannerNotifier.homeBannerList = _homeBannerList;
}
uploadHomeBannerThumbnail(HomeBanner homeBanner, bool isUpdating, File localFile, Function homeBannerUploaded) async{
  if(localFile != null){
    print('uploading image');

    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('RandomFiles/thumbnails/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');
    _uploadHomeBanner(homeBanner, isUpdating, homeBannerUploaded, thumbnailUrl: url);
  }else {
    print('...skipping image upload');
    _uploadHomeBanner(homeBanner, isUpdating, homeBannerUploaded);
  }
}
_uploadHomeBanner(HomeBanner homeBanner, bool isUpdating, Function homeBannerUploaded, {String thumbnailUrl}) async{
  CollectionReference homeBannerRef = FirebaseFirestore.instance.collection('homeBanner');


  if(thumbnailUrl != null){
    homeBanner.thumbnailUrl = thumbnailUrl;
  }
  if(isUpdating){
    homeBanner.updatedAt = Timestamp.now();

    homeBannerUploaded(homeBanner);
    await homeBannerRef.doc(homeBanner.id).update(homeBanner.toMap());
    print('Home Banner Details with id: ${homeBanner.id}');
  }else{
    homeBanner.createdAt = Timestamp.now();

    DocumentReference documentRef = await homeBannerRef.add(homeBanner.toMap());

    homeBanner.id = documentRef.id;
    print('uploaded Home Banner successfully: ${homeBanner.toString()}');

    await documentRef.set(homeBanner.toMap(), SetOptions(merge: true));

    homeBannerUploaded(homeBanner);
  }
}

getAnnouncement(AnnouncementNotifier announcementNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('announcement')
      .orderBy("createdAt", descending: true)
      .get();

  List<Announcement> _announcementList = [];

  snapshot.docs.forEach((document) {
    Announcement announcement = Announcement.fromMap(document.data());
    _announcementList.add(announcement);
  });

  announcementNotifier.announcementList = _announcementList;
}
uploadAnnouncementAndImage(Announcement announcement, bool isUpdating, File localFile, Function announcementUploaded) async{
  if(localFile != null){
    print('uploading image');

    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('RandomFiles/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');
    _uploadAnnouncement(announcement, isUpdating, announcementUploaded, imageUrl: url);
  }else {
    print('...skipping image upload');
    _uploadAnnouncement(announcement, isUpdating, announcementUploaded);
  }
}
_uploadAnnouncement(Announcement announcement,  bool isUpdating, Function announcementUploaded, {String imageUrl}) async{
  CollectionReference Ref = FirebaseFirestore.instance.collection('announcement');

  if(imageUrl != null){
    announcement.thumbnailUrl = imageUrl;
  }
  if(isUpdating){
    announcement.updatedAt = Timestamp.now();

    announcementUploaded(announcement);
    await Ref.doc(announcement.id).update(announcement.toMap());
    print('announcement with id: ${announcement.id}');
  }else{
    announcement.createdAt = Timestamp.now();

    DocumentReference documentRef = await Ref.add(announcement.toMap());

    announcement.id = documentRef.id;
    print('Announement uploaded successfully: ${announcement.toString()}');

    await documentRef.set(announcement.toMap(), SetOptions(merge: true));

    announcementUploaded(announcement);
  }
}
deleteAnnouncement(Announcement announcement, Function announcementDeleted) async{
  try {
    if (announcement.thumbnailUrl != null) {
      Reference storageRef = FirebaseStorage.instance.refFromURL(announcement.thumbnailUrl);
      print(storageRef.fullPath);

      await storageRef.delete();
      print('Image deleted!');
    }
    await FirebaseFirestore.instance.collection('announcement').doc(announcement.id).delete();
    announcementDeleted(announcement);
    print('Announcement deleted!');
  }catch(e){
    print(e);
  }
}

getAllWorkoutsExercises(AllWorkoutsExercisesNotifier allWorkoutsExercisesNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('workoutsExercises')
      .get();

  List<WorkoutsExercises> _workoutsExercisesList = [];

  snapshot.docs.forEach((document) {
    WorkoutsExercises workoutsExercises = WorkoutsExercises.fromMap(document.data());
    _workoutsExercisesList.add(workoutsExercises);
  });

  allWorkoutsExercisesNotifier.workoutsExercisesList = _workoutsExercisesList;
}
uploadAllWorkoutsExercisesThumbnailAndVideo(WorkoutsExercises workoutsExercises, bool isUpdating, File localFile, File localVideoFile, Function workoutsExercisesUploaded) async{
  if(localFile != null && localVideoFile != null){
    print('uploading thumbnail and video');
    var fileExtension = path.extension(localFile.path);
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download url: $url');
    print('download vidUrl: $vidUrl');

    _uploadAllWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, thumbnailUrl: url, videoUrl: vidUrl);
  }else if(localFile != null && localVideoFile == null){
    print('uploading thumbnail');
    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');

    _uploadAllWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, thumbnailUrl: url);

  } else if(localFile == null && localVideoFile != null) {
    print('uploading video');
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download vidUrl: $vidUrl');

    _uploadAllWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, videoUrl: vidUrl);

  } else {
    print('...skipping image upload');
    _uploadAllWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded);
  }
}
_uploadAllWorkoutsExercises(WorkoutsExercises workoutsExercises, bool isUpdating, Function workoutsExercisesUploaded, {String thumbnailUrl, String videoUrl}) async{
  CollectionReference workoutsExercisesRef = FirebaseFirestore.instance.collection('workoutsExercises');


  if(videoUrl != null){
    workoutsExercises.videoUrl = videoUrl;
  }
  if(thumbnailUrl != null){
    workoutsExercises.thumbnailUrl = thumbnailUrl;
  }
  if(isUpdating){
    workoutsExercises.updatedAt = Timestamp.now();

    workoutsExercisesUploaded(workoutsExercises);
    await workoutsExercisesRef.doc(workoutsExercises.id).update(workoutsExercises.toMap());
    print('WorkoutsExercises with id: ${workoutsExercises.id}');
  }else{
    workoutsExercises.createdAt = Timestamp.now();

    DocumentReference documentRef = await workoutsExercisesRef.add(workoutsExercises.toMap());

    workoutsExercises.id = documentRef.id;
    print('uploaded Workout Exercises successfully: ${workoutsExercises.toString()}');

    await documentRef.set(workoutsExercises.toMap(), SetOptions(merge: true));

    workoutsExercisesUploaded(workoutsExercises);
  }
}
deleteAllWorkoutsExercises(WorkoutsExercises workoutsExercises, Function workoutsExercisesDeleted) async{
  try {
    if (workoutsExercises.thumbnailUrl != null && workoutsExercises.videoUrl != null) {

      Reference storageVidRef = FirebaseStorage.instance.refFromURL(workoutsExercises.videoUrl);
      print(storageVidRef.fullPath);
      await storageVidRef.delete();
      print('Video deleted!');

      Reference storageRef = FirebaseStorage.instance.refFromURL(workoutsExercises.thumbnailUrl);
      print(storageRef.fullPath);
      await storageRef.delete();
      print('Thumbnail deleted!');
    }

    await FirebaseFirestore.instance.collection('workoutsExercises').doc(workoutsExercises.id).delete();
    workoutsExercisesDeleted(workoutsExercises);
    print('Workout Exercises File deleted!');
  }catch(e){
    print(e);
  }
}

getCircuit(WorkoutsExercisesNotifier workoutsExercisesNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('workoutsExercises').where('workoutsExercisesCategory', isEqualTo: 'Circuit Workout')
      .orderBy("createdAt", descending: true)
      .get();

  List<WorkoutsExercises> _workoutsExercisesList = [];

  snapshot.docs.forEach((document) {
    WorkoutsExercises workoutsExercises = WorkoutsExercises.fromMap(document.data());
    _workoutsExercisesList.add(workoutsExercises);
  });

  workoutsExercisesNotifier.workoutsExercisesList = _workoutsExercisesList;
}
getBoxingMuayThai(WorkoutsExercisesNotifier workoutsExercisesNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('workoutsExercises').where('workoutsExercisesCategory', isEqualTo: 'Boxing & Muay Thai')
      .orderBy("createdAt", descending: true)
      .get();

  List<WorkoutsExercises> _workoutsExercisesList = [];

  snapshot.docs.forEach((document) {
    WorkoutsExercises workoutsExercises = WorkoutsExercises.fromMap(document.data());
    _workoutsExercisesList.add(workoutsExercises);
  });

  workoutsExercisesNotifier.workoutsExercisesList = _workoutsExercisesList;
}
getCrossFit(WorkoutsExercisesNotifier workoutsExercisesNotifier) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('workoutsExercises').where('workoutsExercisesCategory', isEqualTo: 'CrossFit Workout')
      .orderBy("createdAt", descending: true)
      .get();

  List<WorkoutsExercises> _workoutsExercisesList = [];

  snapshot.docs.forEach((document) {
    WorkoutsExercises workoutsExercises = WorkoutsExercises.fromMap(document.data());
    _workoutsExercisesList.add(workoutsExercises);
  });

  workoutsExercisesNotifier.workoutsExercisesList = _workoutsExercisesList;
}
uploadWorkoutsExercisesThumbnailAndVideo(WorkoutsExercises workoutsExercises, bool isUpdating, File localFile, File localVideoFile, Function workoutsExercisesUploaded) async{
  if(localFile != null && localVideoFile != null){
    print('uploading thumbnail and video');
    var fileExtension = path.extension(localFile.path);
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download url: $url');
    print('download vidUrl: $vidUrl');

    _uploadWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, thumbnailUrl: url, videoUrl: vidUrl);
  }else if(localFile != null && localVideoFile == null){
    print('uploading thumbnail');
    var fileExtension = path.extension(localFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileExtension');
    await firebaseStorageRef.putFile(localFile);

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');

    _uploadWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, thumbnailUrl: url);

  } else if(localFile == null && localVideoFile != null) {
    print('uploading video');
    var fileVideoExtension = path.extension(localVideoFile.path);
    var uuid = Uuid().v4();

    final Reference firebaseVidStorageRef =
    FirebaseStorage.instance.ref().child('WorkoutFiles/Videos/$uuid$fileVideoExtension');
    await firebaseVidStorageRef.putFile(localVideoFile);

    String vidUrl = await firebaseVidStorageRef.getDownloadURL();
    print('download vidUrl: $vidUrl');

    _uploadWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded, videoUrl: vidUrl);

  } else {
    print('...skipping image upload');
    _uploadWorkoutsExercises(workoutsExercises, isUpdating, workoutsExercisesUploaded);
  }
}
_uploadWorkoutsExercises(WorkoutsExercises workoutsExercises, bool isUpdating, Function workoutsExercisesUploaded, {String thumbnailUrl, String videoUrl}) async{
  CollectionReference workoutsExercisesRef = FirebaseFirestore.instance.collection('workoutsExercises');


  if(videoUrl != null){
    workoutsExercises.videoUrl = videoUrl;
  }
  if(thumbnailUrl != null){
    workoutsExercises.thumbnailUrl = thumbnailUrl;
  }
  if(isUpdating){
    workoutsExercises.updatedAt = Timestamp.now();

    workoutsExercisesUploaded(workoutsExercises);
    await workoutsExercisesRef.doc(workoutsExercises.id).update(workoutsExercises.toMap());
    print('WorkoutsExercises with id: ${workoutsExercises.id}');
  }else{
    workoutsExercises.createdAt = Timestamp.now();

    DocumentReference documentRef = await workoutsExercisesRef.add(workoutsExercises.toMap());

    workoutsExercises.id = documentRef.id;
    print('uploaded Workout Exercises successfully: ${workoutsExercises.toString()}');

    await documentRef.set(workoutsExercises.toMap(), SetOptions(merge: true));

    workoutsExercisesUploaded(workoutsExercises);
  }
}
deleteWorkoutsExercises(WorkoutsExercises workoutsExercises, Function workoutsExercisesDeleted) async{
  try {
    if (workoutsExercises.thumbnailUrl != null && workoutsExercises.videoUrl != null) {

      Reference storageVidRef = FirebaseStorage.instance.refFromURL(workoutsExercises.videoUrl);
      print(storageVidRef.fullPath);
      await storageVidRef.delete();
      print('Video deleted!');

      Reference storageRef = FirebaseStorage.instance.refFromURL(workoutsExercises.thumbnailUrl);
      print(storageRef.fullPath);
      await storageRef.delete();
      print('Thumbnail deleted!');
    }

    await FirebaseFirestore.instance.collection('workoutsExercises').doc(workoutsExercises.id).delete();
    workoutsExercisesDeleted(workoutsExercises);
    print('Workout Exercises File deleted!');
  }catch(e){
    print(e);
  }
}