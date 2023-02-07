import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/third_question.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

class SecondQuestionPage extends StatefulWidget {
  final String goal, email, selectedDate;
  SecondQuestionPage({Key key,
    this.goal,
    this.email,
    this.selectedDate
  }) : super(key: key);

  @override
  _SecondQuestionPageState createState() => _SecondQuestionPageState();
}

class _SecondQuestionPageState extends State<SecondQuestionPage> {
  String heartCondition, chestPain, highBloodPressure, highCholesterol, medicalCondition, healthComment;

  final DateFormat dateFormat = DateFormat(' MMMM d, y');
  void _handleHeartConditionChange(String value){
    setState(() {
      heartCondition = value;
    });
  }
  void _handleChestPainChange(String value){
    setState(() {
      chestPain = value;
    });
  }
  void _handleHighBloodPressureChange(String value){
    setState(() {
      highBloodPressure = value;
    });
  }
  void _handleHighCholesterolChange(String value) {
    setState(() {
      highCholesterol = value;
    });
  }
    void _handleMedicalConditionChange(String value){
      setState(() {
        medicalCondition = value;
      });
    }

  Widget _buildHealthComment() {
    return TextFormField(

      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'Please explain here any "YES" answers'),
      onChanged: (String value) {
        healthComment = value;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'LET FIT HUB KNOW ABOUT YOUR HEALTH STATUS',
            style: TextStyle(
              height: 1.2,
              letterSpacing: 0,
              color: Colors.black,
              fontWeight: FontWeight.w900,
              // fontFamily: 'Nexa',
              fontSize: 25.0,
            ),
                ),
                // SizedBox(height: 5),
                // Text('Answer the following health questionnaire in YES or NO',
                //   style: TextStyle(
                //       color: Colors.grey,
                //       letterSpacing: 0,
                //       fontSize: 20
                //   ),
                // ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Do you have a heart condition?',
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0,
                            fontSize: 20
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'Yes',
                                groupValue: heartCondition,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleHeartConditionChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    heartCondition = 'Yes';
                                  });
                                },
                                child: Text(
                                  "YES",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 20.0),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'No',
                                groupValue: heartCondition,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleHeartConditionChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    heartCondition = 'No';
                                  });
                                },
                                child: Text(
                                  "NO",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Do you ever experience unexplained pains in your chest at rest during workout/exercise?',
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0,
                            fontSize: 20
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'Yes',
                                groupValue: chestPain,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleChestPainChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chestPain = 'Yes';
                                  });
                                },
                                child: Text(
                                  "YES",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 20.0),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'No',
                                groupValue: chestPain,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleChestPainChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chestPain = 'No';
                                  });
                                },
                                child: Text(
                                  "NO",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Have you been told that you have high blood pressure?',
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0,
                            fontSize: 20
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'Yes',
                                groupValue: highBloodPressure,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleHighBloodPressureChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    highBloodPressure = 'Yes';
                                  });
                                },
                                child: Text(
                                  "YES",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 20.0),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.grey[200],
                          semanticContainer: true,
                          elevation: 0,
                          child: Row(
                            children: [
                              new Radio<String>(
                                value: 'No',
                                groupValue: highBloodPressure,
                                activeColor: Colors.blueGrey,
                                onChanged: _handleHighBloodPressureChange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    highBloodPressure = 'No';
                                  });
                                },
                                child: Text(
                                  "NO",
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Have you been told that you have high cholesterol?',
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0,
                            fontSize: 20
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                color: Colors.grey[200],
                                semanticContainer: true,
                                elevation: 0,
                              child: Row(
                                children: [
                                  new Radio<String>(
                                    value: 'Yes',
                                    groupValue: highCholesterol,
                                    activeColor: Colors.blueGrey,
                                    onChanged: _handleHighCholesterolChange,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        highCholesterol = 'Yes';
                                      });
                                    },
                                    child: Text(
                                      "YES",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 20.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              color: Colors.grey[200],
                              semanticContainer: true,
                              elevation: 0,
                              child: Row(
                                children: [
                                  new Radio<String>(
                                    value: 'No',
                                    groupValue: highCholesterol,
                                    activeColor: Colors.blueGrey,
                                    onChanged: _handleHighCholesterolChange,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        highCholesterol = 'No';
                                      });
                                    },
                                    child: Text(
                                      "NO",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Do you have any other medical condition(s) that may make it dangerous for you to participate in workout/exercise?',
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0,
                            fontSize: 20
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      color: Colors.grey[200],
                      semanticContainer: true,
                      elevation: 0,
                      child: Row(
                        children: [
                          new Radio<String>(
                            value: 'Yes',
                            groupValue: medicalCondition,
                            activeColor: Colors.blueGrey,
                            onChanged: _handleMedicalConditionChange,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                medicalCondition = 'Yes';
                              });
                            },
                            child: Text(
                              "YES",
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 20.0),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      color: Colors.grey[200],
                      semanticContainer: true,
                      elevation: 0,
                      child: Row(
                        children: [
                          new Radio<String>(
                            value: 'No',
                            groupValue: medicalCondition,
                            activeColor: Colors.blueGrey,
                            onChanged: _handleMedicalConditionChange,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                medicalCondition = 'No';
                              });
                            },
                            child: Text(
                              "NO",
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                _buildHealthComment(),
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
                      'CONTINUE',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: () async{
                      Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context){
                            return ThirdQuestionPage(goal: widget.goal,
                            heartCondition: heartCondition,
                              chestPain: chestPain,
                              highBloodPressure: highBloodPressure,
                              highCholesterol: highCholesterol,
                              medicalCondition: medicalCondition,
                              healthComment: healthComment,
                              email: widget.email,
                              selectedDate: widget.selectedDate,
                            );
                          })
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
