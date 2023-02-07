import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_member_workout_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class AssessmentResultPage extends StatefulWidget {
  AssessmentResultPage({Key key,
  }) : super(key: key);

  @override
  _AssessmentResultPageState createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  String coachName, coachDescription;




  @override
  Widget build(BuildContext context) {


    final user = Provider.of<TheUser>(context);

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;

            if(userData.goal == 'Muscle Gain'){
              coachName = 'James Lewis';
              coachDescription = "Hello, I'm your coach for gaining muscle, I'll be checking your assessment result and I'll be given to you the workout plan between 8:00AM to 3:00PM everyday.";
            }else if (userData.goal == 'Weight Loss'){
              coachName = 'Roi Aterrado';
              coachDescription = "Hello, I'm your coach for losing weight, I'll be checking your assessment result and I'll be given to you the workout plan between 3:00PM to 10:00PM everyday.";

            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title:Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
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
                child: Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          "ASSIGNED COACH".toUpperCase(),
                          style: TextStyle(
                            height: 1.2,
                            letterSpacing: 0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            // fontFamily: 'Nexa',
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child:
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text('Your Coach:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(coachName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontFamily: 'Nexa',
                                      fontWeight: FontWeight.w900
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(coachDescription,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      letterSpacing: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "YOUR ASSESSMENT RESULT",
                          style: TextStyle(
                            height: 1.2,
                            letterSpacing: 0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            // fontFamily: 'Nexa',
                            fontSize: 25.0,
                          ),
                        ),

                        SizedBox(height: 10),
                        Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child:
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                    Text('${userData.goal}'.toUpperCase(),
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
                                    Text('${userData.selectedDate}'.toUpperCase(),
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
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                    Text('${userData.gender}'.toUpperCase(),
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
                                    Text('${userData.age}'.toUpperCase(),
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
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                    Text('${userData.height} m',
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
                                    Text('${userData.weight} kg',
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
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                      Text('${userData.bmi}   |   ${userData.bmiMessage}',
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
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                    Text('${userData.heartCondition}'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontFamily: 'Nexa',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text('${userData.chestPain}'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontFamily: 'Nexa',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Text('${userData.highBloodPressure}'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontFamily: 'Nexa',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text('${userData.highCholesterol}'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontFamily: 'Nexa',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Text('${userData.medicalCondition}'.toUpperCase(),
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
                        SizedBox(height: 5,),
                        Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child:
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                Text('${userData.healthComment}'.toUpperCase(),
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
                      ],
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
