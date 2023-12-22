import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HorizontalDateList extends StatefulWidget {
  final Function dayUpdateFunction;

  const HorizontalDateList({Key? key, required this.dayUpdateFunction})
      : super(key: key);

  @override
  State<HorizontalDateList> createState() => _HorizontalDateListState();
}

class _HorizontalDateListState extends State<HorizontalDateList> {
  //Boxen oben, mit Wochentagen drin
  List<String> weekdays = [
    "18.12",
    "19.12",
    "20.12",
    "21.12",
    "22.12",
    "23.12",
    "24.12"
  ];

  Color activeCardColor = Colors.white;
  Color inactiveCardColor = Colors.black26;

  Color activeTextColor = Colors.black;
  Color inactiveTextColor = Colors.white;

  List<List<Color>> cardColorList = [
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
    [Colors.black26, Colors.white],
  ];

  late DateTime date;

  void updateDayColor(int index) {
    // wird der aktuelle Wochentag berechnet
    setState(() {
      for (int i = 0; i < cardColorList.length; i++) {
        cardColorList[i][0] = inactiveCardColor;
        cardColorList[i][1] = inactiveTextColor;
      }

      cardColorList[index][0] = activeCardColor;
      cardColorList[index][1] = activeTextColor;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      date =
          DateTime.now(); // PostFrameCallback enthält aktuelles Datum & Uhrzeit
      widget.dayUpdateFunction(
          weekdays[date.weekday - 1]); // zeigt an welcher Wochentag ist
      updateDayColor(date.weekday - 1); // Passt die Farbe an
    });
  }

  @override // definiert Widget, für die horizontale List von Weekdays
  Widget build(BuildContext context) {
    return SizedBox(
      // Gesamtgrösse des Widgets
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        // jedes Element ein Weekday
        scrollDirection: Axis.horizontal, // horizontal scrollen
        itemCount: weekdays.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            // verarbeitet Benutzerinteraktionen
            onTap: () {
              updateDayColor(index);
              widget.dayUpdateFunction(weekdays[index]);
            },
            child: Container(
              // Aussehen der Karte
              margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
              height: 70,
              width: 50,
              decoration: BoxDecoration(
                  // Rahmen & Hintergrund des Containers
                  color: cardColorList[index][0],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                // Text in Container (Kinderinhalt) wird zentriert
                child: Text(
                  // Schriftgrösse & Art etc.
                  weekdays[index],
                  style: TextStyle(
                      fontSize: 18,
                      color: cardColorList[index][1],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}