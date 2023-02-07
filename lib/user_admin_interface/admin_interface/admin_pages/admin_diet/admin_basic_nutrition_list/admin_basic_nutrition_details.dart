import 'package:another_flushbar/flushbar.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/basicNutrition.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'admin_basic_nutrition_form.dart';

class AdminBasicNutritionDetails extends StatefulWidget {
  @override
  _AdminBasicNutritionDetailsState createState() => _AdminBasicNutritionDetailsState();
}

class _AdminBasicNutritionDetailsState extends State<AdminBasicNutritionDetails> {
  @override
  Widget build(BuildContext context) {
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context);

    _onBasicNutritionDeleted(BasicNutrition basicNutrition){
      Navigator.pop(context);
      basicNutritionNotifier.deleteBasicNutrition(basicNutrition);
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
                  deleteBasicNutrition(basicNutritionNotifier.currentBasicNutrition, _onBasicNutritionDeleted);
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
        title: Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16/9,
              child: VideoPlayerChewie(
                videoPlayerController: VideoPlayerController.network(
                    basicNutritionNotifier.currentBasicNutrition.videoUrl != null
                        ?basicNutritionNotifier.currentBasicNutrition.videoUrl
                        :'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/error.mp4',
                ),
              ),
              // child: Image.network(basicNutritionNotifier.currentBasicNutrition.thumbnail != null
              //     ?basicNutritionNotifier.currentBasicNutrition.thumbnail
              //     :'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
              // ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${basicNutritionNotifier.currentBasicNutrition.title.toUpperCase()}',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 25.0,
                      fontFamily: 'Nexa',
                    ),),
                  Text('By ${basicNutritionNotifier.currentBasicNutrition.coachName}',
                    style: TextStyle(
                      color: Colors.black,
                    ),),
                  SizedBox(height: 5),
                  Divider(height: 40.0, thickness: 1.0),
                  Text(' Details'.toUpperCase(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa'),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: basicNutritionNotifier.currentBasicNutrition.details
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
                  Text(' Description'.toUpperCase(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                  ),
                  SizedBox(height: 15),
                  Text(basicNutritionNotifier.currentBasicNutrition.description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            )
          ],
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
                      return AdminBasicNutritionFormPage(isUpdating: true);
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
