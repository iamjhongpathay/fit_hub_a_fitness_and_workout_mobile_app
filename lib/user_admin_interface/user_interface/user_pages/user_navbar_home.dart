
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_diet/user_diet_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_home/user_home_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_latest_updates/user_latest_updates_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'user_account/user_account_page.dart';
import 'user_workout_plan/user_workout_plan_page.dart';


class UserNavBarHome extends StatefulWidget {
  UserNavBarHome ({Key key}) : super(key: key);
  @override
  _UserNavBarHomeState createState() => _UserNavBarHomeState();
}

class _UserNavBarHomeState extends State<UserNavBarHome> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _screen = [
    UserHomePage(), UserWorkoutPlanPage(), UserDietPage(), UserLatestUpdatesPage(), UserAccountPage(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems(){
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.house_fill, size: 22.0),
        inactiveIcon: Icon(CupertinoIcons.home, size: 22.0),
        title: ('Home'.toUpperCase()),
        textStyle: TextStyle(fontSize: 9, fontFamily: 'Nexa', fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.local_activity, size: 22.0),
        inactiveIcon: Icon(Icons.local_activity_outlined, size: 22.0),
        title: ('Activity'.toUpperCase()),
        textStyle: TextStyle(fontSize: 9, fontFamily: 'Nexa', fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(Icons.set_meal_sharp, size: 23.0),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(Icons.set_meal_outlined, size: 22.0),
        ),
        title: ('Diet'.toUpperCase()),
        textStyle: TextStyle(fontSize: 9, fontFamily: 'Nexa', fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.announcement_rounded, size: 22.0),
        inactiveIcon: Icon(Icons.announcement_outlined, size: 22.0),
        title: ('Latest Updates'.toUpperCase()),
        textStyle: TextStyle(fontSize: 9, fontFamily: 'Nexa', fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: Colors.grey[700],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_circle_fill, size: 22.0),
        inactiveIcon: Icon(CupertinoIcons.person_circle, size: 22.0),
        title: ('Account'.toUpperCase()),
        textStyle: TextStyle(fontSize: 9, fontFamily: 'Nexa', fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: Colors.grey[700],
      ),
    ];
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        padding: NavBarPadding.symmetric(vertical: 7, horizontal: 4),
        navBarHeight: 50,
        controller: _controller,
        screens: _screen,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black12, blurRadius: 1),
            ]
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        navBarStyle: NavBarStyle.style8,
      ),
    );
  }
}
