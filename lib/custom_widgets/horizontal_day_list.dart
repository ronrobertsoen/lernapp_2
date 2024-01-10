import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDayList extends StatelessWidget {
  final Function(DateTime) dayUpdateFunction;
  final DateTime startDate;
  HorizontalDayList(
      {Key? key, required this.dayUpdateFunction, required this.startDate})
      : super(key: key);

  //Boxen oben, mit Wochentagen drin
  final List<String> weekdays = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];

  Color getCardColor(DateTime day) {
    if (DateUtils.isSameDay(day, startDate)) {
      return Colors.white;
    } else {
      return Colors.black26;
    }
  }

  Color getTextColor(DateTime day) {
    if (DateUtils.isSameDay(day, startDate)) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime monday =
        startDate.subtract(Duration(days: startDate.weekday - 1)); //Ausrechnung

    // definiert Widget, für die horizontale List von Weekdays
    return SizedBox(
      height: 50, // Gesamtgrösse des Widgets
      width: double.infinity,
      child: ListView.builder(
        //Builder = Schleife
        // jedes Element ein Weekday
        scrollDirection: Axis.horizontal, // horizontal scrollen
        itemCount: weekdays.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime buttondate = monday.add(Duration(days: index));
          String formattedDate = DateFormat('dd.MM').format(buttondate);
          return GestureDetector(
            // verarbeitet Benutzerinteraktionen
            onTap: () {
              //updateDayColor(index);
              dayUpdateFunction(buttondate);
            },
            child: Container(
              // Aussehen der Karte
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 70,
              width: 46,
              decoration: BoxDecoration(
                  // Rahmen & Hintergrund des Containers
                  color: getCardColor(buttondate),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                // Text in Container (Kinderinhalt) wird zentriert
                child: Text(
                  "${weekdays[index]}\n$formattedDate", //Schriftgrösse & Art etc.
                  style: TextStyle(
                      fontSize: 16,
                      color: getTextColor(buttondate),
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
