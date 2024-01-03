//import 'dart:ui';        glaub unnötig, das alles im flutter enthalten ist

import 'package:flutter/material.dart';
import 'package:todo_try/custom_widgets/horizontal_day_list.dart';
import 'package:todo_try/custom_widgets/todo_grid_view.dart';
import 'package:todo_try/custom_widgets/todo_information_popup.dart';

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

  List<String> dayDependentTodos = [];
  List<String> todoInformation = ["MON,TEST1,TEST1"];
  String weekday = "";
  DateTime currentdate = DateTime(2024, 01, 08);

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose(); // Entsorgen des Controllers
    super.dispose();
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

  void changeWeekday(String newDay) {
    setState(() {
      weekday = newDay;
    });
    updateList();
  }

  void updateList() {
    dayDependentTodos.clear();
    for (var todoInfo in todoInformation) {
      if (todoInfo.split(",")[0] == weekday) {
        dayDependentTodos.add(todoInfo);
      }
    }
  }

  int value = 0;
  void nextweek() {
    setState(() {
      currentdate = currentdate.add(Duration(days: 7));
    });
  }

  void previousweek() {
    setState(() {
      currentdate = currentdate.subtract(Duration(days: 7));
    });
    value = -7;
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return TodoInformationPopup(
                      titleController: titleController,
                      descriptionController: descriptionController,
                      dateController:
                          dateController, // Übergeben des Controllers
                    );
                  },
                ).then((value) {
                  setState(() {
                    if (descriptionController.text.isEmpty ||
                        titleController.text.isEmpty) {
                      showInSnackBar(
                          "Fach oder Beschreibung darf nicht leer sein!");
                    } else {
                      todoInformation.add(
                          "$weekday,${titleController.text},${descriptionController.text}");
                      updateList();
                      titleController.clear();
                      descriptionController.clear();
                    }
                  });
                });
              },
              splashColor: const Color.fromARGB(255, 158, 158, 158),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              backgroundColor: const Color.fromARGB(255, 158, 158, 158),
              child: const Icon(Icons.add, size: 50),
            )
          ],
        ));
  }
}
