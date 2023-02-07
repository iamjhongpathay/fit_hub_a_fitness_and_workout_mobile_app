import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_home/admin_home_banner_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class AdminHomeBannerPage extends StatefulWidget {
  @override
  _AdminHomeBannerPageState createState() => _AdminHomeBannerPageState();
}

class _AdminHomeBannerPageState extends State<AdminHomeBannerPage> {
  @override
  Widget build(BuildContext context) {
    HomeBannerNotifier homeBannerNotifier = Provider.of<HomeBannerNotifier>(context);
    getHomeBanner(homeBannerNotifier);


    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: CachedNetworkImage(
                  imageUrl: homeBannerNotifier.currentHomeBanner.thumbnailUrl!= null
                  ?homeBannerNotifier.currentHomeBanner.thumbnailUrl
              :'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
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
                    // loadingBuilder: (BuildContext context, Widget child,
                    //     ImageChunkEvent loadingProgress){
                    //   if(loadingProgress == null) return child;
                    //   return Container(
                    //     height: 200,
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

              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(homeBannerNotifier.currentHomeBanner.title,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, fontFamily: 'Nexa',),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15,  5,  15,  15),
                child: Text(homeBannerNotifier.currentHomeBanner.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'button1',
        onPressed: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (BuildContext context){
                return AdminHomeBannerForm(isUpdating: true);
              })
          );
        },

        child: const Icon(Icons.edit_outlined, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
    );
  }
}
