import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/second_question.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

class FirstQuestionPage extends StatefulWidget {
  final String email;
  FirstQuestionPage({Key key,
  this.email,
  }) : super(key: key);

  @override
  _FirstQuestionPageState createState() => _FirstQuestionPageState();
}

class _FirstQuestionPageState extends State<FirstQuestionPage> {
DateTime selectedDate = DateTime.now();
final DateFormat dateFormat = DateFormat(' MMM d, y');
  String goal;

  void _handleGoalChange(String value){
    setState(() {
      goal = value;
    });
  }

  Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
  context: context,
  initialDate: DateTime.now().add(Duration(seconds: 1)),
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
               Text("WELCOME TO FIT HUB!",
              style: TextStyle(
                  height: 1.2,
                  letterSpacing: 0,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  // fontFamily: 'Nexa',
                  fontSize: 25.0,
              ),
            ),
                  SizedBox(height: 20),
                  Text('What is your Goal?',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    color: Colors.grey[200],
                    semanticContainer: true,
                    elevation: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Radio<String>(
                          value: 'Muscle Gain',
                          groupValue: goal,
                          activeColor: Colors.blueGrey,
                          onChanged: _handleGoalChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              goal = 'Muscle Gain';
                            });
                          },
                          child: Text(
                            "MUSCLE GAIN",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, fontFamily: 'Nexa',),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    color: Colors.grey[200],
                    semanticContainer: true,
                    elevation: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Radio<String>(
                          value: 'Weight Loss',
                          groupValue: goal,
                          activeColor: Colors.blueGrey,
                          onChanged: _handleGoalChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              goal = 'Weight Loss';
                            });
                          },
                          child: Text(
                            "WEIGHT LOSS",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, fontFamily: 'Nexa',),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 5.0),
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5)
                  //   ),
                  //   color: Colors.grey[200],
                  //   semanticContainer: true,
                  //   elevation: 0,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       new Radio<String>(
                  //         value: 'Fit & Feel Healthier',
                  //         groupValue: goal,
                  //         activeColor: Colors.blueGrey,
                  //         onChanged: _handleGoalChange,
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             goal = 'Fit & Feel Healthier';
                  //           });
                  //         },
                  //         child: Text(
                  //           "FIT & FEEL HEALTHIER",
                  //           style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, fontFamily: 'Nexa',),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Text('When do you want to start your goal?',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: 20
                    ),
                  ),
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
                              return SecondQuestionPage(goal: goal, email: widget.email, selectedDate: dateFormat.format(selectedDate).toString(),);
                            })
                        );
                      },
                    ),
                  ),
          ]
        ),
      ),
    )
      )
    );
  }
}
