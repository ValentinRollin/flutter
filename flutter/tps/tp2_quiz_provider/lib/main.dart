import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/quiz_page.dart';
import 'models/quiz_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz NBA',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
    );
  }
}
