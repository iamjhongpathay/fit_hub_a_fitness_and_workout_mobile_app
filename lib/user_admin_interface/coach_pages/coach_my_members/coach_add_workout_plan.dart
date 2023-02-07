

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

class AddWorkoutPlanPage extends StatefulWidget {
  final String uid, goal;
  const AddWorkoutPlanPage({Key key,
  this.uid,
    this.goal,
  }) : super(key: key);

  @override
  _AddWorkoutPlanPageState createState() => _AddWorkoutPlanPageState();
}

class _AddWorkoutPlanPageState extends State<AddWorkoutPlanPage> {
List _workoutList = [], _result = [];
TextEditingController workoutController = new TextEditingController();
TextEditingController daysController = new TextEditingController();
TextEditingController messageController = new TextEditingController();
TextEditingController selectedDateController = new TextEditingController();
String imgUrl, height, weight, bmi, bmiMessage;
DateTime selectedDate = DateTime.now();
final DateFormat dateFormat = DateFormat(' MMM d, y');


  Widget _addWorkoutPlan (String text){
    if(text.isNotEmpty){
      setState(() {
        _workoutList.add(text.toUpperCase());
      });
      workoutController.clear();
    }
  }

Widget _buildWorkoutPlanField() {
  return SizedBox(width: 280,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: workoutController,
      decoration: textInputDecoration.copyWith(labelText: 'Instruction'.toUpperCase()),
    ),
  );
}

saveWorkoutPlan() async{
    var timestamp = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(widget.uid)
        .collection('workoutPlans')
        .doc().set({'day': daysController.text,
      'message': messageController.text,
      'workoutList': _workoutList,
      'createdAt': timestamp,
      'imageUrl': imgUrl,
      'result': _result,
      'goal': widget.goal,
      'selectedDate': dateFormat.format(selectedDate).toString(),
      'isDone' : false,
    });

}

Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime(2100),
);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('ADD WORKOUT PLAN',
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
                SizedBox(
                  child: TextFormField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textInputDecoration.copyWith(labelText: 'DAY'.toUpperCase(),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Text('  DATE TO START:'),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('${dateFormat.format(selectedDate).toString()}',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      ButtonTheme(
                        minWidth: 50.0,
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                          ),
                          color: Colors.grey[200],
                          splashColor: Colors.grey,
                          child: Icon(Icons.date_range, color: Colors.black),
                          onPressed: () async {
                            final selectedDate = await _selectDateTime(context);
                            if (selectedDate == null) return;

                            setState(() {
                              this.selectedDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedDate.weekday
                              );
                            });
                          },
                        ),
                      ),
                    ]
                ),
                // SizedBox(height: 10,),
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   controller: selectedDateController,
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   decoration: textInputDecoration.copyWith(labelText: 'Format: Month-Day-Year'.toUpperCase(),
                //   ),
                // ),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  controller: messageController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textInputDecoration.copyWith(labelText: 'Message'.toUpperCase(),
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
                          _addWorkoutPlan(workoutController.text);
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
                          children: _workoutList
                              .map((workout) => Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            child: ListTile(
                              title: Text(workout),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red,),
                                onPressed: () {
                                  setState(() {
                                    _workoutList.remove(workout);
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
                // Text(widget.goal),
                // Text(widget.firstName),
                // Text(widget.lastName)
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
                      'SAVE',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: (){
                      saveWorkoutPlan();
                      Navigator.pop(context);
                      Flushbar(
                        message: 'Day ${daysController.text} Workout saved!',
                        duration: Duration(seconds: 1),
                        flushbarStyle: FlushbarStyle.FLOATING,
                      )..show(context);
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
