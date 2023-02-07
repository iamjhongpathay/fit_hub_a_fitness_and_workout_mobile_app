import 'package:firebase_core/firebase_core.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/notifiers/announcement_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:fit_hub_mobile_application/screens/launcher/home_launcher.dart';
import 'package:fit_hub_mobile_application/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => CoachNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => BasicNutritionNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => DietDetailsNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => AllDietDetailsNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeBannerNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => AnnouncementNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => AllWorkoutsExercisesNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => WorkoutsExercisesNotifier(),
      ),
    ],
    child: MyApp(),
  )

  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000)
    ));
   return  OverlaySupport(
       child: StreamProvider<TheUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          accentColor: Colors.white,
        ),
        title: 'FIT HUB',
        home: HomeLauncherPage(),
      ),
    )
    );
  }
}