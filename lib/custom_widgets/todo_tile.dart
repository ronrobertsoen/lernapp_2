//import 'dart:ffi';                           // kann nun auf Funktionen & Daten aus anderen Programmiersprachen zugegriffen werden
import 'package:flutter/material.dart'; // Klassen & Funktionen aus Flutter Biblio
//import 'package:intl/intl.dart';                wichtig für Kalender einbettung

class TodoTile extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTodoToggle;

  const TodoTile({
    Key? key,
    required this.title,
    required this.description,
    required this.onTodoToggle,
  }) : super(key: key);

  @override
  _TodoTileState createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    // Wenn die Aufgabe erledigt ist, wird nichts gerendert
    if (isDone) return SizedBox();

    // Ansonsten wird das TodoTile normal gerendert
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.description),
      trailing: Checkbox(
        value: isDone,
        onChanged: (bool? value) {
          // Aktualisiert den lokalen Zustand und ruft den übergeordneten Callback auf
          if (value != null) {
            setState(() => isDone = value);
            if (isDone) {
              // Verzögert den Callback, um die Checkbox-Animation zu ermöglichen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onTodoToggle();
              });
            }
          }
        },
      ),
    );
  }
}
