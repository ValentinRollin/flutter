import 'package:flutter/material.dart';
import '../models/question.dart';
import '../widgets/question_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<QuizPage> createState() => SomeQuizzPageState();
}

class SomeQuizzPageState extends State<QuizPage> {
  final List<Question> _questions = [
    Question(
        questionText: "LeBron James a été drafté en 2003 par les Cleveland Cavaliers ?",
        isCorrect: true, imagePath: 'assets/images/lebron-james.png',
    ),
    Question(
        questionText: "Les Golden State Warriors ont remporté 3 titres entre 2015 et 2019 ?",
        isCorrect: true, imagePath: 'assets/images/gsw_logo.png',
    ),
    Question(
        questionText: "Michael Jordan a remporté tous ses titres NBA avec les Chicago Bulls ?",
        isCorrect: true, imagePath: 'assets/images/mj.png',
    ),
    Question(
        questionText: "Kobe Bryant a toujours porté le numéro 24 pendant sa carrière ?",
        isCorrect: false, imagePath: 'assets/images/kobe.png',
    ),
    Question(
        questionText: "Giannis Antetokounmpo est surnommé 'The Greek Freak' ?",
        isCorrect: true, imagePath: 'assets/images/giannis.png',
    ),
    Question(
        questionText: "La ligne à 3 points a été introduite en 1980 ?",
        isCorrect: false, imagePath: 'assets/images/nba_logo.jpg',
    ),
    Question(
        questionText: "Russell Westbrook détient le record du plus grand nombre de triple-doubles en carrière NBA ?",
        isCorrect: true, imagePath: 'assets/images/westbrook.png',
    ),
    Question(
        questionText: "Wilt Chamberlain détient le record de points marqués en un seul match NBA ?",
        isCorrect: true, imagePath: 'assets/images/chamberlin.png',
    ),
    Question(
        questionText: "Les San Antonio Spurs ont remporté leur premier titre NBA en 1999 ?",
        isCorrect: true, imagePath: 'assets/images/spurs.png',
    ),
    Question(
        questionText: "Shaquille O'Neal a remporté 4 titres NBA dans sa carrière ?",
        isCorrect: true, imagePath: 'assets/images/shaq.png',
    ),
  ];


  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affiche l'image associée à la question actuelle
            Image.asset(
              _questions[_currentQuestionIndex].imagePath, // Image dynamique
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Barre de progression
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.deepPurple[100],
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            // Question actuelle
            QuestionCard(question: _questions[_currentQuestionIndex]),
            const SizedBox(height: 20),
            // Boutons de réponse
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () => _checkAnswer(true, context),
                  child: const Text("Vrai", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () => _checkAnswer(false, context),
                  child: const Text("Faux", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Score actuel
            Text(
              "Score: $_score/${_questions.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour vérifier la réponse
  bool _checkAnswer(bool userChoice, BuildContext context) {
    if (_questions[_currentQuestionIndex].isCorrect == userChoice) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion(context);
    return userChoice;
  }

  // Passer à la question suivante
  Question _nextQuestion(BuildContext context) {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showScore(context);
      }
    });

    return _questions[_currentQuestionIndex];
  }

  // Afficher le score final
  void _showScore(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50],
          title: const Text("Quiz terminé", style: TextStyle(color: Colors.blue)),
          content: Text(
            "Votre score est de $_score/${_questions.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartQuiz();
              },
              child: const Text("Recommencer"),
            ),
          ],
        );
      },
    );
  }

  // Réinitialiser le quiz
  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }
}