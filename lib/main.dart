import 'package:flutter/material.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:path_finder/views/pages/demo_page.dart';


Future<void> main() async {
  await postgresDatabase.initConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: DemoPage(),
    );
  }
}
