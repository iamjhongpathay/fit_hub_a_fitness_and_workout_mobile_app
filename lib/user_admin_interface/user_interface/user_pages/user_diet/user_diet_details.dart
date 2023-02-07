import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/diet.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UserDietDetails extends StatefulWidget {
  @override
  _UserDietDetailsState createState() => _UserDietDetailsState();
}

class _UserDietDetailsState extends State<UserDietDetails> {
  @override
  Widget build(BuildContext context) {
    DietDetailsNotifier dietDetailsNotifier = Provider.of<DietDetailsNotifier>(context);

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
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl: dietDetailsNotifier.currentDietDetails.thumbnailUrl != null
                        ?dietDetailsNotifier.currentDietDetails.thumbnailUrl
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
                    ),
                  ),
                ),
              ),
              // AspectRatio(
              //   aspectRatio: 16/9,
              //   child: VideoPlayerChewie(
              //     videoPlayerController: VideoPlayerController.network(
              //         dietDetailsNotifier.currentDietDetails.videoUrl != null
              //             ?dietDetailsNotifier.currentDietDetails.videoUrl
              //             :'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/error.mp4'
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${dietDetailsNotifier.currentDietDetails.title.toUpperCase()}',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0,
                        fontFamily: 'Nexa',
                      ),),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          // color: Colors.grey,
                          semanticContainer: true,
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/kcal_icon.png', height: 35, width: 35),
                              SizedBox(height: 5),
                              Text('${dietDetailsNotifier.currentDietDetails.kcal.toUpperCase()} CAL',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.0,
                                  fontFamily: 'Nexa',
                                  letterSpacing: 1.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(height: 30, child: VerticalDivider(color: Colors.grey[300], thickness: 1.0,)),
                        Card(
                          // color: Colors.grey,
                          semanticContainer: true,
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/level_gauge_icon.png', height: 35, width: 35),
                              SizedBox(height: 5),
                              Text('${dietDetailsNotifier.currentDietDetails.levelToDo.toUpperCase()}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.0,
                                  letterSpacing: 1.0,
                                  fontFamily: 'Nexa',
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 40.0, thickness: 1.0),
                    SizedBox(height: 5),
                    Text(' Description'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 15),
                    Container(
                      // padding: EdgeInsets.all(10.0),
                      child: Text(dietDetailsNotifier.currentDietDetails.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Divider(height: 40.0, thickness: 1.0),
                    SizedBox(height: 5),
                    Text(' Nutrition Per Serving'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: dietDetailsNotifier.currentDietDetails.nutritionList
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
                    Divider(height: 35.0, thickness: 1.0),
                    SizedBox(height: 5),
                    Text(' Ingredients'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      color: Colors.grey[200],
                      semanticContainer: true,
                      elevation: 0,
                      child: Column(
                          children: <Widget>[
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dietDetailsNotifier.currentDietDetails.ingredients.length,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                  child: Text(dietDetailsNotifier.currentDietDetails.ingredients[index].toString(),
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
                    SizedBox(height: 20),
                    Text(' Procedure'.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      color: Colors.grey[200],
                      semanticContainer: true,
                      elevation: 0,
                      child: Column(
                          children: <Widget>[
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dietDetailsNotifier.currentDietDetails.stepByStep.length,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                  child: Text(dietDetailsNotifier.currentDietDetails.stepByStep[index].toString(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

