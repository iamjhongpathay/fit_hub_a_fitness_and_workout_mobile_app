import 'dart:io';

import 'package:fit_hub_mobile_application/api/pdf_api.dart';
import 'package:fit_hub_mobile_application/screens/launcher/pdf_viewer_page.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/lobby.dart';
import 'package:fit_hub_mobile_application/screens/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomeLauncherPage extends StatefulWidget {
  const HomeLauncherPage({Key key}) : super(key: key);

  @override
  _HomeLauncherPageState createState() => _HomeLauncherPageState();
}

class _HomeLauncherPageState extends State<HomeLauncherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('HOME',
         style: TextStyle( color: Colors.black,
         fontWeight: FontWeight.w900,
         fontSize: 25.0,)
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
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
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/fithub_logo_blk.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Text("Andoid App: Fitness Workout and Exercise Application Development for Fit hub Fitness Center",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                      ),
                ),
                SizedBox(height: 15
                ),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    ),
                    color: Colors.black,
                    splashColor: Colors.grey,
                    child: Text(
                      'MANUSCRIPT',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: () async{
                      final path = 'assets/manuscript.pdf';
                      final file = await PDFApi.loadAsset(path);
                      openPDF(context, file);
                    },
                  ),
                ),
                SizedBox(height: 10),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    ),
                    color: Colors.black,
                    splashColor: Colors.grey,
                    child: Text(
                      'POWERPOINT',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: () async{
                      final path = 'assets/fithub-presentation.pdf';
                      final file = await PDFApi.loadAsset(path);
                      openPDF(context, file);
                    },
                  ),
                ),
                SizedBox(height: 10),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    ),
                    color: Colors.black,
                    splashColor: Colors.grey,
                    child: Text(
                      "USER'S MANUAL",
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: () async{
                      final path = 'assets/users-manual.pdf';
                      final file = await PDFApi.loadAsset(path);
                      openPDF(context, file);
                    },
                  ),
                ),

                SizedBox(height: 10),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    ),
                    color: Colors.black,
                    splashColor: Colors.grey,
                    child: Text(
                      'SYSTEM',
                      style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: () async{
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context){
                            return Wrapper();
                          })
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
}
