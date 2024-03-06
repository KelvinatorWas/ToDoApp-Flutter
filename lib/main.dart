import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ToDo/pages/home_page.dart';

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
      home: const HomePage(),
      theme: ThemeData(appBarTheme: const AppBarTheme( backgroundColor: Colors.deepPurple)),
    );
  }
}
