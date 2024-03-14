import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  Map<String, List<dynamic>> taskGroups = {};
  final Box toDoBox = Hive.box('toDoBox');

  List<int> extractColorDataRGB(Color color) => [color.red, color.green, color.blue];

  void firstLaunchInitData() {
    taskGroups["Tutorial"] = [
      ["Tutorial", [255, 0, 255, 255], [100, 0, 255, 255]],
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

  Color getTaskGroupMarkerColor(String key) {
    List<int> argb = taskGroups[key]?[0][1];
    return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
  }

  Color getTaskGroupMarkerShadeColor(String key) {
    List<int> argb = taskGroups[key]?[0][2];
    return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
  }

  String getTaskText(String group, int index) {
    return taskGroups[group]?[1][index][0];
  }

  void setTaskData(String group, int index, String? taskText, bool? taskCheckmarkValue) {
    if (taskText != null) taskGroups[group]?[1][index][0] = taskText;
    if (taskCheckmarkValue != null) taskGroups[group]?[1][index][1] = taskCheckmarkValue;
  }

  void setTaskCheckmarkValue(String group, int index, bool? value) {
    if (value == null) {
      taskGroups[group]?[1][index][1] = !taskGroups[group]?[1][index][1];
      return;
    }
    taskGroups[group]?[1][index][1] = value;
  }

  void createNewTaskGroup(String newGroupTitle, Color taskGroupColor) {
    List<int> groupColor = extractColorDataRGB(taskGroupColor);

    taskGroups[newGroupTitle] = [
      [newGroupTitle, [255, ...groupColor], [100, ...groupColor]],
      []
    ];
  }

  void removeTask(String group, int index) {
    taskGroups[group]?[1].removeAt(index);
  }
  
  void removeTaskGroup(String group) {
    taskGroups.remove(group);
    toDoBox.delete(group);
  }

  void createNewTask(String group, String taskText) {
    taskGroups[group]?[1].add([taskText, false]);
  }

  int lenghtOfGroup(String group) {
    var data = taskGroups[group]?[1];
    if (data == null) return 0;
    return data.length;
  }
}
