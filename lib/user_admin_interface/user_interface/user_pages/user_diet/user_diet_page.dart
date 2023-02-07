import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_all_diet_details.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_basic_nutrition_list/user_basic_nutrition_list_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_fruits_veggies_list/user_fruits_veggies_list_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_grains_cereals_list/user_grains_cereals_list_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_meats_proteins_list/user_meats_proteins_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';


class UserDietPage extends StatefulWidget {
  UserDietPage ({Key key}) : super(key: key);
  @override
  _UserDietPageState createState() => _UserDietPageState();
}

class _UserDietPageState extends State<UserDietPage> {
  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
  TextStyle linkStyle = TextStyle(color: Colors.black, fontSize: 13.0);

  @override
  void initState() {
    AllDietDetailsNotifier allDietDetailsNotifier = Provider.of<AllDietDetailsNotifier>(context, listen: false);
    getAllDietDetails(allDietDetailsNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AllDietDetailsNotifier allDietDetailsNotifier = Provider.of<AllDietDetailsNotifier>(context);
    Future<void> _refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getAllDietDetails(allDietDetailsNotifier);
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('DIET',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
            ),
          ),
          centerTitle: true
      ),
      backgroundColor: Colors.white,
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
                      [Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                          //   child: InkWell(
                          //     child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: Image.asset('assets/basic_nutrition_banner.jpg',
                          //         )),
                          //     // onTap: () {
                          //     //   Navigator.of(context).push(
                          //     //       CupertinoPageRoute(builder: (BuildContext context){
                          //     //         return UserBasicNutritionListPage();
                          //     //       })
                          //     //   );
                          //     // },
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text('HEALTHY FOOD RECIPES',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Nexa', letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Card(
                                    semanticContainer: true,
                                    elevation: 0,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          child: Image.asset('assets/meats_proteins_banner.jpg'),
                                          onTap: () {
                                            Navigator.push(context,
                                                CupertinoPageRoute(builder: (context){
                                                  return UserMeatsProteinsListPage();
                                                })
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Card(
                                    semanticContainer: true,
                                    elevation: 0,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          child: Image.asset('assets/grains_cereals_banner.jpg'),
                                          onTap: () {
                                            Navigator.push(context,
                                                CupertinoPageRoute(builder: (context){
                                                  return UserGrainsCerealsListPage();
                                                })
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Card(
                                    semanticContainer: true,
                                    elevation: 0,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          child: Image.asset('assets/fruits_veggies_banner.jpg'),
                                          onTap: () {
                                            Navigator.push(context,
                                                CupertinoPageRoute(builder: (context){
                                                  return UserFruitVeggiesListPage();
                                                })
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ]
                  )
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
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
                                imageUrl: allDietDetailsNotifier.dietDetailsList[index].thumbnailUrl != null
                                    ?allDietDetailsNotifier.dietDetailsList[index].thumbnailUrl
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
                                allDietDetailsNotifier.currentDietDetails = allDietDetailsNotifier.dietDetailsList[index];
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return UserAllDietDetails();
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
                                  child: Text(allDietDetailsNotifier.dietDetailsList[index].title,
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 3),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('${allDietDetailsNotifier.dietDetailsList[index].kcal} Cal | ${allDietDetailsNotifier.dietDetailsList[index].levelToDo}',
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
                    childCount: allDietDetailsNotifier.dietDetailsList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
   );
  }
}
