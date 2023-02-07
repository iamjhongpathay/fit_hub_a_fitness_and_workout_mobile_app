

import 'dart:collection';

import 'package:fit_hub_mobile_application/models/basicNutrition.dart';
import 'package:flutter/cupertino.dart';

class BasicNutritionNotifier with ChangeNotifier{
  List<BasicNutrition> _basicNutritionList = [];
  BasicNutrition _currentBasicNutrition;

  UnmodifiableListView<BasicNutrition> get basicNutritionList => UnmodifiableListView(_basicNutritionList);

  BasicNutrition get currentBasicNutrition => _currentBasicNutrition;

  set basicNutritionList(List<BasicNutrition> basicNutritionList){
    _basicNutritionList = basicNutritionList;
    notifyListeners();
  }
  set currentBasicNutrition(BasicNutrition basicNutrition){
    _currentBasicNutrition = basicNutrition;
    notifyListeners();
  }
  addBasicNutrition (BasicNutrition basicNutrition){
    _basicNutritionList.insert(0, basicNutrition);
    notifyListeners();
  }
  deleteBasicNutrition(BasicNutrition basicNutrition){
    _basicNutritionList.removeWhere((_basicNutrition) => _basicNutrition.id == basicNutrition.id);
    notifyListeners();
  }

}