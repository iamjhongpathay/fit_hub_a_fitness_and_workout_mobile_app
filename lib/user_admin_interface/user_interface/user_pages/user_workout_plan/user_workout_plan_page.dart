import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_completed_workout_plan.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_workout_plan/user_assessment_result_details.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_workout_plan/user_completed_workout_plan.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_workout_plan/user_workout_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class UserWorkoutPlanPage extends StatefulWidget {
  const UserWorkoutPlanPage({Key key}) : super(key: key);

  @override
  _UserWorkoutPlanPageState createState() => _UserWorkoutPlanPageState();
}

class _UserWorkoutPlanPageState extends State<UserWorkoutPlanPage> {

bool isDone = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('ACTIVITY',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
            ),
          ),
          centerTitle: true
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
          child: StreamBuilder<UserData>(
          stream: UserDatabaseService(uid: user.uid).userData,
          builder: (context, snapshot){
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userDetails')
                    .doc(userData.uid)
                    .collection('workoutPlans')
                    .where('isDone', isEqualTo: isDone)
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    final docs = snapshot.data.docs;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Card(
                                  semanticContainer: true,
                                  elevation: 0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        child: Image.asset('assets/assessment.jpg'),
                                        onTap: () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(builder: (context){
                                                return AssessmentResultPage();
                                              })
                                          );
                                        },
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: Card(
                                  semanticContainer: true,
                                  elevation: 0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        child: Image.asset('assets/completed.jpg'),
                                        onTap: () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(builder: (context){
                                                return UserCompletedWorkoutPlansPage(
                                                  uid: userData.uid,
                                                  firstName: userData.firstname,
                                                  lastName: userData.lastname,
                                                );
                                              })
                                          );
                                        },
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text('ON GOING WORKOUT PLANS',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Nexa', letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var workout = snapshot.data.docs[index]['workoutList'];
                                  List<String> workoutList = new List<String>.from(workout);

                                  return Card(
                                    semanticContainer: true,
                                    elevation: 0,
                                    color: Colors.grey[100],
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Image.asset('assets/calendar.png', fit: BoxFit.cover,),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Text('${docs[index]['day']}',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          title: Text('${docs[index]['goal']}',
                                            style: TextStyle(
                                                fontSize: 20
                                            ),
                                          ),
                                          subtitle: Text('${docs[index]['selectedDate']}'),
                                          // trailing: Wrap(
                                          //   children: <Widget>[
                                          //     IconButton(
                                          //       icon: Icon(Icons.edit_outlined),
                                          //       onPressed: () {
                                          //       },
                                          //     ), // icon-1
                                          //     IconButton(
                                          //       icon: Icon(Icons.delete),
                                          //       onPressed: () async{
                                          //         await FirebaseFirestore.instance.collection('userDetails')
                                          //             .doc(widget.uid)
                                          //             .collection('workoutPlans')
                                          //             .doc(docs[index].id).delete();
                                          //       },
                                          //     ), //  // icon-2
                                          //   ],
                                          // ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(builder: (BuildContext context){
                                              return UserWorkoutDetailsPage(
                                                day: docs[index]['day'],
                                                message: docs[index]['message'],
                                                goal: docs[index]['goal'],
                                                workoutList: workoutList,
                                                firstName: userData.firstname,
                                                lastName: userData.lastname,
                                                selectedDate: docs[index]['selectedDate'],
                                                uid: userData.uid,
                                                docId: docs[index].id,
                                              );
                                            })
                                        );
                                      },
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
            );
          }
          return Container();
          }
          ),
      ),
    );
  }
}
