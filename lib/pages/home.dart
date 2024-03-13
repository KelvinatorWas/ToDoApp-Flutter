import 'package:ToDo/data/db.dart';
import 'package:ToDo/util/task_group.dart';
import 'package:ToDo/util/task_group_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ToDoDataBase db = ToDoDataBase();
  List<Widget> taskGroups = [];

  TextEditingController taskGroupTitleManager = TextEditingController();

  @override
  void initState() {
    // tasks database
    Hive.box('toDoBox');
    db.loadAllTaskGroupData();

    taskGroups = [
      TaskGroup(markerColor: Colors.indigo, title: "Shopping", db: db,),
      TaskGroup(markerColor: Colors.lightBlue, title: "Personal", db: db),
      TaskGroup(markerColor: Colors.lightGreen, title: "Website", db: db),
    ];

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
    if (taskGroups.isEmpty) return homeHasNoTaskGroups();
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
      db.taskGroups[taskGroupTitleManager.text] = [
        [taskGroupTitleManager.text],[]
      ];
    });
    db.saveAllTaskGroupData();
    closeTaskGroupDialog();
  }

  void createNewTaskGroup() {
    showDialog(
      context: context,
      builder: (context) => TaskGroupDialog(
        controller: taskGroupTitleManager,
        onSave: onSave,
        onCancel: closeTaskGroupDialog
      ) 
    );
  }

  FloatingActionButton homeFloatingActionButton() {
    return FloatingActionButton(
      onPressed: createNewTaskGroup,
      backgroundColor: Colors.deepOrange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: const Icon(
        Icons.list,
        color: Colors.white,
        size: 32.0,
      )
    );
  }

  GridView hasTaskGroup() {
    List<String> keys = db.taskGroups.keys.toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: db.getTaskGroupsCount(),
      itemBuilder: (context, index) {
        return TaskGroup(title: db.getTaskGroupTitle(keys[index]), markerColor: Colors.lightBlue, db: db);
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
}
