import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

class UserHomeBannerPage extends StatefulWidget {
  @override
  _UserHomeBannerPageState createState() => _UserHomeBannerPageState();
}

class _UserHomeBannerPageState extends State<UserHomeBannerPage> {
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
                    imageUrl: homeBannerNotifier.currentHomeBanner.thumbnailUrl,
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
    );
  }
}
