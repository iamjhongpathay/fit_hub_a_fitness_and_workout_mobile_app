import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/email_verification.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/forgot_password.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'assestment_pages/first_question.dart';



class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  bool _isObscure = true;


  @override
  Widget build(BuildContext context) {

    final ProgressDialog pr = ProgressDialog(context ,
      type: ProgressDialogType.Normal,
      isDismissible: false, showLogs: true,
    );

    pr.style(message: '      Please Wait . . . ',
      padding: EdgeInsets.all(20.0),
      messageTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15.0),
      progressWidget: Container(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
      backgroundColor: Colors.white,
      borderRadius: 5.0,
      elevation: 0.0,
      insetAnimCurve: Curves.ease,
    );

    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
    TextStyle linkStyle = TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
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
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          fontFamily: 'Nexa',
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'.toUpperCase(),
                          prefixIcon: Icon(Icons.email, color: Colors.grey)),
                      validator: (val) {
                        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                        final regExp = RegExp(pattern);
                        if(val.isEmpty){
                          pr.hide();
                          return 'Enter an Email';
                        }else if(!regExp.hasMatch(val)){
                          return 'Enter a valid Email';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() { email = val;
                        });
                      }
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _isObscure,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'.toUpperCase(),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey)
                      ),
                      validator: (val) {
                        if(val.length <6) {
                          pr.hide();
                          return 'Password must be at least 6 characters long';
                        }else {
                          return null;
                        }
                      },
                      onChanged: (val){
                        setState(() { password = val;
                        });
                      }
                  ),
                  SizedBox(height: 30.0),
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
                        'LOGIN',
                        style: TextStyle(color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async{
                        await pr.show();
                        if(_formKey.currentState.validate()){
                          dynamic result = await _auth.signInEmailPassword(email, password);
                          setState(() {
                            pr.hide();
                            loading = true;
                          });
                          if(result != null){
                            Navigator.pop(context);
                            FirebaseMessaging.instance.subscribeToTopic('all');
                            return null;
                          }else{
                            setState(() {
                              error = 'No corresponding user record.';
                            });

                            loading = false;
                            pr.hide();
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Don't have an Account?",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                }
                          ),
                          TextSpan(
                              text: ' REGISTER',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmailVerificationPage(),
                                    ),
                                  );
                                }
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(height: 1, thickness: 1, indent: 115, endIndent: 115,),
                  SizedBox(height: 10,),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Forgot your Password?",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                }
                          ),
                ],
              ),
            ),
            ]
          ),
        ),
    )
        ),
      )
    );
  }
}