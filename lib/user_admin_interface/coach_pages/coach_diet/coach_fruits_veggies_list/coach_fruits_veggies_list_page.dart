

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_diet/coach_diet_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class CoachFruitVeggiesListPage extends StatefulWidget {
  @override
  _CoachFruitVeggiesListPageState createState() => _CoachFruitVeggiesListPageState();
}

class _CoachFruitVeggiesListPageState extends State<CoachFruitVeggiesListPage> {
  @override
  void initState() {
    DietDetailsNotifier dietDetailsNotifier = Provider.of<DietDetailsNotifier>(context, listen: false);
    getFruitsVeggies(dietDetailsNotifier);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    DietDetailsNotifier dietDetailsNotifier = Provider.of<DietDetailsNotifier>(context);

    Future<void>_refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getFruitsVeggies(dietDetailsNotifier);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('FRUITS & VEGGIES',
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
        child: RefreshIndicator(
            onRefresh: _refreshList,
            color: Colors.black,
            strokeWidth: 3,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                  imageUrl: dietDetailsNotifier.dietDetailsList[index].thumbnailUrl != null
                                      ?dietDetailsNotifier.dietDetailsList[index].thumbnailUrl
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
                                  dietDetailsNotifier.currentDietDetails = dietDetailsNotifier.dietDetailsList[index];
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (BuildContext context){
                                        return CoachDietDetails();
                                      })
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 10),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(dietDetailsNotifier.dietDetailsList[index].title,
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text('${dietDetailsNotifier.dietDetailsList[index].kcal} Cal | ${dietDetailsNotifier.dietDetailsList[index].levelToDo}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: dietDetailsNotifier.dietDetailsList.length,
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