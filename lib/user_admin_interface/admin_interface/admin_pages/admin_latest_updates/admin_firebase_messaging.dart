import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fit_hub_mobile_application/api/push_notification_api.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:fit_hub_mobile_application/models/push_notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class AdminFirebaseMessaging extends StatefulWidget {
  const AdminFirebaseMessaging({Key key}) : super(key: key);

  @override
  _AdminFirebaseMessagingState createState() => _AdminFirebaseMessagingState();
}

class _AdminFirebaseMessagingState extends State<AdminFirebaseMessaging> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController =
  TextEditingController();
  final TextEditingController bodyController =
  TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  String formatTimeStamp(Timestamp timestamp){
    var format = new DateFormat('(EEE)'' MMMM d, y'' - ''h:mm a' );
    return format.format(timestamp.toDate());
  }
  // PushNotification _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // PushNotification notification = PushNotification(
      //   title: message.notification?.title,
      //   body: message.notification?.body,
      //   dataTitle: message.data['title'],
      //   dataBody: message.data['body'],
      // );

      // setState(() {
      //   _notificationInfo = notification;
      // });
    });
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // PushNotification notification = PushNotification(
      //   title: message.notification?.title,
      //   body: message.notification?.body,
      //   dataTitle: message.data['title'],
      //   dataBody: message.data['body'],
      // );

      // setState(() {
      //   _notificationInfo = notification;
      // });
    });
    // NotificationSettings settings = await _messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   provisional: false,
    //   sound: true,
    // );
    //
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('User granted permission');
    //
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     print(
    //         'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
    //
    //     // Parse the message received
    //     PushNotification notification = PushNotification(
    //       title: message.notification?.title,
    //       body: message.notification?.body,
    //       dataTitle: message.data['title'],
    //       dataBody: message.data['body'],
    //     );
    //
    //     // setState(() {
    //     //   _notificationInfo = notification;
    //     // });
    //
    //     // if (_notificationInfo != null) {
    //     //   // For displaying the notification as an overlay
    //     //   showSimpleNotification(
    //     //     Text(_notificationInfo.title),
    //     //     leading: SizedBox.fromSize(
    //     //         size: const Size(40, 40),
    //     //         child: ClipOval(child: Image.asset('assets/ic_launcher.png'))),
    //     //     subtitle: Text(_notificationInfo.body),
    //     //     background: Colors.cyan.shade700,
    //     //     duration: Duration(seconds: 2),
    //     //   );
    //     // }
    //   });
    // } else {
    //   print('User declined or has not accepted permission');
    // }

  }

  // For handling notification when the app is in terminated state
  // checkForInitialMessage() async {
  //   await Firebase.initializeApp();
  //   RemoteMessage initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if (initialMessage != null) {
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //       dataTitle: initialMessage.data['title'],
  //       dataBody: initialMessage.data['body'],
  //     );
  //
  //     // setState(() {
  //     //   _notificationInfo = notification;
  //     // });
  //   }
  // }

  @override
  void initState() {
    registerNotification();
    // checkForInitialMessage();

    super.initState();
  }

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
        Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  void flushBar(BuildContext context){
    Flushbar(
      title: 'Notification',
      message: 'Successfully Sent.',
      icon: Icon(Icons.check, color: Colors.green, size: 30,),
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Send Notification',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: titleController,
                decoration: textInputDecoration.copyWith(labelText: 'TITLE'),
                maxLength: 150,
                validator: (String value){
                  if(value.isEmpty){
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: bodyController,
                decoration: textInputDecoration.copyWith(labelText: 'BODY'),
                maxLines: null,
                validator: (String value){
                  if(value.isEmpty){
                    return '';
                  }
                  return null;
                },
              ),SizedBox(height: 15),
              ButtonTheme(
                minWidth: 500.0,
                height: 50.0,
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular((5)),
                  ),
                  color: Colors.black,
                  splashColor: Colors.grey,
                  child: Text(
                    'SEND',
                    style: TextStyle(color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  onPressed: () async {
                    if(!_formKey.currentState.validate()){
                      return;
                    }
                    sendNotification();
                    flushBar(context);
                    firestoreInstance.collection('pushNotificationMessages').add(
                        {
                          'title' : titleController.text,
                          'body' : bodyController.text,
                          'createdAt' : Timestamp.now(),
                        }).then((value) => value.id);

                    titleController.clear();
                    bodyController.clear();
                  },
                ),
              ),
              SizedBox(height: 5,),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pushNotificationMessages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text('Loading . . .');
                    }else{
                      return Column(
                        children: <Widget>[
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 0);
                              },
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: ( context, index){
                                // DateTime createdAt = snapshot.data.docs[index]["createdAt"]?.toDate();
                                return Card(
                                  color: Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text('TITLE: ${snapshot.data.docs[index]['title']}'),
                                          subtitle: Text('BODY: ${snapshot.data.docs[index]['body']}'),
                                          isThreeLine: true,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(formatTimeStamp(snapshot.data.docs[index]['createdAt']),
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                        ],
                      );
                    }
                  }
              )
            ],
            // ..addAll(messages.map(buildMessage).toList(),)
          ),
        ),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     _notificationInfo != null
      //         ? Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'TITLE: ${_notificationInfo.dataTitle ?? _notificationInfo.title}',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 16.0,
      //           ),
      //         ),
      //         SizedBox(height: 8.0),
      //         Text(
      //           'BODY: ${_notificationInfo.dataBody ?? _notificationInfo.body}',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 16.0,
      //           ),
      //         ),
      //       ],
      //     )
      //         : Container(),
      //   ],
      // ),
    );
  }
}
