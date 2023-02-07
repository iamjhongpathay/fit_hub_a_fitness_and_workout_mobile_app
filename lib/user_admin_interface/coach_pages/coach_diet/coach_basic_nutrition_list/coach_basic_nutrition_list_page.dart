import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_basic_nutrition_list/user_basic_nutrition_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBasicNutritionListPage extends StatefulWidget {
  @override
  _UserBasicNutritionListPageState createState() => _UserBasicNutritionListPageState();
}

class _UserBasicNutritionListPageState extends State<UserBasicNutritionListPage> {
  @override
  void initState() {
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context, listen: false);
    getBasicNutrition(basicNutritionNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context);

    Future<void>_refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getBasicNutrition(basicNutritionNotifier);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('BASIC NUTRITION',
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
      body: RefreshIndicator(
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
                          elevation: 1,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            child: Image.network(
                              basicNutritionNotifier.basicNutritionList[index].thumbnail != null
                                  ?basicNutritionNotifier.basicNutritionList[index].thumbnail
                                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                              fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent loadingProgress){
                                  if(loadingProgress == null) return child;
                                  return Container(
                                    height: 115,
                                    width: double.infinity,
                                    color: Colors.grey[100],
                                    child: Center(
                                      child:  CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                            : null,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    ),
                                  );
                                }
                            ),
                            onTap: () {
                              basicNutritionNotifier.currentBasicNutrition = basicNutritionNotifier.basicNutritionList[index];
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (BuildContext context){
                                    return UserBasicNutritionDetails();
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
                                child: Text(basicNutritionNotifier.basicNutritionList[index].title,
                                  maxLines: 3,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 3),
                              SizedBox(
                                width: double.infinity,
                                child: Text('by ${basicNutritionNotifier.basicNutritionList[index].coachName}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: basicNutritionNotifier.basicNutritionList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}