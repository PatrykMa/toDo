import 'package:flutter_appk/Task.dart';
import 'package:flutter_appk/src/resource/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../Place.dart';

class MoviesBloc {
  final _repository = Repository();
  final _tasksFetcher = PublishSubject<List<Task>>();
  final _placesFetcher = PublishSubject<List<Place>>();

  Observable<List<Task>> get allTask => _tasksFetcher.stream;
  Observable<List<Place>> get allPlaces => _placesFetcher.stream;

  fetchAllTasks() async {
    List<Task> tasks = await _repository.fetchAllTask();
    _tasksFetcher.sink.add(tasks);

    List<Place> places = await _repository.fetchAllPlace();
    _placesFetcher.sink.add(places);
  }

  fetchAllPlaces() async {
    List<Place> places = await _repository.fetchAllPlace();
    _placesFetcher.sink.add(places);
  }
  addTask(Task task){
    _repository.addTask(task);
    fetchAllTasks();
  }

  addPlace(Place place){
    _repository.addPlace(place);
    fetchAllPlaces();
  }

  updateTask(Task task){
    _repository.updateTask(task);
    fetchAllTasks();
  }

  dispose() {
    _tasksFetcher.close();
    _placesFetcher.close();
  }
}

final bloc = MoviesBloc();