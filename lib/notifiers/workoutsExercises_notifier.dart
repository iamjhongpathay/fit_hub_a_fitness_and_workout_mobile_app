import 'dart:collection';
import 'package:fit_hub_mobile_application/models/workoutsExercises.dart';
import 'package:flutter/cupertino.dart';

class WorkoutsExercisesNotifier with ChangeNotifier{

  List<WorkoutsExercises> _workoutsExercisesList = [];
  WorkoutsExercises _currentWorkoutsExercises;

  UnmodifiableListView<WorkoutsExercises> get workoutsExercisesList => UnmodifiableListView(_workoutsExercisesList);

  WorkoutsExercises get currentWorkoutsExercises => _currentWorkoutsExercises;

  set workoutsExercisesList(List<WorkoutsExercises> workoutsExercisesList){
    _workoutsExercisesList = workoutsExercisesList;
    notifyListeners();
  }
  set currentWorkoutsExercises(WorkoutsExercises workoutsExercises){
    _currentWorkoutsExercises = workoutsExercises;
    notifyListeners();
  }
  addWorkoutsExercises (WorkoutsExercises workoutsExercises){
    _workoutsExercisesList.insert(0, workoutsExercises);
    notifyListeners();
  }
  deleteWorkoutsExercises(WorkoutsExercises workoutsExercises){
    _workoutsExercisesList.removeWhere((_workoutsExercises) => _workoutsExercises.id == workoutsExercises.id);
    notifyListeners();
  }
}
class AllWorkoutsExercisesNotifier with ChangeNotifier{

  List<WorkoutsExercises> _workoutsExercisesList = [];
  WorkoutsExercises _currentWorkoutsExercises;

  UnmodifiableListView<WorkoutsExercises> get workoutsExercisesList => UnmodifiableListView(_workoutsExercisesList);

  WorkoutsExercises get currentWorkoutsExercises => _currentWorkoutsExercises;

  set workoutsExercisesList(List<WorkoutsExercises> workoutsExercisesList){
    _workoutsExercisesList = workoutsExercisesList;
    notifyListeners();
  }
  set currentWorkoutsExercises(WorkoutsExercises workoutsExercises){
    _currentWorkoutsExercises = workoutsExercises;
    notifyListeners();
  }
  addWorkoutsExercises (WorkoutsExercises workoutsExercises){
    _workoutsExercisesList.insert(0, workoutsExercises);
    notifyListeners();
  }
  deleteWorkoutsExercises(WorkoutsExercises workoutsExercises){
    _workoutsExercisesList.removeWhere((_workoutsExercises) => _workoutsExercises.id == workoutsExercises.id);
    notifyListeners();
  }
}