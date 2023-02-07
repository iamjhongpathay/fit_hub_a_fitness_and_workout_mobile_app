import 'package:fit_hub_mobile_application/models/basicNutrition.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UserBasicNutritionDetails extends StatefulWidget {
  @override
  _UserBasicNutritionDetailsState createState() => _UserBasicNutritionDetailsState();
}

class _UserBasicNutritionDetailsState extends State<UserBasicNutritionDetails> {
  @override
  Widget build(BuildContext context) {
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context);

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
    );
  }
}
