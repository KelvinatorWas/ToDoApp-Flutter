import 'package:ToDo/util/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:ToDo/util/button.dart';

class TaskGroupDialog extends StatefulWidget {
  
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final void Function(Color color)? setGroupColor;

  const TaskGroupDialog(
    {
      super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
      this.setGroupColor
    }
  );

  @override
  State<TaskGroupDialog> createState() => _TaskGroupDialogState();
}

class _TaskGroupDialogState extends State<TaskGroupDialog> {

  Color titleColor = Colors.white; 

  void setTitleColor(Color color) {
    setState(() {
      titleColor = color;
    });
    
    widget.setGroupColor!(color);
  }
  
  TextField taskGroupDialogInputField() {
    return TextField(
      style: TextStyle(color: titleColor),
      decoration: InputDecoration(
        hintText: "Task group title...",
        hintStyle: TextStyle(color: titleColor),
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
        ColorPicker(width: 200, height: 15, setColor: setTitleColor,),
        const Padding(padding: EdgeInsets.all(9)),
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