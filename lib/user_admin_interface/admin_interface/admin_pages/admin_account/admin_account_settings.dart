import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'admin_account_page.dart';

class AdminAccountSettings extends StatefulWidget {
  @override
  _AdminAccountSettingsState createState() => _AdminAccountSettingsState();
}

class _AdminAccountSettingsState extends State<AdminAccountSettings> {

  final _formKey = GlobalKey<FormState>();

  String
      _currentFirstname,
      _currentLastname,
      _currentGender,
      _currentEmail,
      _role,
      _goal,
      _heartCondition,
      _chestPain,
      _highBloodPressure,
      _highCholesterol,
      _medicalCondition,
      _healthComment,
      _age,
      _height,
      _weight,
      _bmi,
      _bmiMessage,
      _coachingFor,
      _selectedDate;

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

    ThemeData theme = Theme.of(context);
    final user = Provider.of<TheUser>(context);

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){

            UserData userData = snapshot.data;

            void _handleGenderChange(String value){
              setState(() {
                _currentGender = value;
              });
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  'PERSONAL DETAILS',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
                  onPressed: () => Navigator.of(context).pop(AdminAccountPage()),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              initialValue: _currentFirstname ?? userData.firstname,
                              decoration: textInputDecoration.copyWith(labelText: 'First Name'.toUpperCase(),
                                  prefixIcon: Icon(Icons.person, color: Colors.grey)),
                              validator: (val) {
                                if(val.isEmpty) {
                                  pr.hide();
                                  return "Please fill in this field";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() => _currentFirstname = val);
                              }
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                              initialValue: _currentLastname ?? userData.lastname,
                              decoration: textInputDecoration.copyWith(labelText: 'Last Name'.toUpperCase(),
                                  prefixIcon: Icon(Icons.person, color: Colors.grey)),
                              validator: (val) {
                                if(val.isEmpty) {
                                  pr.hide();
                                  return "Please fill in this field";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() => _currentLastname = val);
                              }
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('GENDER:',
                                    style: TextStyle(
                                      fontSize: 20, color: Colors.grey[600],
                                    )
                                ),
                              ),
                              new Radio<String>(
                                value: 'Male',
                                groupValue: _currentGender ?? userData.gender,
                                activeColor: Colors.black,
                                onChanged: _handleGenderChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentGender = 'Male';
                                  });
                                },
                                child: Text(
                                  "Male",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              new Radio<String>(
                                value: 'Female',
                                groupValue: _currentGender ?? userData.gender,
                                activeColor: Colors.pink,
                                onChanged: _handleGenderChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentGender = 'Female';
                                  });
                                },
                                child: Text(
                                  "Female",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          TextFormField(
                              initialValue: _currentEmail ?? userData.email,
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              keyboardType: TextInputType.emailAddress,
                              style: theme.textTheme.subhead.copyWith(
                                color: theme.disabledColor,
                              ),
                              decoration: textInputDecoration.copyWith(labelText: 'Email'.toUpperCase(),
                                  prefixIcon: Icon(Icons.email, color: Colors.grey)),
                              validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                              onChanged: (val) {
                                setState(() => _currentEmail = val);
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
                                'UPDATE',
                                style: TextStyle(color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              onPressed: () async{
                                await pr.show();
                                if(_formKey.currentState.validate()){
                                  await UserDatabaseService(uid: userData.uid).updateUserData(
                                    _currentFirstname ?? userData.firstname,
                                    _currentLastname ?? userData.lastname,
                                    _currentGender ?? userData.gender,
                                    _currentEmail ?? userData.email,
                                    _role ?? userData.role,
                                    _goal ?? userData.goal,
                                    _heartCondition ?? userData.heartCondition,
                                    _chestPain ?? userData.chestPain,
                                    _highBloodPressure ?? userData.highBloodPressure,
                                    _highCholesterol ?? userData.highCholesterol,
                                    _medicalCondition ?? userData.medicalCondition,
                                    _healthComment ?? userData.healthComment,
                                    _age ?? userData.height,
                                    _height ?? userData.height,
                                    _weight ?? userData.weight,
                                    _bmi ?? userData.bmi,
                                    _bmiMessage ?? userData.bmiMessage,
                                    _coachingFor ?? userData.coachingFor,
                                      _selectedDate ?? userData.selectedDate
                                  );
                                  pr.hide();
                                  Navigator.pop(context);
                                }
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
          }else{
            return Container();
          }
        }
    );
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}