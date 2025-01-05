import 'package:flutter/material.dart';
import 'question.dart';

class QuizState with ChangeNotifier {
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

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isQuizCompleted => _currentQuestionIndex == _questions.length - 1;

  void checkAnswer(bool userChoice) {
    if (_questions[_currentQuestionIndex].isCorrect == userChoice) {
      _score++;
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (!isQuizCompleted) {
      _currentQuestionIndex++;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }
}