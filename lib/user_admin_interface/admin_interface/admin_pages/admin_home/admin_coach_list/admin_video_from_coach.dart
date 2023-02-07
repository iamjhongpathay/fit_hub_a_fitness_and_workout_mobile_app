import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:video_player/video_player.dart';

class AdminVideoFromCoach extends StatefulWidget {
final String videoUrl, title, coachName, competencyLevel, workoutsExercisesCategory, description;
final List details;
AdminVideoFromCoach({Key key,
  this.videoUrl,
  this.title,
  this.coachName,
  this.competencyLevel,
  this.workoutsExercisesCategory,
  this.description,
  this.details,
}) : super (key: key);
  @override
  _AdminVideoFromCoachState createState() => _AdminVideoFromCoachState();
}

class _AdminVideoFromCoachState extends State<AdminVideoFromCoach> {
  @override
  Widget build(BuildContext context) {
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
                      widget.videoUrl != null
                          ?widget.videoUrl
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
                    Text('${widget.title.toUpperCase()}',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0,
                        fontFamily: 'Nexa',
                      ),),
                    Text('By ${widget.coachName}',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text('${widget.competencyLevel}'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold
                          ),),
                        SizedBox(width: 10,),
                        Text('${widget.workoutsExercisesCategory}'.toUpperCase(),
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
                      children: widget.details.map((details) => Chip(
                        labelPadding: EdgeInsets.only(left: 20, right: 20),
                        backgroundColor: Colors.blueGrey[400],
                        label: Text(details,
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
                      child: Text('${widget.description}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
