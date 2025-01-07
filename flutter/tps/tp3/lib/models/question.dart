class Question {
  final String questionText;
  final bool isCorrect;
  final String imagePath;

  Question({
    required this.questionText,
    required this.isCorrect,
    required this.imagePath,
  });

  // Ajout de la méthode pour convertir depuis Firestore
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionText: data['questionText'] ?? 'Question non spécifiée',
      isCorrect: data['isCorrect'] ?? false,
      imagePath: data['imagePath'] ?? '',
    );
  }
}
