import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class UserCompletedWorkoutDetailsPage extends StatefulWidget {
  final String day, message, goal, firstName, lastName, selectedDate;
  final List workoutList, result;
  UserCompletedWorkoutDetailsPage({Key key,
        this.day,
        this.message,
        this.workoutList,
        this.goal,
        this.firstName,
        this.lastName,
        this.selectedDate,
        this.result
  }) : super(key: key);

  @override
  _UserCompletedWorkoutDetailsPageState createState() => _UserCompletedWorkoutDetailsPageState();
}

class _UserCompletedWorkoutDetailsPageState extends State<UserCompletedWorkoutDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 30),
                  // Divider(height: 40.0, thickness: 1.0),
                  Text('Workout Instructions'.toUpperCase(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),

                  ),
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.grey[200],
                    semanticContainer: true,
                    elevation: 0,
                    child: Column(
                        children: <Widget>[
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
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.grey[200],
                    semanticContainer: true,
                    elevation: 0,
                    child: Column(
                        children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.result.length,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                child: Text(widget.result[index].toString(),
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

