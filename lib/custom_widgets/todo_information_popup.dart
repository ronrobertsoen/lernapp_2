import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoInformationPopup extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

//hier wird das Konstrukt vom Pop-up Fenster definiert, dafür gibt es zwei erfolderliche Parameter
  const TodoInformationPopup({
    Key? key,
    required this.titleController,
    required this.descriptionController,
  }) : super(key: key);

  @override
  State<TodoInformationPopup> createState() => _TodoInformationPopupState();
}

class _TodoInformationPopupState extends State<TodoInformationPopup> {
  // Zustand der Klasse von oben
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // wir haben hier ein Popup mit angegebener Konfiguration erstellt
      backgroundColor: const Color.fromARGB(255, 255, 156, 103),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // abgerundete Ecken
      elevation: 20, // der Schatten wird hier angegeben
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              //in diesem Abschnitt wird die Schrift "Neues Lernziel" definiert
              "Neues Lernziel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              // in diesem Bereich wird ein leeres Element (vertikaler Abstand zw. Elementen) erstellt
              height: 20,
            ),
            Padding(
              //das Widget zur Eingabe vom "Fach" im Pop-up Fenster wird hier erstellt
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
              //das Widget zur Eingabe von der "Beschreibung des Lernzieles" im Pop-up Fenster wird hier erstellt
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
                //dies ist ein Flutterelement, dass auf Interaktionen vom Benutzer reagiert
                onTap: () async {
                  DateTime? newSelectedDate = await showDatePicker(
                    //Dialogfenster mit Datumsauswahl wird angezeigt
                    context: context,
                    locale: const Locale(
                        'de', 'CH'), //Lokalsierung wird auf die Schweiz gesetzt
                    initialDate: DateTime
                        .now(), //Anfangsdatum des Kalenders ist das aktuelle Datum
                    firstDate: DateTime(
                        2023), //der erste Tag, den man im Kalender auswählen kann ist der 1.1.2023
                    lastDate: DateTime(
                        2100), //der letzte Tag, den man im Kalender auswählen kann ist der 31.12.2100
                  ); //das Datum wird nun in der Variable "newSelectedDate" gespeichert
                  if (newSelectedDate != null) {
                    setState(() {
                      selectedDate = newSelectedDate;
                    });
                  }
                },
                child: Text(
                  selectedDate !=
                          null //wenn das ausgewählte Datum nicht gleich null ist
                      ? DateFormat('dd-MM-yyyy')
                          .format(selectedDate!) //Anzeigeformat des Datums
                      : 'Datum auswählen', //dieser Text wird im Pop-up Fenster angezeigt
                  style: const TextStyle(
                    //Style der Anzeige "Datum auswählen" im Pop-up Fenster
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
                height:
                    20), //Erstellung Button zum Hinzufügen des Lernziels in die Datenbank
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Hinzufügen"),
              onPressed: () {
                //onPressed wird ausgeführt, sobald der Benutzer auf den Buttons klickt
                if (selectedDate !=
                        null && //Überprüfung, ob ein Datum ausgewählt wurde
                    widget.titleController.text
                        .isNotEmpty && //Überprüfung, ob ein Fach und eine Beschreibung definiert wurde
                    widget.descriptionController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    //aktueller Bildschirm wird geschlossen und die Homeansicht wird angezeigt
                    'selectedDate':
                        selectedDate, //hier wird das Datum der Datenbank übergeben
                    'title': widget.titleController
                        .text, //hier wird das Fach der Datenbank übergeben
                    'description': widget.descriptionController
                        .text //hier wird die Beschreibung der Datenbank übergeben
                  });
                } else {
                  //diese Funktion wird aufgerufen, wenn der Benutzer entweder kein Datum / kein Fach oder keine Beschreibung ausgefüllt hat
                  ScaffoldMessenger.of(context).showSnackBar(
                    //ein Text wird dem Benutzer angezeigt
                    const SnackBar(
                      content: Text(
                          //Text der Beschreibung die für den Benutzer erscheint
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
