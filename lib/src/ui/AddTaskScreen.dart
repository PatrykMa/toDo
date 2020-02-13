

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appk/Cyclic.dart';
import 'package:flutter_appk/Place.dart';
import 'package:flutter_appk/src/blocs/task_add_bloc.dart';
import 'package:flutter_appk/src/blocs/task_list_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../Task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  createState() => new AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {

  TextFormField nameField;
  AutoCompleteTextField placeAutocomplete;

  final nameController = TextEditingController();
  final suggestionsController = BehaviorSubject<List<String>>();
  GlobalKey<AutoCompleteTextFieldState<Place>> key = new GlobalKey();
  List<Place> places = [Place(0,"jeden"),Place(0,"sklep")];
  doSomethting(List<Place> d){
   // places = d;
  }
  @override
  Widget build(BuildContext context) {

    bloc.allPlaces.listen(doSomethting);

    placeAutocomplete = AutoCompleteTextField<Place>(
      suggestions: places,
      key: key,
      clearOnSubmit: false,
      style: TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
          hintText: "miejsce",

        ),
      itemFilter: (item, query) {
        return item.name
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.name.compareTo(b.name);
      },
      itemSubmitted: (item) {
        setState(() {
          placeAutocomplete.textField.controller.text = item.name;
        });
      },
      itemBuilder: (context, item) {
        // ui for the autocompelete row
        return row(item);
      },
    );


    nameField = TextFormField(
      validator: (String value) {
        return value.isEmpty ? 'Należy wypełnić' : null;
      },
      controller: nameController,
      decoration: InputDecoration(
          labelText: 'Nazwa zadania'
      ),
    ) ;
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Todo List')
      ),
      body: Column(children: <Widget>[
        nameField,
        placeAutocomplete,
        FlatButton.icon(onPressed: null, icon: Icon(Icons.add), label: new Text("godzina")),
      ],),
      floatingActionButton: new FloatingActionButton(
          onPressed: addTask , // pressing this button now opens the new screen
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
    suggestionsController.close();
  }

  addTask(){
    String name = nameController.text;
    Task task = Task(null,null,name,0,Cyclic.None,false);
    bloc.addTask(task);
    Navigator.of(context).pop();
  }


  Widget row(Place place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          place.name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),

      ],
    );
  }
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

}