import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

import '../user_workout_exercises_details.dart';

class UserBoxingMuaythaiListPage extends StatefulWidget {
  @override
  _UserBoxingMuaythaiListPageState createState() => _UserBoxingMuaythaiListPageState();
}

class _UserBoxingMuaythaiListPageState extends State<UserBoxingMuaythaiListPage> {
  @override
  void initState(){
    WorkoutsExercisesNotifier workoutsExercisesNotifier = Provider.of<WorkoutsExercisesNotifier>(context, listen: false);
    getBoxingMuayThai(workoutsExercisesNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WorkoutsExercisesNotifier workoutsExercisesNotifier = Provider.of<WorkoutsExercisesNotifier>(context);

    Future<void>_refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getBoxingMuayThai(workoutsExercisesNotifier);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'BOXING & MUAY THAI',
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
          onPressed: () => Navigator.pop(context),
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
        child: RefreshIndicator(
          onRefresh: _refreshList,
          color: Colors.black,
          strokeWidth: 3,
            child: CustomScrollView(
              slivers: <Widget>[
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
                              elevation: 0,
                              color: Colors.grey[100],
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: InkWell(
                                child: CachedNetworkImage(
                                  imageUrl: workoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl != null
                                      ?workoutsExercisesNotifier.workoutsExercisesList[index].thumbnailUrl
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
                                    // loadingBuilder: (BuildContext context, Widget child,
                                    //     ImageChunkEvent loadingProgress){
                                    //   if(loadingProgress == null) return child;
                                    //   return Container(
                                    //     height: 100,
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
                                  workoutsExercisesNotifier.currentWorkoutsExercises = workoutsExercisesNotifier.workoutsExercisesList[index];
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (BuildContext context){
                                        return UserWorkoutsExercisesDetails();
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
                                    child: Text(workoutsExercisesNotifier.workoutsExercisesList[index].title,
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
                                          child: Text('${workoutsExercisesNotifier.workoutsExercisesList[index].competencyLevel} |',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text('by ${workoutsExercisesNotifier.workoutsExercisesList[index].coachName}',
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
                      childCount: workoutsExercisesNotifier.workoutsExercisesList.length,
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
