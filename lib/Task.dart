


import 'Cyclic.dart';

class Task{
  int id;
  int placeId;
  String name;
  int date;
  Cyclic cyc;

  Task(int id, int placeId, String name, int date, Cyclic cyc){
    this.id =id;
    this.placeId = placeId;
    this.name =name;
    this.date = date;
    this.cyc = cyc;
  }
}