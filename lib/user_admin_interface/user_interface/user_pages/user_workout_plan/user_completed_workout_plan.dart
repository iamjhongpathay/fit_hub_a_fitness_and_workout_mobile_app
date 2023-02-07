import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_add_workout_plan.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_update_workout_plan.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_my_member_details.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_workout_details_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_workout_plan/user_completed_workout_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class UserCompletedWorkoutPlansPage extends StatefulWidget {
  final String uid, firstName, lastName;
  const UserCompletedWorkoutPlansPage({Key key,
    this.uid,
    this.firstName,
    this.lastName
  }) : super(key: key);

  @override
  _UserCompletedWorkoutPlansPageState createState() => _UserCompletedWorkoutPlansPageState();
}

class _UserCompletedWorkoutPlansPageState extends State<UserCompletedWorkoutPlansPage> {
  bool isDone = true;

  @override
  Widget build(BuildContext context) {

    // void _showAddWorkoutPlanPanel() {
    //   showModalBottomSheet(context: context, builder: (context){
    //     return Container(
    //       color: Color(0xFF737373),
    //       child: Container(
    //         padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    //         decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //               topLeft: const Radius.circular(10),
    //               topRight: const Radius.circular(10),
    //             )
    //         ),
    //         child: AddWorkoutPlanPage(uid: widget.uid, goal: widget.goal),
    //       ),
    //     );
    //   });
    // }

    void _showUpdateWorkoutPlanPanel() {

    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('COMPLETED WORKOUT',
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
        child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userDetails')
                  .doc(widget.uid)
                  .collection('workoutPlans').where('isDone', isEqualTo: isDone)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  final docs = snapshot.data.docs;

                  return Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var workout = snapshot.data.docs[index]['workoutList'];
                          List<String> workoutList = new List<String>.from(workout);
                          var result = snapshot.data.docs[index]['result'];
                          List<String> resultList = new List<String>.from(result);

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
                                //   trailing: Wrap(
                                //   children: <Widget>[
                                //     IconButton(
                                //     icon: Icon(Icons.edit_outlined),
                                //       onPressed: () {
                                //         showModalBottomSheet(context: context, builder: (context){
                                //           return Container(
                                //             color: Color(0xFF737373),
                                //             child: Container(
                                //               padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                //               decoration: BoxDecoration(
                                //                   color: Colors.white,
                                //                   borderRadius: BorderRadius.only(
                                //                     topLeft: const Radius.circular(10),
                                //                     topRight: const Radius.circular(10),
                                //                   )
                                //               ),
                                //               child: UpdateWorkoutPlanPage(
                                //                 day: docs[index]['day'],
                                //                 message: docs[index]['message'],
                                //                 goal: docs[index]['goal'],
                                //                 workoutList: workoutList,
                                //                 selectedDate: docs[index]['selectedDate'],
                                //                 docId: docs[index].id,
                                //                 uid: widget.uid,
                                //               ),
                                //             ),
                                //           );
                                //         });
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
                                      return UserCompletedWorkoutDetailsPage(
                                          day: docs[index]['day'],
                                          message: docs[index]['message'],
                                          goal: docs[index]['goal'],
                                          workoutList: workoutList,
                                          firstName: widget.firstName,
                                          lastName: widget.lastName,
                                          selectedDate: docs[index]['selectedDate'],
                                          result: resultList
                                      );
                                    })
                                );
                              },
                            ),
                          );
                        }
                    ),
                  );
                }
              }
            )

        ),

    );
  }
}
