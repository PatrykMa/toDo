
import 'package:flutter_appk/src/resource/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../Task.dart';

class AddTaskBloc {
  final _repository = Repository();


  addTask(Task task){
    _repository.addTask(task);
  }
}

final addTaskBloc = AddTaskBloc();