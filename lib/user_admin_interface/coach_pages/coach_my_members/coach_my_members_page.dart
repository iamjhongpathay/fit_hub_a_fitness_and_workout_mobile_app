import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/user_db.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_my_member_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class CoachMyMembersPage extends StatefulWidget {
  const CoachMyMembersPage({Key key}) : super(key: key);

  @override
  _CoachMyMembersPageState createState() => _CoachMyMembersPageState();
}

class _CoachMyMembersPageState extends State<CoachMyMembersPage> {
  final AuthService _auth =AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    return StreamBuilder<UserData>(
      stream: UserDatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text('MEMBERS',
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
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('userDetails')
                      .where('goal', isEqualTo: '${userData.coachingFor}').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                    }else{
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: ListView.separated(
                            itemCount: snapshot.data.docs.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider(
                                color: Colors.black,
                              );
                            },
                            itemBuilder: (BuildContext context, int index){
                              String uid = snapshot.data.docs[index].id;
                              String firstName = snapshot.data.docs[index]["firstname"];
                              String lastName = snapshot.data.docs[index]["lastname"];
                              String gender = snapshot.data.docs[index]["gender"];
                              String email = snapshot.data.docs[index]["email"];
                              String goal = snapshot.data.docs[index]["goal"];
                              String heartCondition = snapshot.data.docs[index]["heartCondition"];
                              String chestPain = snapshot.data.docs[index]["chestPain"];
                              String highBloodPressure = snapshot.data.docs[index]["highBloodPressure"];
                              String highCholesterol = snapshot.data.docs[index]["highCholesterol"];
                              String medicalCondition = snapshot.data.docs[index]["medicalCondition"];
                              String healthComment = snapshot.data.docs[index]["healthComment"];
                              String age = snapshot.data.docs[index]["age"];
                              String height = snapshot.data.docs[index]["height"];
                              String weight = snapshot.data.docs[index]["weight"];
                              String bmi = snapshot.data.docs[index]["bmi"];
                              String bmiMessage = snapshot.data.docs[index]["bmiMessage"];
                              String selectedDate = snapshot.data.docs[index]["selectedDate"];

                              return Card(
                                semanticContainer: true,
                                elevation: 0,
                                color: Colors.grey[100],
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text('$firstName $lastName'),
                                    subtitle: Text('Goal: $goal'),
                                    leading: Icon(CupertinoIcons.person_crop_circle,
                                    color: Colors.blueGrey[200], size: 50,
                                  ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (BuildContext context){
                                            return MemberDetailsPage(
                                                firstName: firstName,
                                                lastName: lastName,
                                                goal: goal,
                                                heartCondition: heartCondition,
                                                chestPain: chestPain,
                                                highBloodPressure:highBloodPressure,
                                                highCholesterol: highCholesterol,
                                                medicalCondition: medicalCondition,
                                                healthComment:healthComment,
                                                gender: gender,
                                                age: age,
                                                height: height,
                                                weight: weight,
                                                bmi: bmi,
                                                bmiMessage: bmiMessage,
                                                email: email,
                                                uid: uid,
                                              selectedDate: selectedDate,
                                            );
                                          })
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                        ),
                      );
                    }
                  }
              ),
            ),
          );
        }
        return Container();
      }
    );
  }
}
