import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_member_workout_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class MemberDetailsPage extends StatefulWidget {
  final String firstName, lastName, goal, heartCondition, chestPain, highBloodPressure, highCholesterol, medicalCondition, healthComment, gender, age, height, weight, bmi, bmiMessage, email, uid, selectedDate;
  MemberDetailsPage({Key key,
    this.firstName,
    this.lastName,
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
    this.uid,
    this.selectedDate
  }) : super(key: key);

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('MEMBER DETAILS',
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
                Center(
                  child: Container(
                    child: Icon(CupertinoIcons.person_crop_circle,
                    color: Colors.blueGrey[200], size: 150,
                    ),
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
                        Text('Name:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('${widget.firstName} ${widget.lastName}'.toUpperCase(),
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
                ),
                SizedBox(height: 10),
                Text(
                  "ASSESSMENT RESULT",
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
                SizedBox(height: 30),
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
                      'WORKOUT PLANS',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (BuildContext context){
                            return MemberWorkoutPlanPage(uid: widget.uid, goal: widget.goal, firstName: widget.firstName, lastName: widget.lastName,);
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
