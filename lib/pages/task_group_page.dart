import 'package:flutter/material.dart';
import 'package:ToDo/data/db.dart';
import 'package:ToDo/util/task_dialog.dart';
import 'package:ToDo/util/todo_task.dart';

class TaskGroupPage extends StatefulWidget {
  final String taskGroupId;
  final ToDoDataBase db;
  final VoidCallback updateCount;

  const TaskGroupPage({super.key, this.taskGroupId = "None", required this.db, required this.updateCount});

  @override
  State<TaskGroupPage> createState() => TaskGroupPageState();
}

class TaskGroupPageState extends State<TaskGroupPage> {
  final TextEditingController taskDialogController = TextEditingController();

  @override
  void initState() {
    // if data is null, create inital data
    widget.db.loadTaskGroupData(widget.taskGroupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 24, 33),
      appBar: taskGroupPageStateAppBar(),
      body: taskGroupPageStateBody(),
      floatingActionButton: taskGroupPageStateFloatingActionButton(),
    );
  }

  void closeTaskDialog() {
    Navigator.of(context).pop();
    taskDialogController.clear();
  }

  // New Task Methods
  void saveNewTask() {
    setState(() {
      if (taskDialogController.text.isEmpty) return;
      widget.db.taskGroups[widget.taskGroupId]?[1].add([taskDialogController.text, false]);
      taskDialogController.clear();
    });
    widget.db.saveTaskGroupData(widget.taskGroupId);
    closeTaskDialog();
  }

  void createNewToDoTask() {
    showDialog(
        context: context,
        builder: (context) {
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
      widget.db.taskGroups[widget.taskGroupId]?[editTaskIndex] = [
        taskDialogController.text,
        widget.db.taskGroups[widget.taskGroupId]?[editTaskIndex][1]
      ];
      taskDialogController.clear();
    });
    widget.db.saveTaskGroupData(widget.taskGroupId);

    closeTaskDialog();
  }

  void editToDoTask(int editTaskIndex) {
    taskDialogController.text =
        widget.db.taskGroups[widget.taskGroupId]?[1][editTaskIndex][0];

    showDialog(
        context: context,
        builder: (context) {
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
      widget.db.taskGroups[widget.taskGroupId]?[1][index][1] =
        !widget.db.taskGroups[widget.taskGroupId]?[1][index][1];
    });

    widget.db.saveTaskGroupData(widget.taskGroupId);
  }

  // Slide Buttons
  void onSlideDelete(int index) {
    setState(() {
      widget.db.taskGroups[widget.taskGroupId]?[1].removeAt(index);
    });
    widget.db.saveTaskGroupData(widget.taskGroupId);
  }

  void onSlideEdit(int index) {
    setState(() {
      //widget.db.toDoTasks.removeAt(index);
      editToDoTask(index);
    });
  }

  FloatingActionButton taskGroupPageStateFloatingActionButton() {
    return FloatingActionButton(
        onPressed: createNewToDoTask,
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32.0,
        )
      );
  }

  AppBar taskGroupPageStateAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
          onPressed: () {
            widget.db.saveTaskGroupData(widget.taskGroupId);
            Navigator.of(context).pop();
            widget.updateCount();
          },
          icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      title: const Text(
        "Simple.todo",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0),
      ),
    );
  }

  ListView taskGroupPageStateBody() {
    return ListView.builder(
      itemCount: widget.db.taskGroups[widget.taskGroupId]?[1].length,
      itemBuilder: (context, index) => ToDoTask(
        taskTitle: widget.db.taskGroups[widget.taskGroupId]?[1][index][0],
        completed: widget.db.taskGroups[widget.taskGroupId]?[1][index][1],
        onChange: (_) => onCheckBoxChange(index),
        onSlideDelete: (_) => onSlideDelete(index),
        onSlideEdit: (_) => onSlideEdit(index),
      ),
    );
  }
}
