import 'package:flutter/material.dart'; // Grundlage Flutter Widgets und Stile
import 'package:todo_try/pages/home.dart'; // Importiert Home Page
import 'package:intl/date_symbol_data_local.dart'; // für Datumsformatierung
import 'package:flutter_localizations/flutter_localizations.dart'; //für Lokalisation

// Hauptfunktion, der Einstiegspunkt der Anwendung
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) {
    runApp(const TodoApp());
  });
}

//Das ist die Hauptklasse
class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //ermöglicht mehrere Lokale, heisst die Anwendung ist in der Lage angegebene Sprache anzuzeigen und formatieren
      supportedLocales: [
        Locale('de'), // Deutsch
        Locale('en'), // Englisch
      ],
      // Deaktiviert das Debug-Banner, obere recht Ecke
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
