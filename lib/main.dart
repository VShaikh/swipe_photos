import 'package:flutter/material.dart';
import 'package:swipe_photos/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Media Fi App',
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurpleAccent,
          useMaterial3: true,
        ),
        home: HomePageWidget());
  }
}
