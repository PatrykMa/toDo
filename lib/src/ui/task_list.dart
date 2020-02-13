import 'package:flutter/material.dart';
import 'package:flutter_appk/Task.dart';
import 'package:flutter_appk/src/blocs/task_list_bloc.dart';
import 'package:flutter_appk/src/ui/AddTaskScreen.dart';

import '../checkbox.dart';

DateTime _today;
class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoveListState();
  }
}

class MoveListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllTasks();
    _today = DateTime.now();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zadaniowiec'),
      ),
      body: StreamBuilder(
        stream: bloc.allTask,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
        floatingActionButton: new FloatingActionButton(
        onPressed: onAdd, // pressing this button now opens the new screen
        tooltip: 'Add task',
        child: new Icon(Icons.add)
    ),
    );
  }

  Widget buildList(AsyncSnapshot<List<Task>> snapshot) {
    return /*GridView.builder(
        itemCount: snapshot.data.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Image.network(
                'https://image.tmdb.org/t/p/w185${snapshot.data
                    .results[index].poster_path}',
                fit: BoxFit.cover,
              ),
              onTap: () => openDetailPage(snapshot.data, index),
            ),
          );
        });*/
      ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
                child: ListTile(
                  leading: CircularCheckBox(
                    color: Colors.orange,
                    uncheckedColor: Colors.orange,
                    checked: snapshot.data[index].done,
                    onChange: (value) {
                      print(value);
                      snapshot.data[index].done=value;
                      bloc.updateTask(snapshot.data[index]);
                    },
                  ),
                  title: Text(
                    snapshot.data[index].name,
                    style: TextStyle(
                      decoration: snapshot.data[index].done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      color: snapshot.data[index].done
                          ? Colors.black54
                          : Colors.black87,
                    ),
                  ),
                  subtitle: Builder(
                    builder: (context) {
                      DateTime _date = new DateTime.fromMicrosecondsSinceEpoch(snapshot.data[index].date);
                      if (_date != null) {
                        Duration _due = _date.difference(_today);
                        if (_due.inDays > 0) {
                          return Text("Due in ${_due.inDays.abs()} day(s)");
                        } else if (_due.inDays == 0) {
                          if (_due.inHours < 0) {
                            return Text(
                                "Due ${_due.inHours.abs()} hours ago");
                          } else if (_due.inHours > 0) {
                            return Text(
                                "Due in ${_due.inHours.abs()} hours");
                          } else {
                            return Text("Due today");
                          }
                        } else if (_due.inDays < 0) {
                          return Text("Due ${_due.inDays.abs()} days ago");
                        } else {
                          return Text("Not sure when it's due");
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  trailing:
                  Text(snapshot.data[index].placeId.toString())
                  /*Icon(
                    FontAwesome.tag,
                    color: Color(snapshot.data[index].tag.color),
                  ),
                  onLongPress: () {
                    print("Long pressed");
                    _editTask(context, _db, snapshot.data[index]);
                  },*/
                )
            );
          }
      );
  }

  onAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddTaskScreen();
      }),
    );
  }


  /*
  openDetailPage(ItemModel data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetailBlocProvider(
          child: MovieDetail(
            title: data.results[index].title,
            posterUrl: data.results[index].backdrop_path,
            description: data.results[index].overview,
            releaseDate: data.results[index].release_date,
            voteAverage: data.results[index].vote_average.toString(),
            movieId: data.results[index].id,
          ),
        );
      }),
    );
  }*/


}