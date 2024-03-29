import 'package:ToDo/data/db.dart';
import 'package:ToDo/pages/task_group_page.dart';
import 'package:flutter/material.dart';

class TaskGroup extends StatefulWidget {
  final double padding;
  final double size;
  final double borderRadius;
  final String title;
  final Color markerColor;
  final Color markerColorShade;
  final ToDoDataBase db;
  final Function(bool v) setGroupDragging;

  const TaskGroup({
    super.key,
    required this.db, 
    required this.setGroupDragging,
    this.padding = 8.0,
    this.size = 120,
    this.borderRadius = 5.0,
    this.title = "Title",
    this.markerColor = Colors.deepOrange,
    this.markerColorShade = const Color.fromRGBO(191, 54, 12, 1),
  });

  @override
  State<TaskGroup> createState() => _TaskGroupState();
}

class _TaskGroupState extends State<TaskGroup> {
  int taskCount = 0;
  bool isDragging = false;

  @override
  void initState() {
    taskCount = widget.db.lenghtOfGroup(widget.title);
    super.initState();
  }

  void updateTaskCount() {
    setState(() {
      taskCount = widget.db.lenghtOfGroup(widget.title);
    });
  }

  void onDragStart() => widget.setGroupDragging(true);

  void onDragEnd(DraggableDetails details) => widget.setGroupDragging(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: LongPressDraggable(
        feedback: taskGroupBody(), 
        childWhenDragging: taskGroupBodyWhenDragging(),
        onDragStarted: onDragStart,
        onDragEnd: onDragEnd,
        data: widget.title,
        child: taskGroupBody(),
        ) ,
    );
  }

  Container taskGroupBodyWhenDragging() {
    return Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
      );
  }

  GestureDetector taskGroupBody() {
    return GestureDetector(
      child: Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        decoration: taskGroupBodyDecoration(),
        child: taskGroupBodyChild(),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskGroupPage(
              taskGroupId: widget.title,
              db: widget.db,
              updateCount:updateTaskCount,
              appBarTitleColor: widget.markerColor,
            )
          )
        );
      },
    );
  }

  BoxDecoration taskGroupBodyDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );
  }

  Column taskGroupBodyChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: taskGroupBodyChildElements(),
    );
  }

  List<Widget> taskGroupBodyChildElements() {
    return [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.markerColorShade, // dont like using !
              blurRadius: 5.0,
              spreadRadius: 5.0
            )
          ],
          color: widget.markerColor,
        ),
      ),
      
      const Padding(padding: EdgeInsets.all(12)),

      Text(
        widget.title,
        style: TextStyle(
          color: widget.markerColor,
          fontSize: 16
        )
      ),

      const Padding(padding: EdgeInsets.all(4)),
      
      Text(
        "Tasks $taskCount",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12
        )
      )
    ];
  }
}
