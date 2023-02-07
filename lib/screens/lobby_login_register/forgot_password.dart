import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:progress_dialog/progress_dialog.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String email;
  final auth = FirebaseAuth.instance;


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

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('RESET PASSWORD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        fontFamily: 'Nexa',
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Enter your Email address below to reset password',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
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
                        'SEND REQUEST',
                        style: TextStyle(color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async{
                        await pr.show();
                        if(_formKey.currentState.validate()){
                          auth.sendPasswordResetEmail(email: email);
                          pr.hide();
                          flushBar(context);
                          setState(() {

                            pr.hide();
                          });
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Reset Password link is already sent. Please check your email.',
      duration: Duration(seconds: 10),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
