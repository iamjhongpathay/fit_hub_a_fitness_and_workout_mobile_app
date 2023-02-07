import 'package:another_flushbar/flushbar.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/first_question.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:email_auth/email_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  ProgressDialog pr ;

  void sendOTP() async{
    EmailAuth.sessionName = 'FIT HUB EMAIL VERIFICATION';
    pr.show();
    var result = await EmailAuth.sendOtp(receiverMail: _emailController.text);
    pr.hide();
    if(result){
      Flushbar(
        title: 'Please check your email',
        message: 'OTP is already sent to ${_emailController.text}.',
        duration: Duration(seconds: 10),
        icon: Icon(
          Icons.check,
          color: Colors.greenAccent,
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
      )..show(context);
      print('OTP Sent!');
    }else{
      Flushbar(
        message: "We couldn't sent OTP. Please try again.",
        duration: Duration(seconds: 5),
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
      )..show(context);
      print("We couldn't sent OTP!");
    }
  }



  void verifyOTP() async{
    var result = EmailAuth.validate(receiverMail: _emailController.text, userOTP: _otpController.text);
    if(result){
      print('OTP Verified!');
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context){
            return FirstQuestionPage(email: email,);
          })
      );
    }else{
      Flushbar(
        message: "Invalid OTP!",
        duration: Duration(seconds: 5),
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
      )..show(context);
      print('Invalid OTP!');
    }
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context ,
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
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("VERIFICATION",
                    style: TextStyle(
                      height: 1.2,
                      letterSpacing: 0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      // fontFamily: 'Nexa',
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('We will send you a 6-digit One Time Password on your email address',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 18
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Enter your email -> Press GET OTP',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'.toUpperCase(),
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                      suffixText: '|', suffixStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                      suffixIcon: TextButton(child: Text(' GET OTP  ', style: TextStyle(color: Colors.blueAccent, fontSize: 18),),
                        onPressed: () {
                        FocusScope.of(context).unfocus();
                        sendOTP();
                        },
                      ),),
                      validator: (val) {
                        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                        final regExp = RegExp(pattern);
                        if(val.isEmpty) {
                          // pr.hide();
                          return 'Email is required.';
                        }else if(!regExp.hasMatch(val)){
                          return 'Enter a valid Email';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      }
                  ),
                  SizedBox(height: 10,),
                  Text('Check your email -> Enter OTP -> VERIFY',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 6,
                      controller: _otpController,
                      decoration: textInputDecoration.copyWith(hintText: 'ONE TIME PASSWORD'.toUpperCase(),
                          prefixIcon: Icon(Icons.verified, color: Colors.grey)),
                      // validator: (val) {
                      //   final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      //   final regExp = RegExp(pattern);
                      //   if(val.isEmpty) {
                      //     // pr.hide();
                      //     return 'Email is required.';
                      //   }else if(!regExp.hasMatch(val)){
                      //     return 'Enter a valid Email';
                      //   }
                      //   return null;
                      // },
                      // onChanged: (val) {
                      //   setState(() => email = val);
                      // }
                  ),
                  SizedBox(height: 20.0),
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
                        'VERIFY',
                        style: TextStyle(color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async{
                        verifyOTP();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
