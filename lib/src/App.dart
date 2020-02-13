

import 'package:flutter/material.dart';
import 'package:flutter_appk/src/ui/task_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: TaskList(),
      ),
    );
  }
}