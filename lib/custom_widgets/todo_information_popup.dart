import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoInformationPopup extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const TodoInformationPopup({
    Key? key,
    required this.titleController,
    required this.descriptionController,
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
      backgroundColor: const Color.fromARGB(255, 255, 156, 103),
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
                fontSize: 30,
              ),
            ),
            const SizedBox(
              // erstell leeres Element (vertikaler Abstand zw. Elementen)
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget.descriptionController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Beschreibung",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: GestureDetector(
                onTap: () async {
                  DateTime? newSelectedDate = await showDatePicker(
                    context: context,
                    locale: const Locale('de', 'CH'),
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );
                  if (newSelectedDate != null) {
                    setState(() {
                      selectedDate = newSelectedDate;
                    });
                  }
                },
                child: Text(
                  selectedDate != null
                      ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                      : 'Datum auswählen',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Hinzufügen"),
              onPressed: () {
                if (selectedDate != null &&
                    widget.titleController.text.isNotEmpty &&
                    widget.descriptionController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'selectedDate': selectedDate,
                    'title': widget.titleController.text,
                    'description': widget.descriptionController.text
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Bitte wählen Sie ein Datum und füllen Sie alle Felder aus."),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
