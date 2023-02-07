// import 'package:another_flushbar/flushbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fit_hub_mobile_application/api/push_notification_api.dart';
// import 'package:fit_hub_mobile_application/models/message.dart';
// import 'package:fit_hub_mobile_application/shared/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
//
// class AdminSendNotificationForm extends StatefulWidget {
//   @override
//   _AdminSendNotificationFormState createState() => _AdminSendNotificationFormState();
// }
//
// class _AdminSendNotificationFormState extends State<AdminSendNotificationForm> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final TextEditingController titleController =
//   TextEditingController();
//   final TextEditingController bodyController =
//   TextEditingController();
//   final List<Message> messages = [];
//   final firestoreInstance = FirebaseFirestore.instance;
//   String formatTimeStamp(Timestamp timestamp){
//     var format = new DateFormat('(EEE)'' MMMM d, y'' - ''h:mm a' );
//     return format.format(timestamp.toDate());
//   }
//
//   static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//     if (message.containsKey('data')) {
//       // Handle data message
//       final dynamic data = message['data'];
//     }
//
//     if (message.containsKey('notification')) {
//       // Handle notification message
//       final dynamic notification = message['notification'];
//     }
//
//     // Or do other work.
//   }
//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
//     _firebaseMessaging.getToken();
//
//     _firebaseMessaging.subscribeToTopic('all');
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print('onMessage: $message');
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         print('onLaunch: $message');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print('onResume: $message');
//
//       },
//     );
//     // _firebaseMessaging.requestNotificationPermissions(
//     //     const IosNotificationSettings(sound: true, badge: true, alert: true));
//   }
//
//   Future sendNotification() async {
//     final response = await Messaging.sendToAll(
//       title: titleController.text,
//       body: bodyController.text,
//     );
//
//     if (response.statusCode != 200) {
//       Scaffold.of(context).showSnackBar(SnackBar(
//         content:
//         Text('[${response.statusCode}] Error message: ${response.body}'),
//       ));
//     }
//   }
//
//   void sendTokenToServer(String fcmToken) {
//     print('Token: $fcmToken');
//   }
//
//   void flushBar(BuildContext context){
//     Flushbar(
//       title: 'Notification',
//       message: 'Successfully Sent.',
//       icon: Icon(Icons.check, color: Colors.green, size: 30,),
//       duration: Duration(seconds: 2),
//       flushbarStyle: FlushbarStyle.FLOATING,
//     )..show(context);
//   }
//
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Text('Send Notification',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w900,
//               fontStyle: FontStyle.italic,
//               fontSize: 25.0,
//             ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(
//                 Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//                 children: [
//                   SizedBox(height: 10),
//                   TextFormField(
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     controller: titleController,
//                     decoration: textInputDecoration.copyWith(labelText: 'TITLE'),
//                     maxLength: 150,
//                     validator: (String value){
//                       if(value.isEmpty){
//                         return '';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     controller: bodyController,
//                     decoration: textInputDecoration.copyWith(labelText: 'BODY'),
//                     maxLines: null,
//                     validator: (String value){
//                       if(value.isEmpty){
//                         return '';
//                       }
//                       return null;
//                     },
//                   ),SizedBox(height: 15),
//                   ButtonTheme(
//                     minWidth: 500.0,
//                     height: 50.0,
//                     child: RaisedButton(
//                       elevation: 0.0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular((5)),
//                       ),
//                       color: Colors.black,
//                       splashColor: Colors.grey,
//                       child: Text(
//                         'SEND',
//                         style: TextStyle(color: Colors.white,
//                           fontSize: 20.0,
//                           letterSpacing: 1.0,
//                         ),
//                       ),
//                       onPressed: () async {
//                         if(!_formKey.currentState.validate()){
//                           return;
//                         }
//                         sendNotification();
//                         flushBar(context);
//                         firestoreInstance.collection('pushNotificationMessages').add(
//                           {
//                             'title' : titleController.text,
//                             'body' : bodyController.text,
//                             'createdAt' : Timestamp.now(),
//                           }).then((value) => value.id);
//
//                         titleController.clear();
//                         bodyController.clear();
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 5,),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('pushNotificationMessages')
//                         .orderBy('createdAt', descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot){
//                       if(!snapshot.hasData){
//                         return Text('Loading . . .');
//                       }else{
//                         return Column(
//                           children: <Widget>[
//                             ListView.separated(
//                               physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                                 separatorBuilder: (BuildContext context, int index) {
//                                   return SizedBox(height: 5,);
//                                 },
//                               itemCount: snapshot.data.docs.length,
//                                 itemBuilder: ( context, index){
//                                 // DateTime createdAt = snapshot.data.docs[index]["createdAt"]?.toDate();
//                                 return Card(
//                                   color: Colors.grey[200],
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       children: [
//                                         ListTile(
//                                           title: Text('TITLE: ${snapshot.data.docs[index]['title']}'),
//                                           subtitle: Text('BODY: ${snapshot.data.docs[index]['body']}'),
//                                           isThreeLine: true,
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 15.0),
//                                           child: Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: Text(formatTimeStamp(snapshot.data.docs[index]['createdAt']),
//                                                 style: TextStyle(color: Colors.grey),
//                                               ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                                 }
//                             ),
//                           ],
//                         );
//                       }
//                     }
//                   )
//                 ],
//                   // ..addAll(messages.map(buildMessage).toList(),)
//             ),
//           ),
//         ),
//       );
//
//
// }
