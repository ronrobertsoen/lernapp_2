import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class HorizontalDayList extends StatefulWidget {
  final Function dayUpdateFunction;
  final DateTime startDate;
  const HorizontalDayList(
      {Key? key, required this.dayUpdateFunction, required this.startDate})
      : super(key: key);

  @override
  State<HorizontalDayList> createState() => _HorizontalDayListState();
}

class _HorizontalDayListState extends State<HorizontalDayList> {
  //Boxen oben, mit Wochentagen drin
  List<String> weekdays = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];

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

  @override
  Widget build(BuildContext context) {
    // definiert Widget, für die horizontale List von Weekdays
    return SizedBox(
      height: 50, // Gesamtgrösse des Widgets
      width: double.infinity,
      child: ListView.builder(
        // jedes Element ein Weekday
        scrollDirection: Axis.horizontal, // horizontal scrollen
        itemCount: weekdays.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime buttondate = widget.startDate.add(Duration(days: index));
          String formattedDate = DateFormat('dd.MM').format(buttondate);
          return GestureDetector(
            // verarbeitet Benutzerinteraktionen
            onTap: () {
              updateDayColor(index);
              widget.dayUpdateFunction(weekdays[index]);
            },
            child: Container(
              // Aussehen der Karte
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 70,
              width: 50,
              decoration: BoxDecoration(
                  // Rahmen & Hintergrund des Containers
                  color: cardColorList[index][0],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                // Text in Container (Kinderinhalt) wird zentriert
                child: Text(
                  weekdays[index] +
                      "\n" +
                      formattedDate, //Schriftgrösse & Art etc.
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
