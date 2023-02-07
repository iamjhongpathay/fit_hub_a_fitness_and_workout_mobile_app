import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

import 'user_video_from_coach.dart';

class UserCoachDetails extends StatefulWidget {
  @override
  _UserCoachDetailsState createState() => _UserCoachDetailsState();
}

class _UserCoachDetailsState extends State<UserCoachDetails> {

  @override
  Widget build(BuildContext context) {
    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
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
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl: coachNotifier.currentCoach.image != null
                        ?coachNotifier.currentCoach.image
                        :'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                      placeholder: (context, url) =>
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Color(0x00000000),
                            child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                )),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${coachNotifier.currentCoach.coachName.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 30.0,
                        fontFamily: 'Nexa',
                      ),),
                    SizedBox(height: 5),
                    Text('${coachNotifier.currentCoach.expertise}',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    Divider(height: 40.0, thickness: 1.0),
                    Text('Details'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa', ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: coachNotifier.currentCoach.categoryDetails
                          .map((categories) => Chip(
                        labelPadding: EdgeInsets.only(left: 20, right: 20),
                        backgroundColor: Colors.blueGrey[400],
                        label: Text(categories,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                    Divider(height: 40.0, thickness: 1.0),
                    Text('ABOUT  ${coachNotifier.currentCoach.coachName.toUpperCase()}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 15),
                    Text(coachNotifier.currentCoach.aboutCoach,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        height: 1.3,
                      ),
                    ),
                    Divider(height: 40.0, thickness: 1.0),
                    Text(
                      'VIDEOS FROM  ${coachNotifier.currentCoach.coachName.toUpperCase()}',
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          fontFamily: 'Nexa'),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('workoutsExercises')
                    .where('coachName', isEqualTo: '${coachNotifier.currentCoach.coachName}').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }else{
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Container(
                        height: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index){

                            String videoUrl = snapshot.data.docs[index]["videoUrl"];
                            String thumbnailUrl = snapshot.data.docs[index]["thumbnailUrl"];
                            String title = snapshot.data.docs[index]["title"];
                            String description = snapshot.data.docs[index]["description"];
                            String competencyLevel = snapshot.data.docs[index]["competencyLevel"];
                            String coachName = snapshot.data.docs[index]["coachName"];
                            String category = snapshot.data.docs[index]['workoutsExercisesCategory'];
                            var details = snapshot.data.docs[index]['details'];
                            List<String> detailsList = new List<String>.from(details);
                            // List<Map> details = snapshot.data.docs[index]['workoutsExercisesCategory'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: SizedBox(
                                    height: 120,
                                    child: Card(
                                      semanticContainer: true,
                                      elevation: 0,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                        child: CachedNetworkImage(
                                          imageUrl: thumbnailUrl != null
                                              ?thumbnailUrl
                                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                height: 100,
                                                width: double.infinity,
                                                color: Color(0x00000000),
                                                child: Center(
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                                    )),
                                              ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (BuildContext context){
                                                return UserVideoFromCoach(
                                                  videoUrl: videoUrl,
                                                  title: title,
                                                  coachName: coachName,
                                                  competencyLevel: competencyLevel,
                                                  workoutsExercisesCategory: category,
                                                  details: detailsList,
                                                  description: description,
                                                );
                                              })
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: Text('$title',
                                          maxLines: 3,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text('$competencyLevel',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
