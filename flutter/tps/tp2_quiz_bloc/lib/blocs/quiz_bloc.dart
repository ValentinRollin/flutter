import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/question.dart';

abstract class QuizEvent {}

class AnswerEvent extends QuizEvent {
  final bool userChoice;

  AnswerEvent(this.userChoice);
}

class ResetEvent extends QuizEvent {}

class QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;

  QuizState({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.score = 0,
  });

  bool get isCompleted => currentQuestionIndex >= questions.length;
  Question get currentQuestion => questions[currentQuestionIndex];
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc(List<Question> questions)
      : super(QuizState(questions: questions)) {
    on<AnswerEvent>((event, emit) {
      if (!state.isCompleted) {
        int newScore = state.score;
        if (state.currentQuestion.isCorrect == event.userChoice) {
          newScore++;
        }
        emit(QuizState(
          questions: state.questions,
          currentQuestionIndex: state.currentQuestionIndex + 1,
          score: newScore,
        ));
      }
    });

    on<ResetEvent>((event, emit) {
      emit(QuizState(questions: state.questions));
    });
  }
}
