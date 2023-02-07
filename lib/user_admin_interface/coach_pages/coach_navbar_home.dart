


import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_account/coach_account_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_diet/coach_diet_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_home/coach_home_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_latest_updates/coach_latest_updates_page.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_my_members/coach_my_members_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CoachNavBarHome extends StatefulWidget {
  CoachNavBarHome ({Key key}) : super(key: key);
  @override
  _CoachNavBarHomeState createState() => _CoachNavBarHomeState();
}

class _CoachNavBarHomeState extends State<CoachNavBarHome> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _screen = [
    CoachHomePage(),
    CoachDietPage(),
    CoachLatestUpdatesPage(),
    CoachMyMembersPage(),
    CoachAccountPage(),
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
        icon: Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(Icons.set_meal_sharp, size: 23.0),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(right: 3.0),
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
        icon: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(Icons.people_rounded, size: 22.0),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(Icons.people_outline, size: 22.0),
        ),
        title: ('       Members'.toUpperCase()),
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
        padding: NavBarPadding.symmetric(vertical: 7, horizontal: 0),
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
