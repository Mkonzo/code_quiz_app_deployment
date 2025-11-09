import 'question.dart';

class QuizSession {
  final List<Question> questions;
  final ProgrammingLanguage language;
  final Difficulty difficulty;
  final DateTime startTime;
  
  int currentQuestionIndex;
  List<UserAnswer> userAnswers;
  int totalScore;
  bool isCompleted;

  QuizSession({
    required this.questions,
    required this.language,
    required this.difficulty,
    required this.startTime,
    this.currentQuestionIndex = 0,
    List<UserAnswer>? userAnswers,
    this.totalScore = 0,
    this.isCompleted = false,
  }) : userAnswers = userAnswers ?? [];

  Question get currentQuestion => questions[currentQuestionIndex];
  
  bool get hasNextQuestion => currentQuestionIndex < questions.length - 1;
  
  int get totalQuestions => questions.length;
  
  int get answeredQuestions => userAnswers.length;
  
  double get progressPercentage => 
      (answeredQuestions / totalQuestions) * 100;

  void addAnswer(UserAnswer answer) {
    userAnswers.add(answer);
    totalScore += answer.pointsEarned;
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      currentQuestionIndex++;
    }
  }

  void complete() {
    isCompleted = true;
  }

  int get correctAnswersCount =>
      userAnswers.where((answer) => answer.isCorrect).length;

  int get incorrectAnswersCount =>
      userAnswers.where((answer) => !answer.isCorrect).length;

  double get averageTimeTaken {
    if (userAnswers.isEmpty) return 0;
    final totalTime = userAnswers.fold<int>(
      0,
      (sum, answer) => sum + answer.timeTaken,
    );
    return totalTime / userAnswers.length;
  }
}

class UserAnswer {
  final String questionId;
  final int? selectedAnswer;
  final bool isCorrect;
  final int timeTaken;
  final int pointsEarned;
  final DateTime answeredAt;

  UserAnswer({
    required this.questionId,
    this.selectedAnswer,
    required this.isCorrect,
    required this.timeTaken,
    required this.pointsEarned,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'selectedAnswer': selectedAnswer,
    'isCorrect': isCorrect,
    'timeTaken': timeTaken,
    'pointsEarned': pointsEarned,
    'answeredAt': answeredAt.toIso8601String(),
  };

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
    questionId: json['questionId'] as String,
    selectedAnswer: json['selectedAnswer'] as int?,
    isCorrect: json['isCorrect'] as bool,
    timeTaken: json['timeTaken'] as int,
    pointsEarned: json['pointsEarned'] as int,
    answeredAt: DateTime.parse(json['answeredAt'] as String),
  );
}