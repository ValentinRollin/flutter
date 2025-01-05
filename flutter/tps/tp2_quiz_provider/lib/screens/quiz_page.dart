import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_state.dart';
import '../widgets/question_card.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);

    // Affiche une boîte de dialogue si le quiz est terminé
    if (quizState.isQuizCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEndDialog(context, quizState.score, quizState.totalQuestions);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz NBA"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.blueGrey,
      floatingActionButton: FloatingActionButton(
        onPressed: quizState.resetQuiz,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.refresh),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image des questions en haut
            QuestionCard(question: quizState.currentQuestion),
            const SizedBox(height: 20),
            // Barre de progression en dessous de l'image
            LinearProgressIndicator(
              value: (quizState.currentQuestionIndex + 1) / quizState.totalQuestions,
              backgroundColor: Colors.deepPurple[100],
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            // Boutons pour répondre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => quizState.checkAnswer(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Vrai"),
                ),
                ElevatedButton(
                  onPressed: () => quizState.checkAnswer(false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Faux"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Affichage du score
            Text(
              "Score: ${quizState.score}/${quizState.totalQuestions}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showEndDialog(BuildContext context, int score, int totalQuestions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quiz Terminé!"),
          content: Text("Votre score est de $score/$totalQuestions."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<QuizState>(context, listen: false).resetQuiz();
              },
              child: const Text("Recommencer"),
            ),
          ],
        );
      },
    );
  }
}
