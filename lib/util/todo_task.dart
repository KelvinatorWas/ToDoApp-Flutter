import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTask extends StatefulWidget {
  final bool completed;
  final String taskTitle;
  final Function(bool?)? onChange;
  final Function(BuildContext)? onSlideDelete;

  const ToDoTask({
    super.key,
    required this.taskTitle,
    required this.completed,
    required this.onChange,
    required this.onSlideDelete,
  });

  @override
  State<ToDoTask> createState() => _ToDoTaskState();
}

class _ToDoTaskState extends State<ToDoTask> {
  Function(BuildContext)? onSlideEdit;

  double borderRadius = 5.0;

  ActionPane slideDeleteButton() {
    return ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: widget.onSlideDelete,
          icon: Icons.delete_forever,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ],
    );
  }

  ActionPane slideEditButton() {
    return ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: onSlideEdit,
          icon: Icons.edit,
          backgroundColor: Colors.green,
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ],
    );
  }

  Row toDoTaskBodyValues() {
    return Row(
      children: [
        // check box
        Checkbox(
          value: widget.completed,
          onChanged: widget.onChange,
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),

        //task title
        Text(
          widget.taskTitle,
          style: TextStyle(
            decoration:
                widget.completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Container toDoTaskBody() {
    return Container(
      padding: const EdgeInsets.all(21.0),
      decoration: BoxDecoration(
          color: Colors.deepPurple, borderRadius: BorderRadius.circular(borderRadius)),
      child: toDoTaskBodyValues(),
    );
  }

  Slidable toDoTaskContainer() {
    return Slidable(
      endActionPane: slideDeleteButton(),
      startActionPane: slideEditButton(),
      child: toDoTaskBody(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0, right: 21.0, top: 21.0),
      child: toDoTaskContainer(),
    );
  }
}
