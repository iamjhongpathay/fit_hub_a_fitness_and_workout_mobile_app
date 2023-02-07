import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/login.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/shared/loading.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_navbar_home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  final String goal, heartCondition, chestPain, highBloodPressure, highCholesterol, medicalCondition, healthComment, gender, age, height, weight, bmi, bmiMessage, email, selectedDate;
  RegisterScreen({Key key,
    this.goal,
    this.heartCondition,
    this.chestPain,
    this.highBloodPressure,
    this.highCholesterol,
    this.medicalCondition,
    this.healthComment,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.bmi,
    this.bmiMessage,
    this.email,
    this.selectedDate,
  }) : super (key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String firstname, lastname, password, role, coachingFor;
  String error = '';

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();



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
          child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
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
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'CREATE YOUR ACCOUNT',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Nexa',
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textInputDecoration.copyWith(hintText: 'First Name'.toUpperCase(),
                          prefixIcon: Icon(Icons.person, color: Colors.grey)),
                      validator: (val) {
                        if(val.isEmpty) {
                          pr.hide();
                          return 'First name is required.';
                        }
                        return null;
                      },
                      // maxLength: 30,
                      onChanged: (val) {
                        setState(() => firstname = val);
                      }
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textInputDecoration.copyWith(hintText: 'Last Name'.toUpperCase(),
                          prefixIcon: Icon(Icons.person, color: Colors.grey)),
                      validator: (val) {
                        if(val.isEmpty) {
                          pr.hide();
                          return 'Last name is required.';
                        }
                        return null;
                      },
                      // maxLength: 30,
                      onChanged: (val) {
                        setState(() => lastname = val);
                      }
                  ),
                  // SizedBox(height: 5.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 5.0),
                  //       child: Text('GENDER:',
                  //       style: TextStyle(
                  //         fontSize: 20, color: Colors.grey[600],
                  //       )
                  //       ),
                  //     ),
                  //     new Radio<String>(
                  //       value: 'Male',
                  //       groupValue: gender,
                  //       activeColor: Colors.black,
                  //       onChanged: _handleGenderChange,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           gender = 'Male';
                  //         });
                  //       },
                  //       child: Text(
                  //         "Male",
                  //         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //     SizedBox(width: 20.0),
                  //     new Radio<String>(
                  //       value: 'Female',
                  //       groupValue: gender,
                  //       activeColor: Colors.pink,
                  //       onChanged: _handleGenderChange,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           gender = 'Female';
                  //         });
                  //       },
                  //       child: Text(
                  //         "Female",
                  //         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Divider(height: 20, thickness: 1),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                      // style: theme.textTheme.subhead.copyWith(
                      //   color: theme.disabledColor,
                      // ),
                      initialValue: widget.email,
                      // enableInteractiveSelection: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'.toUpperCase(),
                          prefixIcon: Icon(Icons.email, color: Colors.grey)),
                      validator: (val) {
                        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                        final regExp = RegExp(pattern);
                        if(val.isEmpty) {
                          pr.hide();
                          return 'Email is required.';
                        }else if(!regExp.hasMatch(val)){
                          return 'Enter a valid Email';
                        }
                        return null;
                      },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _isObscure,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'.toUpperCase(),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey)
                      ),
                      validator: (val) {
                        if(val.length < 6){
                          pr.hide();
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => password = val);
                      }
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _confirmPassword,
                    obscureText: _isObscure,
                    decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'.toUpperCase(),
                        // suffixIcon: IconButton(
                        //     icon: Icon(
                        //       _isObscure ? Icons.visibility : Icons.visibility_off,
                        //     ),
                        //     onPressed: () {
                        //       setState(() {
                        //         _isObscure = !_isObscure;
                        //       });
                        //     }),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey)
                    ),
                    validator: (val) {
                      if(val.length < 6){
                        pr.hide();
                        return 'Please re-enter Password';
                      }
                      if(_password.text != _confirmPassword.text){
                        pr.hide();
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
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
                        'GET STARTED',
                        style: TextStyle(color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async{
                        FocusScope.of(context).unfocus();
                        await pr.show();
                        if(_formKey.currentState.validate()){
                          dynamic result = await _auth.registerEmailPassword(
                              firstname,
                              lastname,
                              widget.gender,
                              widget.email,
                              role,
                              password,
                              widget.goal,
                              widget.heartCondition,
                              widget.chestPain,
                              widget.highBloodPressure,
                              widget.highCholesterol,
                              widget.medicalCondition,
                              widget.healthComment,
                              widget.age,
                              widget.height,
                              widget.weight,
                              widget.bmi,
                              widget.bmiMessage,
                              coachingFor,
                            widget.selectedDate,
                          );
                          setState(() {
                            pr.hide();
                            loading = true;
                          });
                          if(result != null){
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(builder: (BuildContext context){
                            //       return UserNavBarHome();
                            //     })
                            // );
                            Navigator.of(context).pop();
                            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            //     UserNavBarHome()), (Route<dynamic> route) => false);
                            FirebaseMessaging.instance.subscribeToTopic('all');
                            return null;
                          }else{
                            setState(() => error = 'The Email is already registered. Choose another email.');
                            print(error);
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
                  SizedBox(height: 20.0),
                  RichText(
                    text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(text:
                          'Already have an Account?',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LogInScreen(),
                                    ),
                                  );
                                }
                          ),
                          TextSpan(
                              text: ' LOGIN',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return LogInScreen();
                                        }
                                    ),
                                  );
                                }
                          )
                        ]
                    ),
                  ),
                  // Text('Goal: ${widget.goal}'),
                  // Text('Medical Condition: ${widget.heartCondition}'),
                  // Text('Chest Pain ${widget.chestPain}'),
                  // Text('High Blood Pressure: ${widget.highBloodPressure}'),
                  // Text('High Cholesterol: ${widget.highCholesterol}'),
                  // Text('Heart Condition: ${widget.medicalCondition}'),
                  // Text('Health Comment: ${widget.healthComment}'),
                  // Text('Gender: ${widget.gender}'),
                  // Text('Age: ${widget.age}'),
                  // Text('Height: ${widget.height}'),
                  // Text('Weight: ${widget.weight}'),
                  // Text('BMI: ${widget.bmi}'),
                  // Text('BMI Message: ${widget.bmiMessage}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
