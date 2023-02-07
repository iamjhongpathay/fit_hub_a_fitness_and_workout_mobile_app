import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/diet.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'admin_all_diet_details_form.dart';

class AdminAllDietDetails extends StatefulWidget {
  @override
  _AdminAllDietDetailsState createState() => _AdminAllDietDetailsState();
}

class _AdminAllDietDetailsState extends State<AdminAllDietDetails> {
  @override
  Widget build(BuildContext context) {
    AllDietDetailsNotifier allDietDetailsNotifier = Provider.of<AllDietDetailsNotifier>(context);

    _onDietDetailsDeleted(DietDetails dietDetails) {
      Navigator.pop(context);
      allDietDetailsNotifier.deleteDietDetails(dietDetails);
      flushBar(context);
    }
    void _deleteDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
            content: Text(
                'Do you really want to delete these records? This process cannot be undone.'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(

                child: Text('DELETE',
                    style: TextStyle(fontSize: 18.0,
                        color: Colors.red
                    )
                ),
                onPressed: () {
                  deleteDietDetails(allDietDetailsNotifier.currentDietDetails, _onDietDetailsDeleted);
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
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl: allDietDetailsNotifier.currentDietDetails.thumbnailUrl != null
                        ?allDietDetailsNotifier.currentDietDetails.thumbnailUrl
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
              //         allDietDetailsNotifier.currentDietDetails.videoUrl != null
              //             ?allDietDetailsNotifier.currentDietDetails.videoUrl
              //             :'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/error.mp4'
              //     ),
              //   ),
              // ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${allDietDetailsNotifier.currentDietDetails.category.toUpperCase()}',
                      style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w900, fontSize: 12, fontFamily: 'Nexa',),
                    ),
                    SizedBox(height: 5.0),
                    Text('${allDietDetailsNotifier.currentDietDetails.title.toUpperCase()}',
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
                              Text('${allDietDetailsNotifier.currentDietDetails.kcal.toUpperCase()} CAL',
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
                              Text('${allDietDetailsNotifier.currentDietDetails.levelToDo.toUpperCase()}',
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
                      child: Text(allDietDetailsNotifier.currentDietDetails.description,
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
                      children: allDietDetailsNotifier.currentDietDetails.nutritionList
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
                              itemCount: allDietDetailsNotifier.currentDietDetails.ingredients.length,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                  child: Text(allDietDetailsNotifier.currentDietDetails.ingredients[index].toString(),
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
                              itemCount: allDietDetailsNotifier.currentDietDetails.stepByStep.length,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                  child: Text(allDietDetailsNotifier.currentDietDetails.stepByStep[index].toString(),
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
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'button1',
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (BuildContext context){
                      return AdminAllDietDetailsForm(isUpdating: true);
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
  void flushBar(BuildContext context) {
    Flushbar(
      message: 'Data Successfully Deleted.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )
      ..show(context);
  }
}
