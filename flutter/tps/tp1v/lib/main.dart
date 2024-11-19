// importation du paquetage pour utiliser Material Design
import 'package:flutter/material.dart';
import './screens/home_screen.dart';


void main() => runApp(MyApp()); // point d'entrée
// Le widget racine de notre application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // une application utilisant Material Design
      title: 'TP1 Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ), // données relatives au thème choisi
      home: const ProfileHomePage(), // le widget de la page d'accueil
    );
  }
}