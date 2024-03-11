import 'package:flutter/material.dart';
import 'package:ToDo/util/button.dart';

class TaskDialog extends StatefulWidget {
  
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const TaskDialog(
    {
      super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
    }
  );

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  TextField taskDialogInputField() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Add a new task...",
      ),
      controller: widget.controller,
    );
  }

  Row taskDialogSaveCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Button(label: "Save", onPressed: widget.onSave),
        Button(label: "Cancel", onPressed: widget.onCancel),
      ],
    );
  }

  Column taskDialogUi() {
    return Column(
     children: [
        taskDialogInputField(),
        const Padding(padding: EdgeInsets.all(8)),
        taskDialogSaveCancelButtons()
     ], 
    );
  }

  SizedBox taskDialogContainer() {
    return SizedBox(
      height: 140,
      child: taskDialogUi()
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue,
      content: taskDialogContainer(),
    );
  }
}