import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/home_screen.dart' show HomeScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive initialize
  await Hive.openBox('notesBox'); // Box open Karo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Notes App',
      debugShowCheckedModeBanner: false, 
      home: const HomeScreen()
    );
  }
}
