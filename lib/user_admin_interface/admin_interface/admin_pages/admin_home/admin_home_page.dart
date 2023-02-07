import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:fit_hub_mobile_application/shared/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'admin_coach_list/admin_coach_details.dart';
import 'admin_coach_list/admin_coach_list_page.dart';
import 'admin_coach_videos/admin_all_workout_exercises_details.dart';
import 'admin_coach_videos/admin_all_workouts_exercises_form.dart';
import 'admin_coach_videos/admin_boxing_muaythai_list/admin_boxing_muaythai_list_page.dart';
import 'admin_coach_videos/admin_circuit_list/admin_circuit_list_page.dart';
import 'admin_coach_videos/admin_crossfit_list/admin_crossfit_list_page.dart';
import 'admin_home_banner_page.dart';


class AdminHomePage extends StatefulWidget {
  AdminHomePage ({Key key}) : super(key: key);
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
  TextStyle linkStyle = TextStyle(color: Colors.black, fontSize: 13.0);
  StreamSubscription subscription;


  @override
  void initState(){

    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context, listen: false);
    getCoach(coachNotifier);
    HomeBannerNotifier homeBannerNotifier = Provider.of<HomeBannerNotifier>(context, listen: false);
    getHomeBanner(homeBannerNotifier);
    AllWorkoutsExercisesNotifier allWorkoutsExercisesNotifier = Provider.of<AllWorkoutsExercisesNotifier>(context, listen: false);
    getAllWorkoutsExercises(allWorkoutsExercisesNotifier);
    // subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    super.initState();
  }

  // @override
  // void dispose() {
  //   subscription.cancel();
  //   super.dispose();
  // }

  // void showConnectivitySnackBar(ConnectivityResult result) {
  //   final hasInternet = result != ConnectivityResult.none;
  //   final message = hasInternet
  //       ? 'You have again ${result.toString()}'
  //       : 'No internet connection';
  //   final color = hasInternet ? Colors.green : Colors.red;
  //
  //   flushBar(context, message);
  // }
  //
  // void flushBar(BuildContext context, String message){
  //   Flushbar(
  //     message: message,
  //       icon: Icon(
  //         Icons.wifi_off,
  //         size: 28.0,
  //         color: Colors.blue[300],
  //       ),
  //     duration: Duration(seconds: 2),
  //     flushbarStyle: FlushbarStyle.GROUNDED
  //   )..show(context);
  // }

  @override
  Widget build(BuildContext context) {


    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context);
    HomeBannerNotifier homeBannerNotifier = Provider.of<HomeBannerNotifier>(context);
    AllWorkoutsExercisesNotifier allWorkoutsExercisesNotifier = Provider.of<AllWorkoutsExercisesNotifier>(context);
    

    Future<void> _refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getCoach(coachNotifier);
      getHomeBanner(homeBannerNotifier);
      getAllWorkoutsExercises(allWorkoutsExercisesNotifier);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Image.asset('assets/fithub_word.png', fit: BoxFit.cover, scale: 2.5),
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
        child: RefreshIndicator(
        onRefresh: _refreshList,
        color: Colors.black,
        strokeWidth: 3,
        child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                    [ Column(
                      children: <Widget>[
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              // scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeBannerNotifier.homeBannerList.length,
                              itemBuilder: (BuildContext context, int index){
                                return Column(
                                  children: [
                                    InkWell(
                                      child: CachedNetworkImage(
                                        imageUrl: homeBannerNotifier.homeBannerList[index].thumbnailUrl != null
                                            ?homeBannerNotifier.homeBannerList[index].thumbnailUrl
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
                                      onTap: () {
                                        homeBannerNotifier.currentHomeBanner = homeBannerNotifier.homeBannerList[index];
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(builder: (BuildContext context){
                                              return AdminHomeBannerPage();
                                            })
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'FIT HUB TEAM',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Nexa', letterSpacing: 1),
                                      ),
                                      TextSpan(
                                          style: linkStyle.copyWith( fontWeight: FontWeight.w400),
                                          text: '                                                                                See all',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(builder: (BuildContext context){
                                                    return AdminCoachListPage();
                                                  })
                                              );
                                            }
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: coachNotifier.coachList.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          width: 130,
                                          child: SizedBox(
                                            height: 120,
                                            child: Card(
                                              semanticContainer: true,
                                              elevation: 0,
                                              color: Colors.grey[100],
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: InkWell(
                                                child: CachedNetworkImage(
                                                  imageUrl: coachNotifier.coachList[index].image != null
                                                      ?coachNotifier.coachList[index].image
                                                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                                  fit: BoxFit.cover,
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
                                                  // loadingBuilder: (BuildContext context, Widget child,
                                                  // ImageChunkEvent loadingProgress){
                                                  //   if(loadingProgress == null) return child;
                                                  //   return Container(
                                                  //     height: double.infinity,
                                                  //     width: double.infinity,
                                                  //     color: Colors.grey[100],
                                                  //     child: Center(
                                                  //       child:  CircularProgressIndicator(
                                                  //         value: loadingProgress.expectedTotalBytes != null
                                                  //             ? loadingProgress.cumulativeBytesLoaded /
                                                  //             loadingProgress.expectedTotalBytes
                                                  //             : null,
                                                  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                                  //       ),
                                                  //     ),
                                                  //   );
                                                  // }
                                                ),
                                                onTap: () {
                                                  coachNotifier.currentCoach = coachNotifier.coachList[index];
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (BuildContext context){
                                                        return AdminCoachDetails();
                                                      })
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(coachNotifier.coachList[index].coachName,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                // padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset('assets/circuit_banner.jpg',
                                      )),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(builder: (BuildContext context){
                                          return AdminCircuitListPage();
                                        })
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                // padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset('assets/boxing_muaythai_banner.jpg',
                                      )),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(builder: (BuildContext context){
                                          return AdminBoxingMuaythaiListPage();
                                        })
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                // padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset('assets/crossfit_banner.jpg',
                                      )),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(builder: (BuildContext context){
                                          return AdminCrossFitListPage();
                                        })
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          Text("ALL VIDEOS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                        ]),
                      ],
                    ),
                    ]
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index){
                      return Column(
                        children: <Widget>[
                          Card(
                            semanticContainer: true,
                            elevation: 1,
                            color: Colors.grey[100],
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              child: CachedNetworkImage(
                                imageUrl: allWorkoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl != null
                                    ?allWorkoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl
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
                              onTap: () {
                                allWorkoutsExercisesNotifier.currentWorkoutsExercises = allWorkoutsExercisesNotifier.workoutsExercisesList[index];
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return AdminAllWorkoutsExercisesDetails();
                                    })
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(allWorkoutsExercisesNotifier.workoutsExercisesList[index].title,
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text('${allWorkoutsExercisesNotifier.workoutsExercisesList[index].competencyLevel} |',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text('by ${allWorkoutsExercisesNotifier.workoutsExercisesList[index].coachName}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: allWorkoutsExercisesNotifier.workoutsExercisesList.length,
                  ),
                ),
              ),
            ]
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.post_add, color: Colors.white),
      elevation: 0,
      backgroundColor: Colors.blue.withOpacity(0.7),
      onPressed: () async{
        // final message = await Connectivity().checkConnectivity();
        // flushBar(context, message.toString());
        allWorkoutsExercisesNotifier.currentWorkoutsExercises = null;
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context){
              return AdminAllWorkoutsExercisesForm(isUpdating: false);
            })
        );
      },
    )
      );
  }
}
