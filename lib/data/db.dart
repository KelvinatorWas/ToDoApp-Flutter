import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  // data list of tasks

  Map<String, List<dynamic>> taskGroups = {};
  final Box toDoBox = Hive.box('toDoBox');

  void initalTaskGroupData(String group) {
    taskGroups[group] = [
      ["Slide me to right to edit me!", false],
      ["Slide me to left to delete me!", false],
    ];
  }

  void initalTaskGroup(String group) {
    taskGroups[group] = [
      ["Slide me to right to edit me!", false],
      ["Slide me to left to delete me!", false],
    ];
  }

  void loadTaskGroupData(String group) {
    var data = toDoBox.get(group);
    if (data != null) taskGroups[group] = data;
    if (data == null) initalTaskGroupData(group);
  }

  void saveTaskGroupData (String group) {
    toDoBox.put(group, taskGroups[group]);
  } 

  void loadAllTaskData() {
    var data = toDoBox.keys;
    
    for (String key in data) {
      taskGroups[key] = toDoBox.get(key);
    }
    
    // if (data != null) taskGroups = data;
  }

  int lenghtOfGroup(String group) {
    var data = taskGroups[group];
    if (data == null) return 0;
    return data.length;    
  }
}
