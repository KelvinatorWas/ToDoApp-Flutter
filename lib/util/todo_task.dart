import 'package:ToDo/util/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTask extends StatefulWidget {
  final bool completed;
  final String taskTitle;
  final void Function(bool?)? onChange;
  final void Function(BuildContext)? onSlideDelete;
  final void Function(BuildContext)? onSlideEdit;

  const ToDoTask({
    super.key,
    required this.taskTitle,
    required this.completed,
    required this.onChange,
    required this.onSlideDelete,
    required this.onSlideEdit,
  });

  @override
  State<ToDoTask> createState() => _ToDoTaskState();
}

class _ToDoTaskState extends State<ToDoTask> {
  double borderRadius = 5.0;
  double paddingLeftRight = 15.0;
  double paddingTop = 10.0;

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
          onPressed: widget.onSlideEdit,
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

        Padding(padding: const EdgeInsets.all(16), child: CCheckbox(
          onChange: widget.onChange,
          borderColor: Colors.white,
          borderActiveColor: Colors.grey,
          iconColor: Colors.grey,
          shape: CCheckboxShape.circle,
          borderWidth: 2,
          size: 19,
          iconSize: 16,
          value: widget.completed,
        ),),

        //task title
        Text(
          widget.taskTitle,
          style: TextStyle(
            decoration: widget.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: widget.completed ? Colors.grey : Colors.white,
            decorationColor: Colors.grey,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Checkbox oldCheckbox() {
    return Checkbox(
          value: widget.completed,
          onChanged: widget.onChange,
          checkColor: Colors.grey,
          shape: const CircleBorder(),
          fillColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade900),
          side: MaterialStateBorderSide.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const BorderSide(color: Colors.grey, width: 2.0);
            } else {
              return const BorderSide(color: Colors.white, width: 2.0);
            }
          }),

          );
  }

  Container toDoTaskBody() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
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
      padding: EdgeInsets.only(left: paddingLeftRight, right: paddingLeftRight, top: paddingTop),
      child: toDoTaskContainer(),
    );
  }
}
