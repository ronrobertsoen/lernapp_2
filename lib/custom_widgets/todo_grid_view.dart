import 'package:flutter/material.dart';
import 'package:todo_try/custom_widgets/todo_tile.dart';

class TodoGridView extends StatefulWidget {
  final List<String> todoList;
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
    // Verwenden Sie ListView.builder für eine vertikale Liste
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (context, index) {
        var todoParts = widget.todoList[index].split(',');
        var title = todoParts[1];
        var description = todoParts.length > 2 ? todoParts[2] : '';

        // Erstellt ein TodoTile und übergibt den Titel, die Beschreibung und einen Callback
        return TodoTile(
          title: title,
          description: description,
          onTodoToggle: () => _markTodoAsDone(index),
        );
      },
    );
  }
}
