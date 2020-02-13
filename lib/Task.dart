


import 'Cyclic.dart';

class Task{
  int id;
  int placeId;
  String name;
  int date;
  Cyclic cyc;
  bool done;
  Task(int id, int placeId, String name, int date, Cyclic cyc, bool done){
    this.id =id;
    this.placeId = placeId;
    this.name =name;
    this.date = date;
    this.cyc = cyc;
    this.done = done;
  }
}