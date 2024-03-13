import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  Map<String, List<dynamic>> taskGroups = {};
  final Box toDoBox = Hive.box('toDoBox');

  void initalTaskGroupData(String group) {
    taskGroups[group] = [
      ["Tutorial"],
      [
        ["Slide me to right to edit me!", false],
        ["Slide me to left to delete me!", false],
      ]
    ];
  }

  void firstLaunchInitData() {
    taskGroups["Tutorial"] = [
      ["Tutorial"],
      [
        ["Slide me to right to edit me!", false],
        ["Slide me to left to delete me!", false],
      ]
    ];
  }

  void loadTaskGroupData(String group) {
    var data = toDoBox.get(group);
    if (data != null) taskGroups[group] = data;
    //if (data == null) initalTaskGroupData(group);
  }

  void saveTaskGroupData(String group) {
    toDoBox.put(group, taskGroups[group]);
  }

  void loadAllTaskGroupData() {
    var data = toDoBox.keys;

    if (data.isEmpty) {
      firstLaunchInitData();
      return;
    }

    for (String key in data) {
      taskGroups[key] = toDoBox.get(key);
    }
  }

  void saveAllTaskGroupData() {
    Iterable<String> data = taskGroups.keys;    

    for (String key in data) {
      toDoBox.put(key, taskGroups[key]);
    }
  }

  int getTaskGroupsCount() => taskGroups.length;
  String getTaskGroupTitle(String key) => taskGroups[key]?[0][0];

  int lenghtOfGroup(String group) {
    var data = taskGroups[group]?[1];
    if (data == null) return 0;
    return data.length;
  }
}
