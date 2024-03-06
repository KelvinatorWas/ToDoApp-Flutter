import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testing/data/db.dart';
import 'package:testing/util/task_dialog.dart';
import 'package:testing/util/todo_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController taskDialogController = TextEditingController();

  // tasks database
  final toDoBox = Hive.box('toDoBox');
  ToDoDataBase db = ToDoDataBase(); 

  @override
  void initState() {
    // if data is null, create inital data
    (toDoBox.get("tasks") == null) ? db.initalData() : db.loadData();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: homePageStateAppBar(),
      body: homePageStateBody(),
      floatingActionButton: homePageStateFloatingActionButton() ,
    );
  }

  void saveNewTask () {
    setState(() {
        if (!taskDialogController.text.isNotEmpty) return;
        db.toDoTasks.add([taskDialogController.text, false]);
        taskDialogController.clear();
      }
    );
    db.saveData(); // should change it 
    cancelNewTask();
  }

  void cancelNewTask () => Navigator.of(context).pop();

  void createNewToDoTask() {
    showDialog(context: context, builder: (context) {
      return TaskDialog(
        controller: taskDialogController,
        onSave: saveNewTask,
        onCancel: cancelNewTask,
      );
    });
  }

  void onCheckBoxChange(int index) {
    setState(() {
      db.toDoTasks[index][1] = !db.toDoTasks[index][1];
    });

    db.saveData();
  }

  void onSlideDelete(int index) {
    setState(() {
        db.toDoTasks.removeAt(index);
      }
    );
    db.saveData(); // should change it to delete the key index
  }

  FloatingActionButton homePageStateFloatingActionButton() {
    return FloatingActionButton(
      onPressed: createNewToDoTask,
      child: const Icon(
        Icons.add,
      )
    );
  }
  
  AppBar homePageStateAppBar() {
    return AppBar(
      title: const Center(
        child: Text(
          "TODO",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      elevation: 0,
    );
  }

  ListView homePageStateBody() {
    return ListView.builder(
      itemCount: db.toDoTasks.length,
      itemBuilder: (context, index) => ToDoTask(
        taskTitle: db.toDoTasks[index][0],
        completed: db.toDoTasks[index][1],
        onChange: (_) => onCheckBoxChange(index),
        onSlideDelete: (_) => onSlideDelete(index),
      ),
    );
  }
}
