import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/quiz_bloc.dart';
import '../models/question.dart';

class QuizPage extends StatelessWidget {
  final List<Question> questions = [
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

  QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc(questions),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quiz NBA"),
          backgroundColor: Colors.deepPurple,
        ),
        backgroundColor: Colors.blueGrey,
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state.isCompleted) {
              // Affichage lorsque le quiz est terminé
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Quiz terminé ! Votre score : ${state.score}/${state.questions.length}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<QuizBloc>().add(ResetEvent()),
                      child: const Text("Recommencer"),
                    ),
                  ],
                ),
              );
            } else {
              // Affichage des questions en cours
              final progress = (state.currentQuestionIndex + 1) / state.questions.length;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image associée à la question
                    Image.asset(
                      state.currentQuestion.imagePath,
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
                    // Texte de la question
                    Text(
                      state.currentQuestion.questionText,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Boutons Vrai/Faux
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              context.read<QuizBloc>().add(AnswerEvent(true)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Vrai"),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<QuizBloc>().add(AnswerEvent(false)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Faux"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Affichage du score
                    Text(
                      "Score : ${state.score}/${state.questions.length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
