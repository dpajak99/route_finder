import 'package:flutter/material.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:path_finder/views/pages/main/main_page.dart';

Future<void> main() async {
  initLocator();
  // await postgresDatabase.initConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}
