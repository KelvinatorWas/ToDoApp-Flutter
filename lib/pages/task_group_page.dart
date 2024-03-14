import 'package:flutter/material.dart';
import 'package:ToDo/data/db.dart';
import 'package:ToDo/util/task_dialog.dart';
import 'package:ToDo/util/todo_task.dart';

class TaskGroupPage extends StatefulWidget {
  final String taskGroupId;
  final ToDoDataBase db;
  final VoidCallback updateCount;
  final Color appBarTitleColor;

  const TaskGroupPage(
    {
      super.key,
      this.taskGroupId = "None",
      required this.db,
      required this.updateCount,
      this.appBarTitleColor = Colors.white,
    }
  );

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
      widget.db.createNewTask(
        widget.taskGroupId,
        taskDialogController.text
      );

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
        if (taskDialogController.text.isEmpty) return;
        widget.db.setTaskData(
          widget.taskGroupId,
          editTaskIndex,
          taskDialogController.text,
          null
        );

        taskDialogController.clear();
      }
    );

    widget.db.saveTaskGroupData(widget.taskGroupId);
    closeTaskDialog();
  }

  void editToDoTask(int editTaskIndex) {
    taskDialogController.text = widget.db.getTaskText(widget.taskGroupId, editTaskIndex);

    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          controller: taskDialogController,
          onSave: () => saveEditedToDoTask(editTaskIndex),
          onCancel: closeTaskDialog,
        );
      }
    );
  }

  // Check Box
  void onCheckBoxChange(int index) {
    setState(() {
      widget.db.setTaskCheckmarkValue(
        widget.taskGroupId,
        index,
        null
      );
    });

    widget.db.saveTaskGroupData(widget.taskGroupId);
  }

  // Slide Buttons
  void onSlideDelete(int index) {
    setState(() {
      widget.db.removeTask(widget.taskGroupId, index);
    });
    widget.db.saveTaskGroupData(widget.taskGroupId);
  }

  void onSlideEdit(int index) {
    setState(() {
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
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white,)),
      title: Text(
        widget.taskGroupId,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.appBarTitleColor,
            fontSize: 18.0
        ),
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
