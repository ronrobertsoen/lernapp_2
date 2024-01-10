import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // wird benötigt um Datum zu formatieren
import 'package:todo_try/custom_widgets/todo_tile.dart'; // Widget für To-Do-Elemente
import '../pages/home.dart'; // Homepage

class TodoGridView extends StatefulWidget {
  final List<Lernziel> todoList;
  const TodoGridView({Key? key, required this.todoList})
      : super(key: key); // Liste der jeweiligen Lernziele

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
    // Verwenden Sie ListView.builder für eine vertikale Liste
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (context, index) {
        Lernziel lernziel = widget.todoList[index];
        String formattedDate = DateFormat('dd.MM.yyyy').format(lernziel.datum);
        // Formatierung des Lernziels

        // Erstellt ein TodoTile und übergibt den Titel, die Beschreibung und das Fälligkeitsdatum
        return TodoTile(
          title: lernziel.titel,
          description: "${lernziel.beschreibung} (Fällig am: $formattedDate)",
          onTodoToggle: () => _markTodoAsDone(
              index), // sobald die Aufgabe erledigt ist, wird sie entfernt
        );
      },
    );
  }
}
