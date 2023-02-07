import 'package:another_flushbar/flushbar.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/workoutsExercises.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'admin_all_workouts_exercises_form.dart';

class AdminAllWorkoutsExercisesDetails extends StatefulWidget {
  @override
  _AdminAllWorkoutsExercisesDetailsState createState() => _AdminAllWorkoutsExercisesDetailsState();
}

class _AdminAllWorkoutsExercisesDetailsState extends State<AdminAllWorkoutsExercisesDetails> {

  @override
  Widget build(BuildContext context) {
    AllWorkoutsExercisesNotifier allWorkoutsExercisesNotifier = Provider.of<AllWorkoutsExercisesNotifier>(context);

    Future<void> _refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getAllWorkoutsExercises(allWorkoutsExercisesNotifier);
    }

    _onWorkoutsExercisesDeleted(WorkoutsExercises workoutsExercises){
      Navigator.pop(context);
      allWorkoutsExercisesNotifier.deleteWorkoutsExercises(workoutsExercises);
      flushBar(context);
    }

    void _deleteDialog(){
      showDialog(
        context: context,
        builder: (BuildContext context){
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
            content: Text('Do you really want to delete these records? This process cannot be undone.'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(

                child: Text('DELETE',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.red
                    )
                ),
                onPressed: () {
                  deleteAllWorkoutsExercises(allWorkoutsExercisesNotifier.currentWorkoutsExercises, _onWorkoutsExercisesDeleted);
                  Navigator.of(context).pop();
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
        title: Image.asset(
            'assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
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
              AspectRatio(
                aspectRatio: 16/9,
                child: VideoPlayerChewie(
                  videoPlayerController: VideoPlayerController.network(
                      allWorkoutsExercisesNotifier.currentWorkoutsExercises.videoUrl != null
                          ?allWorkoutsExercisesNotifier.currentWorkoutsExercises.videoUrl
                          :'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/error.mp4'
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${allWorkoutsExercisesNotifier.currentWorkoutsExercises.title.toUpperCase()}',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0,
                        fontFamily: 'Nexa',
                      ),),

                    Text('By ${allWorkoutsExercisesNotifier.currentWorkoutsExercises.coachName}',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text('${allWorkoutsExercisesNotifier.currentWorkoutsExercises.competencyLevel}'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold
                          ),),
                        SizedBox(width: 10,),
                        Text('${allWorkoutsExercisesNotifier.currentWorkoutsExercises.workoutsExercisesCategory}'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                    Divider(height: 20.0, thickness: 1.0),
                    SizedBox(height: 5,),
                    Text(' Details'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    Wrap(
                      spacing: 10,
                      children: allWorkoutsExercisesNotifier.currentWorkoutsExercises.details
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
                    SizedBox(height: 5),
                    Text(' Description'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(allWorkoutsExercisesNotifier.currentWorkoutsExercises.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          height: 1.3,
                        ),
                      ),
                    ),
                    // Divider(height: 40.0, thickness: 1.0),
                    // Text(
                    //   'RELATED VIDEOS',
                    //   style: TextStyle(color: Colors.black,
                    //       fontWeight: FontWeight.w900,
                    //       fontSize: 14,
                    //       fontFamily: 'Nexa'),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Container(
              //   height: 210,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: workoutsExercisesNotifier.workoutsExercisesList.length,
              //     itemBuilder: (BuildContext context, int index){
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 5.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SizedBox(
              //               width: 200,
              //               child: Card(
              //                 semanticContainer: true,
              //                 elevation: 1,
              //                 clipBehavior: Clip.antiAliasWithSaveLayer,
              //                 child: InkWell(
              //                   child: Image.network(
              //                     workoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl != null
              //                         ?workoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl
              //                         : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
              //                     fit: BoxFit.cover,
              //                   ),
              //                   onTap: () {
              //                     workoutsExercisesNotifier.currentWorkoutsExercises = workoutsExercisesNotifier.workoutsExercisesList[index];
              //                     Navigator.of(context).push(
              //                         MaterialPageRoute(builder: (BuildContext context){
              //                           return AdminWorkoutsExercisesDetails();
              //                         })
              //                     );
              //                   },
              //                 ),
              //               ),
              //             ),
              //             SizedBox(height: 5),
              //             Padding(
              //               padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: <Widget>[
              //                   SizedBox(
              //                     width: 170,
              //                     child: Text(workoutsExercisesNotifier.workoutsExercisesList[index].title,
              //                       maxLines: 3,
              //                       textAlign: TextAlign.left,
              //                       style: TextStyle(
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(height: 3,),
              //                   Container(
              //                     decoration: BoxDecoration(
              //                       color: Colors.blueGrey,
              //                       border: Border.all(color: Colors.blueGrey,),
              //                       borderRadius: BorderRadius.all(Radius.circular(2)),
              //                     ),
              //                     child: Text(workoutsExercisesNotifier.workoutsExercisesList[index].competencyLevel,
              //                       textAlign: TextAlign.left,
              //                       style: TextStyle(
              //                           color: Colors.white
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),

            ],
          ),
        ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'button1',
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (BuildContext context){
                      return AdminAllWorkoutsExercisesForm(isUpdating: true);
                    })
                );
              },

              child: const Icon(Icons.edit_outlined, color: Colors.white),
              elevation: 0,
              backgroundColor: Colors.blue.withOpacity(0.7),
            ),
            SizedBox(height: 15),
            FloatingActionButton(
              heroTag: 'button2',
              onPressed: () {
                _deleteDialog();
              },

              child: const Icon(CupertinoIcons.delete, color: Colors.white),
              elevation: 0,
              backgroundColor: Colors.blue.withOpacity(0.7),
            ),
          ]
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Data Successfully Deleted.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
