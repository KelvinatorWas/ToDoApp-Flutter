import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  // data list of tasks
  List toDoTasks = [];
  final Box toDoBox = Hive.box('toDoBox');

  void initalData() {
    toDoTasks = [
      ["Slide me to right to edit me!", false],
      ["Slide me to left to delete me!", false],
    ];
  }

  void loadData () => toDoTasks = toDoBox.get("tasks"); // load in data
  void saveData () => toDoBox.put("tasks", toDoTasks);  // save data

}
