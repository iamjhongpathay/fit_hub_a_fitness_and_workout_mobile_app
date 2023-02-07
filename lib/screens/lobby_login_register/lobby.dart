import 'package:chewie/chewie.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/email_verification.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/assestment_pages/first_question.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/login.dart';
import 'package:fit_hub_mobile_application/screens/lobby_login_register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  // final VideoPlayerController _videoPlayerController = VideoPlayerController.asset('assets/fithub.mp4');
  // ChewieController _chewieController;

  // @override
  // void initState() {
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     aspectRatio: .56,
  //     autoPlay: true,
  //     looping: true,
  //     autoInitialize: true,
  //     showControls: false,
  //   );
  //   super.initState();
  // }

  // @override
  // void dispose(){
  //   _videoPlayerController.dispose();
  //   _chewieController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/lobby_bg.jpg'),
              fit: BoxFit.cover
            )
          ),
          // Center(
          //    child: SizedBox.expand(
          //      child: FittedBox(
          //        fit: BoxFit.cover,
          //        child: SizedBox(
          //           width: MediaQuery.of(context).size.width,
          //           height: 300,
          //           child: Chewie(
          //             controller: _chewieController,
          //           ),
          //         ),
          //      ),
          //    ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top:  150.0),
                  child: Image.asset('assets/fithub_logo_blk.png', scale: 3.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              ButtonTheme(
                minWidth: 300.0,
                height: 50.0,
                child: RaisedButton(
                  elevation: 0.0,
                  color: Colors.black,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    // side: BorderSide(color: Colors.white)
                  ),
                  child: Text(
                    'START NOW',
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                      fontFamily: 'Nexa',
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,MaterialPageRoute(builder: (context) => EmailVerificationPage()),
                    );
                  },
                ),
              ),
              SizedBox(height: 15.0),
              ButtonTheme(
                minWidth: 300.0,
                height: 50.0,
                child: RaisedButton(
                  elevation: 1.0,
                  color: Colors.blue,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    // side: BorderSide(color: Colors.white)
                  ),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                      fontFamily: 'Nexa',
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => LogInScreen()),
                    );
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}