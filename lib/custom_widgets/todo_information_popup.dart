import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoInformationPopup extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController dateController; // Neuer Controller für das Datum

  const TodoInformationPopup({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.dateController, // Neuer Parameter für den Datum-Controller
  }) : super(key: key);

  @override
  _TodoInformationPopupState createState() => _TodoInformationPopupState();
}

class _TodoInformationPopupState extends State<TodoInformationPopup> {
  // Zustand der Klasse von oben
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // erstellt Popup mit angegebener Konfiguration
      backgroundColor: Color.fromARGB(255, 255, 156, 103),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // abgerundete Ecken
      elevation: 20, // Schatten
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Neues Lernziel",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            const SizedBox(
              // erstell leeres Element (vertikaler Abstand zw. Elementen)
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  labelText: "Fach",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget.descriptionController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  labelText: "Beschreibung",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget
                    .dateController, // Verwenden Sie den neuen Controller hier
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              child: const Text("Hinzufügen"),
              onPressed: () => Navigator.pop(context, false),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
