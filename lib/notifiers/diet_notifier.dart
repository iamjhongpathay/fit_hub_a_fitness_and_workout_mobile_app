

import 'dart:collection';

import 'package:fit_hub_mobile_application/models/diet.dart';
import 'package:flutter/cupertino.dart';

class DietDetailsNotifier with ChangeNotifier{

  List<DietDetails> _dietDetailsList = [];
  DietDetails _currentDietDetails;

  UnmodifiableListView<DietDetails> get dietDetailsList => UnmodifiableListView(_dietDetailsList);

  DietDetails get currentDietDetails => _currentDietDetails;

  set dietDetailsList(List<DietDetails> dietDetailsList){
    _dietDetailsList = dietDetailsList;
    notifyListeners();
  }
  set currentDietDetails(DietDetails dietDetails){
    _currentDietDetails = dietDetails;
    notifyListeners();
  }
  addDietDetails (DietDetails dietDetails){
    _dietDetailsList.insert(0, dietDetails);
    notifyListeners();
  }
  deleteDietDetails(DietDetails dietDetails){
    _dietDetailsList.removeWhere((_dietDetails) => _dietDetails.id == dietDetails.id);
    notifyListeners();
  }

}
class AllDietDetailsNotifier with ChangeNotifier {

  List<DietDetails> _dietDetailsList = [];
  DietDetails _currentDietDetails;

  UnmodifiableListView<DietDetails> get dietDetailsList =>
      UnmodifiableListView(_dietDetailsList);

  DietDetails get currentDietDetails => _currentDietDetails;

  set dietDetailsList(List<DietDetails> dietDetailsList) {
    _dietDetailsList = dietDetailsList;
    notifyListeners();
  }

  set currentDietDetails(DietDetails dietDetails) {
    _currentDietDetails = dietDetails;
    notifyListeners();
  }
  addDietDetails (DietDetails dietDetails){
    _dietDetailsList.insert(0, dietDetails);
    notifyListeners();
  }
  deleteDietDetails(DietDetails dietDetails){
    _dietDetailsList.removeWhere((_dietDetails) => _dietDetails.id == dietDetails.id);
    notifyListeners();
  }
}