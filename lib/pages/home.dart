import 'package:ToDo/data/db.dart';
import 'package:ToDo/util/task_group.dart';
import 'package:ToDo/util/task_group_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDoDataBase db = ToDoDataBase();
  bool isGroupDragging = false;

  TextEditingController taskGroupTitleManager = TextEditingController();
  Color groupColorManager = const Color(0x00ffffff);

  @override
  void initState() {
    // tasks database
    Hive.box('toDoBox');
    db.loadAllTaskGroupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 24, 33),
      floatingActionButton: homeFloatingActionButton(),
      body: hasAnyTaskGroup(),
      appBar: homeAppBar(),
    );
  }

  Widget hasAnyTaskGroup() {
    if (db.taskGroups.isEmpty) return homeHasNoTaskGroups();
    return hasTaskGroup();
  }

  AppBar homeAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 64,
      title: const Text(
        "Simple.todo",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0),
      ),
    );
  }
  
  void closeTaskGroupDialog() {
    Navigator.of(context).pop();
    taskGroupTitleManager.clear();
  }

  void onSave() {
    setState(() {
      if (taskGroupTitleManager.text.isEmpty) return;
      db.createNewTaskGroup(taskGroupTitleManager.text, groupColorManager);
    });
    db.saveAllTaskGroupData();
    closeTaskGroupDialog();
  }
  
  void setGroupColor(Color color) {
    setState(() {
      groupColorManager = color;
    });
  }

  void createNewTaskGroup() {
    showDialog(
      context: context,
      builder: (context) => TaskGroupDialog(
        controller: taskGroupTitleManager,
        onSave: onSave,
        onCancel: closeTaskGroupDialog,
        setGroupColor: setGroupColor 
      ) 
    );
  }

  void onDeleteGroup(String group) {
    setState(() {
      db.removeTaskGroup(group);
      isGroupDragging = false; 
    });
    db.saveAllTaskGroupData();
  }

  FloatingActionButton homeFloatingActionButton() {
    return FloatingActionButton(
      onPressed: isGroupDragging ? null : createNewTaskGroup,
      backgroundColor: isGroupDragging ? Colors.red : Colors.deepOrange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: homeFloatingActionButtonChild()

    );
  }

  Row homeFloatingActionButtonChild() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragTarget(
          onAcceptWithDetails: (details) {
            onDeleteGroup(details.data.toString());
          } ,
          builder: (context, _, __) {
            return Icon(
              isGroupDragging ? Icons.delete_forever : Icons.list ,
              color: Colors.white,
              size: 32.0,
            );
          }
        )
      ],
    );
  }

  GridView hasTaskGroup() {
    List<String> keys = db.taskGroups.keys.toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: db.getTaskGroupsCount(),
      itemBuilder: (context, index) {
        return TaskGroup(
          title: db.getTaskGroupTitle(keys[index]),
          markerColor: db.getTaskGroupMarkerColor(keys[index]),
          markerColorShade: db.getTaskGroupMarkerShadeColor(keys[index]),
          db: db,
          setGroupDragging: setGroupDragging
        );
      }
    );
  }

  Row homeHasNoTaskGroups() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text(
            "Currently you have no tasks!", 
            style: TextStyle(
              color:Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ],
    );
  }

  void setGroupDragging(bool value) {
    setState(() {
      isGroupDragging = value;
    });
  }
}
