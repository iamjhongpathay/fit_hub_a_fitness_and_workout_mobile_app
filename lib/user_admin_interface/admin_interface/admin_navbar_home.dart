import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_diet/admin_diet_page.dart';
import 'admin_pages/admin_account/admin_account_page.dart';
import 'admin_pages/admin_home/admin_home_page.dart';
import 'admin_pages/admin_latest_updates/admin_latest_updates_page.dart';


class AdminNavBarHome extends StatefulWidget {
  AdminNavBarHome ({Key key}) : super(key: key);
  @override
  _AdminNavBarHomeState createState() => _AdminNavBarHomeState();
}

class _AdminNavBarHomeState extends State<AdminNavBarHome> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _screen = [
    AdminHomePage(),
    AdminDietPage(),
    AdminLatestUpdatesPage(),
    AdminAccountPage(),
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
