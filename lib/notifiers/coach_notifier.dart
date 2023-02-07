
import 'dart:collection';

import 'package:fit_hub_mobile_application/models/coach.dart';
import 'package:flutter/cupertino.dart';

class CoachNotifier with ChangeNotifier{
  List<Coach>_coachList = [];
  Coach _currentCoach;

  UnmodifiableListView<Coach> get coachList => UnmodifiableListView(_coachList);

  Coach get currentCoach => _currentCoach;

  set coachList(List<Coach> coachList){
    _coachList = coachList;
    notifyListeners();
  }
  set currentCoach(Coach coach){
    _currentCoach = coach;
    notifyListeners();
  }
  addCoach (Coach coach){
    _coachList.insert(0, coach);
    notifyListeners();
  }
  deleteCoach(Coach coach){
    _coachList.removeWhere((_coach) => _coach.id == coach.id);
    notifyListeners();
  }
}