

import 'package:flutter_appk/Place.dart';
import 'package:flutter_appk/src/resource/DatabaseManager.dart';
import 'package:flutter_appk/Task.dart';

class Repository {
  final _taskDatabase = DatabaseManager();

  Future<List<Task>> fetchAllTask() => _taskDatabase.getTasks();
  Future<List<Place>> fetchAllPlace() => _taskDatabase.getPlaces();
  addTask(Task task){
    _taskDatabase.saveTask(task);
  }
  addPlace(Place place){
    _taskDatabase.savePlace(place);
  }

  updateTask(Task task){
    _taskDatabase.updateTask(task);
  }
}