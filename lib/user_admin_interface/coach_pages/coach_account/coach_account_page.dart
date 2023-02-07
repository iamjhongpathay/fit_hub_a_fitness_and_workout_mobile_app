

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/lobby.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_account/coach_account_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class CoachAccountPage extends StatefulWidget {
  CoachAccountPage ({Key key}) : super(key: key);
  @override
  _CoachAccountPageState createState() => _CoachAccountPageState();
}

class _CoachAccountPageState extends State<CoachAccountPage> {

  final AuthService _auth =AuthService();

  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 13.0);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<TheUser>(context);

    void _logoutDialog(){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('LOGOUT',
              style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Text('Are you sure you want to logout'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(

                child: Text('YES',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pop(
                      MaterialPageRoute(builder: (BuildContext context){
                        return LobbyScreen();
                      })
                  );

                  FirebaseMessaging.instance.unsubscribeFromTopic('all');
                },
              )
            ],
          );
        },
      );
    }

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot){
          if (snapshot.hasData){
            UserData userData = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text('ACCOUNT',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.white,
              body: OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child){
                  final bool connected =
                      connectivity != ConnectivityResult.none;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      child,
                      Positioned(
                          left: 0.0,
                          right: 0.0,
                          height: 25.0,
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              color: connected ? null : Color(0xFFEE4400),
                              child: connected ? null :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('No internet connection', style: TextStyle(color: Colors.white),),
                                ],
                              )
                          )
                      )
                    ],
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                          child: Image.asset('assets/fithub_logo_blk.png', fit: BoxFit.cover, scale: 3.0),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'PERSONAL DETAILS',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Nexa'),
                                  ),
                                  TextSpan(
                                      style: linkStyle.copyWith(fontFamily: 'Nexa', fontWeight: FontWeight.bold),
                                      text: '                                                                       Edit',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CoachAccountSettings(),
                                            ),
                                          );
                                        }
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text('Name'.toUpperCase(), style: TextStyle(fontSize: 12.0, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                                '${userData.firstname} ${userData.lastname}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, letterSpacing: 0.5)
                            ),
                            SizedBox(height: 15.0),
                            Text('Email'.toUpperCase(), style: TextStyle(fontSize: 12.0, letterSpacing: 0.5, fontWeight: FontWeight.bold)
                            ),
                            SizedBox(height: 5.0),
                            Text(
                                '${userData.email}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, letterSpacing: 0.5)
                            ),
                            SizedBox(height: 15.0),
                            Text('Gender'.toUpperCase(), style: TextStyle(fontSize: 12.0, letterSpacing: 0.5, fontWeight: FontWeight.bold)
                            ),
                            SizedBox(height: 5.0),
                            Text(
                                '${userData.gender}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, letterSpacing: 0.5)
                            ),

                            Divider(height: 50.0, thickness: 2.0),
                            ButtonTheme(
                              minWidth: 500.0,
                              height: 50.0,
                              child: RaisedButton(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                                ),
                                color: Colors.black,
                                splashColor: Colors.grey,
                                child: Text(
                                  'LOGOUT',
                                  style: TextStyle(color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                onPressed: () async {
                                  _logoutDialog();
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else{
            return Container();
          }
        }
    );
  }
}
