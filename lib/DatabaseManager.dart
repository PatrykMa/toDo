
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_appk/Cyclic.dart';
import 'package:flutter_appk/Place.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'Task.dart';

class DatabaseManager{

  String _databaseName = "to_do";
  String _taskTableName = "tasks";
  String _placesTableName = "places";

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "to_do.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $_taskTableName("
            "id INTEGER PRIMARY KEY,"
            " placeId INTEGER,"
            " name TEXT, "
            "date INTEGER DEFAULT, "
            "cyc INTEGER )");
    await db.execute(
        "CREATE TABLE $_placesTableName("
            "id INTEGER PRIMARY KEY,"
            " name TEXT )");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $_taskTableName');
    List<Task> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(
          new Task(int.parse(list[i]["id"]),
              int.parse(list[i]["placeId"]),
              list[i]["name"],
              int.parse(list[i]["date"]),
              Cyclic.values[int.parse(list[i]["cyc"])]));
    }
    print(employees.length);
    return employees;
  }

  void saveTask(Task task) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $_taskTableName(placeId, name, date, cyc ) VALUES(' +
              '\'' +
              task.placeId.toString() +
              '\'' +
              ',' +
              '\'' +
              task.name +
              '\'' +
              ',' +
              '\'' +
              task.date.toString() +
              '\'' +
              ',' +
              '\'' +
              task.cyc.toString() +
              '\'' +
              ')');
    });
  }

  Future<List<Place>> getPlaces() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $_placesTableName');
    List<Place> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(
          new Place(int.parse(list[i]["id"]),
              list[i]["name"]));
    }
    print(employees.length);
    return employees;
  }


  void savePlace(Place place) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $_placesTableName(name) VALUES(' +
              '\'' +
              place.name+
              '\'' +
              ')');
    });
  }



}