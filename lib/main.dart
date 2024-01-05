import 'package:flutter/material.dart';
import 'package:todo_try/pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      supportedLocales: [
        Locale('de'), // English
        Locale('en'), // Spanish
      ],
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
// Test Robert
