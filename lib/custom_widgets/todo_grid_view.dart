import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_try/custom_widgets/todo_tile.dart';
import '../pages/home.dart';

class TodoGridView extends StatefulWidget {
  final List<Lernziel> todoList;
  const TodoGridView({Key? key, required this.todoList}) : super(key: key);

  @override
  State<TodoGridView> createState() => _TodoGridViewState();
}

class _TodoGridViewState extends State<TodoGridView> {
  // Methode, um eine Aufgabe als erledigt zu markieren
  void _markTodoAsDone(int index) {
    setState(() {
      // Entfernt die erledigte Aufgabe aus der Liste
      widget.todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ListView.builder wird für eine vertikale Liste verwendet
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (context, index) {
        Lernziel lernziel = widget.todoList[index];
        String formattedDate = DateFormat('dd.MM.yyyy').format(lernziel.datum);

        // Erstellt ein TodoTile und übergibt den Titel, die Beschreibung und einen Callback
        return TodoTile(
          title: lernziel.titel,
          description: "${lernziel.beschreibung} (Fällig am: $formattedDate)",
          onTodoToggle: () => _markTodoAsDone(index),
        );
      },
    );
  }
}
