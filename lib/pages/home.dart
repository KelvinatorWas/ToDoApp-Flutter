import 'package:ToDo/util/task_group.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> taskGroups = [
      // const TaskGroup(markerColor: Colors.indigo, title: "Shopping",),
      // const TaskGroup(markerColor: Colors.lightBlue, title: "Personal",),
      // const TaskGroup(markerColor: Colors.lightGreen, title: "Website",),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 24, 33),
      floatingActionButton: homeFloatingActionButton(),
      body: hasAnyTaskGroup(),
      appBar: homeAppBar(),
    );
  }

  Widget hasAnyTaskGroup() {
    if (taskGroups.isEmpty) return homeHasNoTaskGroups();
    return hasTaskGroup();
  }

  AppBar homeAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 64,
      title: const Text(
        "Simple.todo",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0),
      ),
    );
  }

  FloatingActionButton homeFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: const Icon(
          Icons.list,
          color: Colors.white,
          size: 32.0,
        ));
  }

  GridView hasTaskGroup() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(32.0),
      children: homeBodyElements(),
    );
  }

  List<Widget> homeBodyElements() {
    return taskGroups;
  }

  Row homeHasNoTaskGroups() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text(
            "Currently you have no tasks!", 
            style: TextStyle(
              color:Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ],
    );
  }
}