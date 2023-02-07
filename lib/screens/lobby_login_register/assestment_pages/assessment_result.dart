import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

class AssessmentResultPage extends StatefulWidget {
  final String goal, heartCondition, chestPain, highBloodPressure, highCholesterol, medicalCondition, healthComment, gender, age, height, weight, bmi, bmiMessage, email, selectedDate;
  AssessmentResultPage({Key key,
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
    this.selectedDate
  }) : super (key: key);


  @override
  _AssessmentResultPageState createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  final DateFormat dateFormat = DateFormat(' MMMM d, y');

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
                  "YOUR ASSESSMENT RESULT!",
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
                Text("This will be a guide for your Fit Hub coach to know what workout/exercise is right for you",
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 20),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Goal:',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('${widget.goal}'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  fontWeight: FontWeight.w900
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Target Date to Start:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('${widget.selectedDate}'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  fontWeight: FontWeight.w900
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Gender:',
                               style: TextStyle(
                                   color: Colors.white,
                                 fontSize: 20,
                                 fontWeight: FontWeight.w400
                               ),
                               ),
                               SizedBox(height: 10,),
                               Text('${widget.gender}'.toUpperCase(),
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 20,
                                     letterSpacing: 1,
                                     fontFamily: 'Nexa',
                                     fontWeight: FontWeight.w900
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(width: 150,),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Age:',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 20,
                                     fontWeight: FontWeight.w400
                                 ),
                               ),
                               SizedBox(height: 10,),
                               Text('${widget.age}'.toUpperCase(),
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 20,
                                     letterSpacing: 1,
                                     fontFamily: 'Nexa',
                                     fontWeight: FontWeight.w900
                                 ),
                               )
                             ],
                           ),

                         ],
                       ),
                      ),
                ),
                SizedBox(height: 5),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Body Mass Index:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('${widget.bmi}   |   ${widget.bmiMessage}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1,
                                    fontFamily: 'Nexa',
                                    fontWeight: FontWeight.w900
                                ),
                              )
                            ],
                          ),

                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Height:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('${widget.height} m',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  fontWeight: FontWeight.w900
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 150,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weight:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('${widget.weight} kg',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  fontWeight: FontWeight.w900
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Health Status:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Do you have a heart condition?'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                    fontFamily: 'Nexa',
                                    // fontWeight: FontWeight.w900
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Do you ever experience unexplained pains in your chest at rest during workout/exercise?'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                    fontFamily: 'Nexa',
                                    // fontWeight: FontWeight.w900
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Have you been told that you have high blood pressure?'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  // fontWeight: FontWeight.w900
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Have you been told that you have high cholesterol?'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  // fontWeight: FontWeight.w900
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Do you have any other medical condition(s) that may make it dangerous for you to participate in workout/exercise?'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontFamily: 'Nexa',
                                  // fontWeight: FontWeight.w900
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Result:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('${widget.heartCondition}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('${widget.chestPain}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 50),
                            Text('${widget.highBloodPressure}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text('${widget.highCholesterol}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 40),
                            Text('${widget.medicalCondition}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontFamily: 'Nexa',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Material(
                //   elevation: 0,
                //   borderRadius: BorderRadius.all(Radius.circular(8)),
                //   child:
                //   Container(
                //     width: 85,
                //     height: 300,
                //     padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
                //     decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: <Widget>[
                //         Text('Result:',
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 20,
                //               fontWeight: FontWeight.w400
                //           ),
                //         ),
                //         SizedBox(height: 10),
                //         Text('${widget.heartCondition}'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 1,
                //             fontFamily: 'Nexa',
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //         SizedBox(height: 30),
                //         Text('${widget.chestPain}'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 1,
                //             fontFamily: 'Nexa',
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //         SizedBox(height: 40),
                //         Text('${widget.highBloodPressure}'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 1,
                //             fontFamily: 'Nexa',
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //         SizedBox(height: 15),
                //         Text('${widget.highCholesterol}'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 1,
                //             fontFamily: 'Nexa',
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //         SizedBox(height: 35),
                //         Text('${widget.medicalCondition}'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             letterSpacing: 1,
                //             fontFamily: 'Nexa',
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 5,),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child:
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Comments from "Yes" answers:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('${widget.healthComment}'.toUpperCase(),
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 1,
                              fontFamily: 'Nexa',
                          ),
                        )
                      ],
                    ),
                  ),
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
                      'CONTINUE',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context){
                            return RegisterScreen(
                              goal: widget.goal,
                              heartCondition: widget.heartCondition,
                              chestPain: widget.chestPain,
                              highBloodPressure: widget.highBloodPressure,
                              highCholesterol: widget.highCholesterol,
                              medicalCondition: widget.medicalCondition,
                              healthComment: widget.healthComment,
                              gender: widget.gender,
                              age: widget.age,
                              height: widget.height,
                              weight: widget.weight,
                              bmi: widget.bmi,
                              bmiMessage: widget.bmiMessage,
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
