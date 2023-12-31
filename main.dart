import 'package:chatgpt_app_p/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatgpt App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:  Colors.green,
        useMaterial3: true
    ),
    home: const Chatscreen(),
    );
  }
}
 