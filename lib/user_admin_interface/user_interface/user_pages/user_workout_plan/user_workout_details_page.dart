import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_workout_plan/user_workout_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class UserWorkoutDetailsPage extends StatefulWidget {
  final String day, message, goal, firstName, lastName, selectedDate, uid, docId;
  final List workoutList;
  UserWorkoutDetailsPage({Key key,
        this.day,
        this.message,
        this.workoutList,
        this.goal,
        this.firstName,
        this.lastName,
        this.selectedDate,
    this.uid,
    this.docId
  }) : super(key: key);

  @override
  _UserWorkoutDetailsPageState createState() => _UserWorkoutDetailsPageState();
}

class _UserWorkoutDetailsPageState extends State<UserWorkoutDetailsPage> {
  List _workoutResult = [];
  TextEditingController workoutResultController = new TextEditingController();


  Widget _addWorkoutResult (String text){
    if(text.isNotEmpty){
      setState(() {
        _workoutResult.add(text.toUpperCase());
      });
      workoutResultController.clear();
    }
  }

  Widget _buildWorkoutPlanField() {
    return SizedBox(width: 280,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: workoutResultController,
        decoration: textInputDecoration.copyWith(labelText: 'e.g., weight, waistline. .'.toUpperCase()),
      ),
    );
  }

  updateWorkoutResult() async{
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(widget.uid)
        .collection('workoutPlans')
        .doc(widget.docId).update({
      'result': _workoutResult,
      'isDone' : true,
    });
    Navigator.of(context).pop(
        MaterialPageRoute(builder: (BuildContext context){
          return UserWorkoutPlanPage();
        })
    );
  }


  @override
  Widget build(BuildContext context) {

    void _finishDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ARE YOU SURE?',
              style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Text(
                'Do you really want to finish these workouts?'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(

                child: Text('YES',
                    style: TextStyle(fontSize: 18.0,
                        color: Colors.red
                    )
                ),
                onPressed: () {
                  updateWorkoutResult();
                  Navigator.of(context).pop();
                  Flushbar(
                    message: 'Congratulations! You Finish your workout for today.',
                    duration: Duration(seconds: 5),
                    flushbarStyle: FlushbarStyle.FLOATING,
                  )..show(context);


                },
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('WORKOUT PLAN DETAILS',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                  child: Container(
                    height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset('assets/calendar.png', fit: BoxFit.cover,),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(widget.day,
                              style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ),

                    ]
                ),
              ),
          )
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text('DAY   ${widget.day.toUpperCase()}',
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            fontFamily: 'Nexa',
                          ),),

                      ),

                      SizedBox(height: 5,),
                      Text(widget.goal,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          fontFamily: 'Nexa',
                        ),),

                    ],
                  ),
                  SizedBox(height: 15,),
                  Text('Start on: ${widget.selectedDate}',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),),
                  Divider(height: 20.0, thickness: 1.0),
                  SizedBox(height: 15,),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Message From Coach'.toUpperCase(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                          ),
                          SizedBox(height: 5,),
                          Text(widget.message,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider(height: 40.0, thickness: 1.0),

                  SizedBox(height: 15),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.grey[200],
                    semanticContainer: true,
                    elevation: 0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 15, left: 15, right: 15),
                            child: Text('Workout Instructions'.toUpperCase(),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),

                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.workoutList.length,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                child: Text('• ${widget.workoutList[index].toString()}',
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                        ]
                    ),
                  ),
                  Divider(height: 40.0, thickness: 1.0),
                  Text('PROVIDE RESULTS FROM THIS WORKOUT'.toUpperCase(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                  ),
                  Text('Providing results is to determine by your coach to know what other workout can be given to you for the next activities.',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildWorkoutPlanField(),
                      ButtonTheme(
                        minWidth: 20,
                        height: 50,
                        child: RaisedButton(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                          ),
                          color: Colors.white10,
                          splashColor: Colors.grey,
                          child: Icon(Icons.add_circle,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            _addWorkoutResult(workoutResultController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          height: 300,
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: ListView(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: _workoutResult
                                .map((workout) => Card(
                              color: Colors.grey[100],
                              elevation: 0,
                              child: ListTile(
                                title: Text(workout),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red,),
                                  onPressed: () {
                                    setState(() {
                                      _workoutResult.remove(workout);
                                    });
                                  },
                                ),
                              ),
                            )).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('NOTE: Make it sure you already finish this workout and providing result before you click to finish.',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 15),
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
                        'FINISHED',
                        style: TextStyle(color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: (){
                        _finishDialog();
                      },
                    ),
                  ),
                ],
              ),
          ),

            ],
          ),
        ),
      ),
    );
  }
}

