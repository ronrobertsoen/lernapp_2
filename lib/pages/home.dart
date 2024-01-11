import 'package:flutter/material.dart';
import 'package:todo_try/custom_widgets/horizontal_day_list.dart';
import 'package:todo_try/custom_widgets/todo_grid_view.dart';
import 'package:todo_try/custom_widgets/todo_information_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Für die JSON-Kodierung

// Definition der Klasse Lernziel mit ihren Eigenschaften und Methoden
class Lernziel {
  String titel;
  String beschreibung;
  DateTime datum;

// Konstruktor um ein Lernziel zu erstellen.
  Lernziel({
    required this.titel,
    required this.beschreibung,
    required this.datum,
  });
// Factory-Methode zur Erstellung eines Lernziels aus einem JSON-Objekt
  factory Lernziel.fromJson(Map<String, dynamic> json) {
    return Lernziel(
      titel: json['titel'],
      beschreibung: json['beschreibung'],
      datum: DateTime.parse(json['datum']),
    );
  }
// Methode zum Konvertieren des Lernziels in ein JSON-Objekt
  Map<String, dynamic> toJson() => {
        'titel': titel,
        'beschreibung': beschreibung,
        'datum': datum.toIso8601String(),
      };
}

// Definition der Klasse HomePage, Das Hauptseiten-Widget der App
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Der Zustand, der mit dem HomePage-Widget verbunden ist.
class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(); // Für die Datumeingabe.

// Listen zur Speicherung der Lernziele
  List<Lernziel> todoInformation = []; // Alle Lernziele.
  List<Lernziel> dayDependentTodos =
      []; // Lernziele, gefiltert nach dem ausgewählten Tag.
  DateTime currentdate = DateTime.now(); // Das aktuell ausgewählte Datum.

  @override
  void initState() {
    super.initState();
    loadLernziele(); // Lade Lernziele, wenn die App startet.
  }

  // Lädt gespeicherte Lernziele aus dem lokalen Speicher.
  void loadLernziele() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lernzieleString = prefs.getString('lernziele');
    if (lernzieleString != null) {
      final List<Lernziel> lernziele = (json.decode(lernzieleString) as List)
          .map((item) => Lernziel.fromJson(item))
          .toList();
      setState(() {
        todoInformation = lernziele;
        updateList(); // Aktualisiere die Liste, um die geladenen Lernziele anzuzeigen.
      });
    }
  }

  // Speichert die aktuelle Liste der Lernziele im lokalen Speicher.
  void saveLernziele() async {
    final prefs = await SharedPreferences.getInstance();
    final String lernzieleString = json.encode(todoInformation);
    await prefs.setString('lernziele', lernzieleString);
  }

// Hilfsfunktion zur Anzeige einer Nachricht in einem SnackBar
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.redAccent),
        ),
      ),
    );
  }

// Aktualisiert den ausgewählten Tag und filtert die Lernziele entsprechend.
  void changeWeekday(DateTime newdate) {
    setState(() {
      currentdate = newdate;
      updateList();
    });
  }

// Fügt ein neues Lernziel hinzu und speichert es.
  void addLernziel(DateTime chosenDate, String title, String description) {
    setState(() {
      todoInformation.add(Lernziel(
        titel: title,
        beschreibung: description,
        datum: chosenDate,
      ));
      updateList(); //Aktualisiere die Liste, um das neue Lernziel anzuzeigen.
    });
  }

// Funktion zum Aktualisieren der Liste basierend auf dem aktuellen Datum
  void updateList() {
    dayDependentTodos.clear();
    for (Lernziel lernziel in todoInformation) {
      if (DateUtils.isSameDay(lernziel.datum, currentdate)) {
        dayDependentTodos.add(lernziel);
      }
    }
  }

  // Geht zur nächsten Woche über und aktualisiert die Liste.
  void nextweek() {
    setState(() {
      currentdate = currentdate.add(const Duration(days: 7));
      updateList();
    });
  }

// Geht zur vorherigen Woche zurück und aktualisiert die Liste.
  void previousweek() {
    setState(() {
      currentdate = currentdate.subtract(const Duration(days: 7));
      updateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Erstellt Haupt-UI mit Scaffold Widget, Aufbau der Benutzeroberfläche der App.
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 111, 112, 112),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 111, 112, 112),
          elevation: 0.0, //Schatten unter App Bar entfernt
          title: const Text("LERNAPP"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            //Widget zur Anzeige einer horizontalen Liste von Tagen
            HorizontalDayList(
                dayUpdateFunction:
                    changeWeekday, // Funktion wird aufgerufen, wenn Tag ausgewählt wird
                startDate: currentdate),
            const SizedBox(
                height:
                    20), // Erweiterter Container, um die Liste der Lernziele anzuzeigen.
            Expanded(
              child: Container(
                // cntainer für Darstellung der Lernziele
                width: double.infinity, //Container nimt volle Breite ein
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    // macht Ecken oben abgerundet
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10.0)],
                ), // Widget, das eine Gitteransicht der Lernziele anzeigt.
                child: TodoGridView(
                    todoList:
                        dayDependentTodos), // Übergibt die tagesabhängigen Lernziele
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          //Floating Action Button-Reihe, um zur nächsten/vorherigen Woche zu navigieren oder ein neues Lernziel hinzuzufügen.
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Dies sorgt dafür, dass die Buttons richtig platziert sind
          children: [
            FloatingActionButton(
              onPressed: previousweek,
              elevation: 5.0,
              backgroundColor: const Color.fromARGB(255, 158, 158, 158),
              child: const Icon(Icons.arrow_back, size: 35),
            ),
            FloatingActionButton(
              onPressed: nextweek,
              elevation: 5.0,
              backgroundColor: const Color.fromARGB(255, 158, 158, 158),
              child: const Icon(Icons.arrow_forward,
                  size: 35), // Button für die Navigation zur nächsten Woche
            ),
            // Button zum Hinzufügen eines neuen Lernziels
            FloatingActionButton(
              onPressed: () {
                // Öffnet ein Popup-Fenster zur Eingabe von Lernzielinformationen
                showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    return TodoInformationPopup(
                      titleController: titleController,
                      descriptionController: descriptionController,
                    );
                  },
                ).then((result) {
                  // Verarbeitet die Eingabe aus dem Dialog.
                  if (result != null) {
                    // Wenn das Ergebnis nicht null ist, wird ein neues Lernziel hinzugefügt
                    DateTime selectedDate = result['selectedDate'];
                    String title = result['title'];
                    String description = result['description'];

                    addLernziel(selectedDate, title,
                        description); // Fügt das neue Lernziel hinzu und speichert es.
                    saveLernziele();
                    // Leert die Textfeld-Controller
                    titleController.clear();
                    descriptionController.clear();
                  } else {
                    // Zeigt eine Nachricht, wenn das Popup-Ergebnis null ist, wenn nicht alle Felder ausgefüllt wurden.
                    showInSnackBar(
                        "Bitte füllen Sie alle Felder aus und wählen Sie ein Datum.");
                  }
                });
              },
              splashColor: const Color.fromARGB(255, 158, 158, 158),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              backgroundColor: const Color.fromARGB(255, 158, 158, 158),
              child: const Icon(Icons.add, size: 50),
            ),
          ],
        ));
  }
}
