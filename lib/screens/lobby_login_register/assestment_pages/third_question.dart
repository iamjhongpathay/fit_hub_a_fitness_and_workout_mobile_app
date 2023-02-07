import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/assessment_result.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ThirdQuestionPage extends StatefulWidget {
  final String goal, heartCondition, chestPain, highBloodPressure, highCholesterol, medicalCondition, healthComment, email, selectedDate;
  ThirdQuestionPage({Key key,
    this.goal,
    this.heartCondition,
    this.chestPain,
    this.highBloodPressure,
    this.highCholesterol,
    this.medicalCondition,
    this.healthComment,
    this.email,
    this.selectedDate
  }) : super (key: key);

  @override
  _ThirdQuestionPageState createState() => _ThirdQuestionPageState();
}

class _ThirdQuestionPageState extends State<ThirdQuestionPage> {

  String gender, age, height, weight;
  String _message = '';
  double _bmi;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  void _calculate() {
    final double height = double.tryParse(_heightController.value.text);
    final double weight = double.tryParse(_weightController.value.text);

    if (height <= 0 || weight <= 0) {
      setState(() {
        _message = "Your height and weigh must be positive numbers";
      });
      return;
    }

    setState(() {
      _bmi = weight / (height * height);
      if (_bmi < 18.5) {
        _message = "Underweight";
      } else if (_bmi < 25) {
        _message = 'Normal Weight';
      } else if (_bmi < 30) {
        _message = 'Overweight';
      } else {
        _message = 'Obesity';
      }
    });
  }


  void _handleGenderChange(String value){
    setState(() {
      gender = value;
    });
  }
  Widget _buildAge() {
    return Container(
      child: TextFormField(
        maxLength: 2,
        keyboardType: TextInputType.number,
        maxLines: null,
        decoration: textInputDecoration.copyWith(prefixIcon: Icon(Icons.format_list_numbered, color: Colors.grey)),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        onChanged: (String value) {
          age = value;
        },
      ),
    );
  }
  Widget _buildHeight() {
    return Container(
      child: TextFormField(
        controller: _heightController,
        maxLength: 6,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        maxLines: null,
        decoration: textInputDecoration.copyWith(prefixIcon: Icon(Icons.height, color: Colors.grey)),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        onChanged: (String value) {
          height = value;
        },
      ),
    );
  }
  Widget _buildWeight() {
    return Container(
      child: TextFormField(
        controller: _weightController,
        maxLength: 3,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        maxLines: null,
        decoration: textInputDecoration.copyWith(prefixIcon: Icon(Icons.line_weight, color: Colors.grey)),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        onChanged: (String value) {
          weight = value;
        },
      ),
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
                  "JUST A FEW MORE STEPS AND YOU'RE DONE!",
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
                Text("What's your gender",
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 5),
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
                        value: 'Male',
                        groupValue: gender,
                        activeColor: Colors.blueGrey,
                        onChanged: _handleGenderChange,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Male';
                          });
                        },
                        child: Text(
                          "MALE",
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
                        value: 'Female',
                        groupValue: gender,
                        activeColor: Colors.blueGrey,
                        onChanged: _handleGenderChange,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Female';
                          });
                        },
                        child: Text(
                          "FEMALE",
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, fontFamily: 'Nexa',),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("What is your age?",
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 10),
                _buildAge(),
                SizedBox(height: 10),
                Text("What is your height in meter(m)?",
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 10),
                _buildHeight(),
                SizedBox(height: 15),
                Text("What is your current weight in kilogram(kg)?",
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 10),
                _buildWeight(),
                // Text(
                //   _bmi == null ? 'No Result' : _bmi.toString(),
                //   style: TextStyle(fontSize: 50),
                //   textAlign: TextAlign.center,
                // ),
                // Text(
                //   _message,
                //   textAlign: TextAlign.center),
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
                      _calculate();
                      Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context){
                            return AssessmentResultPage(
                              goal: widget.goal,
                              heartCondition: widget.heartCondition,
                              chestPain: widget.chestPain,
                              highBloodPressure: widget.highBloodPressure,
                              highCholesterol: widget.highCholesterol,
                              medicalCondition: widget.medicalCondition,
                              healthComment: widget.healthComment,
                              gender: gender,
                              age: age,
                              height: height,
                              weight: weight,
                              bmi: _bmi.toStringAsFixed(2),
                              bmiMessage: _message,
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
