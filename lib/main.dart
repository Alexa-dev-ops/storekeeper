import 'package:flutter/material.dart';
import 'package:storekeeper/screens/welcome_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storekeeper App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: WelcomeScreen(),
    );
  }
}


