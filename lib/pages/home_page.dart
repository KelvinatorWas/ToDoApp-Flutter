import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ToDo/data/db.dart';
import 'package:ToDo/util/task_dialog.dart';
import 'package:ToDo/util/todo_task.dart';

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

  void closeTaskDialog() => Navigator.of(context).pop();

  // New Task Methods
  void saveNewTask() {
    setState(() {
        if (!taskDialogController.text.isNotEmpty) return;
        db.toDoTasks.add([taskDialogController.text, false]);
        taskDialogController.clear();
      }
    );
    db.saveData(); // should change it 
    closeTaskDialog();
  }

  void createNewToDoTask() {
    showDialog(context: context, builder: (context) {
      return TaskDialog(
        controller: taskDialogController,
        onSave: saveNewTask,
        onCancel: closeTaskDialog,
      );
    });
  }

  // Edit ToDo Task methods
  void saveEditedToDoTask(int editTaskIndex) {
    setState(() {
        if (!taskDialogController.text.isNotEmpty) return;
        db.toDoTasks[editTaskIndex] = [taskDialogController.text, db.toDoTasks[editTaskIndex][1]];
        taskDialogController.clear();
      }
    );
    db.saveData(); // should change it 
    closeTaskDialog();
  }
  
  void editToDoTask(int editTaskIndex) {

    taskDialogController.text = db.toDoTasks[editTaskIndex][0];

    showDialog(context: context, builder: (context) {
      return TaskDialog(
        controller: taskDialogController,
        onSave: () => saveEditedToDoTask(editTaskIndex),
        onCancel: closeTaskDialog,
      );
    });
  }

  // Check Box
  void onCheckBoxChange(int index) {
    setState(() {
      db.toDoTasks[index][1] = !db.toDoTasks[index][1];
    });

    db.saveData();
  }

  // Slide Buttons
  void onSlideDelete(int index) {
    setState(() {
        db.toDoTasks.removeAt(index);
      }
    );
    db.saveData(); // should change it to delete the key index
  }

  void onSlideEdit(int index) {
    setState(() {
        //db.toDoTasks.removeAt(index);
        editToDoTask(index);
      }
    );
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
        onSlideEdit: (_) => onSlideEdit(index),
      ),
    );
  }
}
