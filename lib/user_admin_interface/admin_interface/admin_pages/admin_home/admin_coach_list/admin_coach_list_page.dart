import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_home/admin_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_home/admin_coach_list/admin_coach_details.dart';

import 'admin_coach_form.dart';

class AdminCoachListPage extends StatefulWidget {
  @override
  _AdminCoachListPageState createState() => _AdminCoachListPageState();
}

class _AdminCoachListPageState extends State<AdminCoachListPage> {

  @override
  void initState(){
    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context, listen: false);
    getCoach(coachNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context);

    Future<void>_refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getCoach(coachNotifier);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'FIT HUB TEAM',
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
          onPressed: () => Navigator.of(context).pop(AdminHomePage()),
        ),
      ),
      body:  OfflineBuilder(
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
        child: new RefreshIndicator(
          onRefresh: _refreshList,
          color: Colors.black,
          strokeWidth: 3,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
            itemCount: coachNotifier.coachList.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: <Widget>[
                  Expanded(child: Card(
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
                  SizedBox(height: 5),
                  Text(coachNotifier.coachList[index].coachName,
                    style: TextStyle(
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.person_add_solid, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
        onPressed: () {
          coachNotifier.currentCoach = null;
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (BuildContext context){
                return AdminCoachForm(isUpdating: false);
              })
          );
        },
      ),
    );
  }
}
