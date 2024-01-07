//import 'dart:ui';        glaub unnötig, das alles im flutter enthalten ist

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_try/custom_widgets/horizontal_day_list.dart';
import 'package:todo_try/custom_widgets/todo_grid_view.dart';
import 'package:todo_try/custom_widgets/todo_information_popup.dart';

class Lernziel {
  String titel;
  String beschreibung;
  DateTime datum;

  Lernziel(
      {required this.titel, required this.beschreibung, required this.datum});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(); // Neuer Controller für das Datum

  List<Lernziel> todoInformation = [];
  List<Lernziel> dayDependentTodos = [];
  int weekday = 0;
  DateTime currentdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Setzt den aktuellen Wochentag beim Start der App
    weekday = currentdate.weekday - 1;
  }

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

  void changeWeekday(int newDay) {
    setState(() {
      weekday = newDay;
    });
    updateList();
  }

  void addLernziel(DateTime chosenDate, String title, String description) {
    setState(() {
      todoInformation.add(Lernziel(
        titel: title,
        beschreibung: description,
        datum: chosenDate,
      ));
      updateList();
    });
  }

  void updateList() {
    dayDependentTodos.clear();
    for (Lernziel lernziel in todoInformation) {
      (DateFormat('EEEE', 'de_DE').format(lernziel.datum));
      if (lernziel.datum.weekday - 1 == weekday) {
        dayDependentTodos.add(lernziel);
      }
    }
  }

  void nextweek() {
    setState(() {
      currentdate = currentdate.add(const Duration(days: 7));
    });
  }

  void previousweek() {
    setState(() {
      currentdate = currentdate.subtract(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 111, 112, 112),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 111, 112, 112),
          elevation: 0.0,
          title: const Text("LERNAPP"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            HorizontalDayList(
                dayUpdateFunction: changeWeekday, startDate: currentdate),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10.0)],
                ),
                child: TodoGridView(todoList: dayDependentTodos),
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
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
              child: const Icon(Icons.arrow_forward, size: 35),
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    return TodoInformationPopup(
                      titleController: titleController,
                      descriptionController: descriptionController,
                    );
                  },
                ).then((result) {
                  // 'selectedDate' empfängt das Datum vom Popup
                  if (result != null) {
                    DateTime selectedDate = result['selectedDate'];
                    String title = result['title'];
                    String description = result['description'];

                    addLernziel(selectedDate, title, description);
                    titleController.clear();
                    descriptionController.clear();
                  } else {
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
