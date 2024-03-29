import 'package:ToDo/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('toDoBox');

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "simple.todo",
      home: const Home(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        // inputDecorationTheme: const InputDecorationTheme(
        //   labelStyle: TextStyle(color: Colors.black),
        //   hintStyle: TextStyle(color: Colors.black),
        // ),
      ),
    );
  }
}
