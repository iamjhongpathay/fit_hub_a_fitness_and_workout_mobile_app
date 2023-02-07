import 'dart:collection';

import 'package:fit_hub_mobile_application/models/home_banner.dart';
import 'package:flutter/cupertino.dart';


class HomeBannerNotifier with ChangeNotifier{
  List<HomeBanner> _homeBannerList = [];
  HomeBanner _currentHomeBanner;

  UnmodifiableListView<HomeBanner> get homeBannerList => UnmodifiableListView(_homeBannerList);

  HomeBanner get currentHomeBanner => _currentHomeBanner;

  set homeBannerList(List<HomeBanner> homeBannerList){
    _homeBannerList = homeBannerList;
    notifyListeners();
  }
  set currentHomeBanner(HomeBanner homeBanner){
    _currentHomeBanner = homeBanner;
    notifyListeners();
  }
  addHomeBanner(HomeBanner homeBanner){
    _homeBannerList.insert(0, homeBanner);
    notifyListeners();
  }
}