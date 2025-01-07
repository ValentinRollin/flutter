import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart'; // Ajout pour les sons
import '../models/question.dart';

class QuizPage extends StatefulWidget {
  final String themeId;

  const QuizPage({super.key, required this.themeId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirestore();
  }

  Future<void> _fetchQuestionsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('question')
          .where('themeId', isEqualTo: widget.themeId)
          .get();

      final questions = snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _questions = questions;
        _isLoading = false;
      });

      print("Questions pour le thème ${widget.themeId} : $_questions");
    } catch (e) {
      print("Erreur lors de la récupération des questions : $e");
    }
  }

  void _checkAnswer(bool userChoice) {
    if (_questions[_currentQuestionIndex].isCorrect == userChoice) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _playSound(); // Lecture du son à la fin du quiz
      _showEndDialog();
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  Future<void> _playSound() async {
    final player = AudioPlayer();
    String soundUrl;

    if (_score >= (_questions.length / 2)) {
      // Si le joueur a bien répondu à la moitié des questions ou plus
      soundUrl = await FirebaseStorage.instance.ref('sounds/win.mp3').getDownloadURL();
    } else {
      // Si le joueur a échoué
      soundUrl = await FirebaseStorage.instance.ref('sounds/lose.mp3').getDownloadURL();
    }

    await player.play(UrlSource(soundUrl));
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quiz Terminé!"),
          content: Text("Votre score est de $_score/${_questions.length}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz();
              },
              child: const Text("Recommencer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucune question trouvée.")),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Firestore"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentQuestion.imagePath.isNotEmpty)
              currentQuestion.imagePath.startsWith('assets/')
                  ? Image.asset(
                currentQuestion.imagePath,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Erreur de chargement de l\'image',
                    style: TextStyle(color: Colors.red),
                  );
                },
              )
                  : Image.network(
                currentQuestion.imagePath,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Erreur de chargement de l\'image',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.deepPurple[100],
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _checkAnswer(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Vrai"),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Faux"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Score: $_score/${_questions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
