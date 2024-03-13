import 'package:flutter/material.dart';
import 'package:ToDo/util/button.dart';

class TaskGroupDialog extends StatefulWidget {
  
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const TaskGroupDialog(
    {
      super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
    }
  );

  @override
  State<TaskGroupDialog> createState() => _TaskGroupDialogState();
}

class _TaskGroupDialogState extends State<TaskGroupDialog> {
  TextField taskGroupDialogInputField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Task group title...",
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey.shade900,
      ),
      controller: widget.controller,
    );
  }

  Row taskGroupDialogSaveCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Button(label: "Save", onPressed: widget.onSave),
        Button(label: "Cancel", onPressed: widget.onCancel),
      ],
    );
  }

  Column taskGroupDialogUi() {
    return Column(
     children: [
        taskGroupDialogInputField(),
        const Padding(padding: EdgeInsets.all(28)),
        taskGroupDialogSaveCancelButtons()
     ], 
    );
  }

  SizedBox taskGroupDialogContainer() {
    return SizedBox(
      height: 140,
      child: taskGroupDialogUi()
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      content: taskGroupDialogContainer(),
    );
  }
}