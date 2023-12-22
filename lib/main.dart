import 'package:flutter/material.dart';
import 'package:todo_try/pages/home.dart';

void main() {
  runApp(const TodoApp());
}

//Das ist die Hauptklasse
class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
