import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../models/quiz_session.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';

final questionServiceProvider = Provider((ref) => QuestionService());
final storageServiceProvider = Provider((ref) => StorageService());

final quizSessionProvider = NotifierProvider<QuizSessionNotifier, QuizSession?>(
  QuizSessionNotifier.new,
);

class QuizSessionNotifier extends Notifier<QuizSession?> {
  @override
  QuizSession? build() {
    return null;
  }

  Future<void> startQuiz({
    required ProgrammingLanguage language,
    required Difficulty difficulty,
  }) async {
    try {
      final questionService = ref.read(questionServiceProvider);
      final questions = await questionService.loadQuestions(
        language: language,
        difficulty: difficulty,
      );

      final shuffledQuestions = questionService.shuffleQuestions(questions);

      state = QuizSession(
        questions: shuffledQuestions,
        language: language,
        difficulty: difficulty,
        startTime: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to start quiz: $e');
    }
  }

  void answerQuestion({
    required int? selectedAnswer,
    required int timeTaken,
  }) {
    if (state == null) return;

    final currentQuestion = state!.currentQuestion;
    final isCorrect = selectedAnswer == currentQuestion.correctAnswer;
    
    int pointsEarned = 0;
    if (isCorrect) {
      final timeBonus = (currentQuestion.timeLimit - timeTaken).clamp(0, currentQuestion.timeLimit);
      pointsEarned = currentQuestion.points + timeBonus;
    }

    final answer = UserAnswer(
      questionId: currentQuestion.id,
      selectedAnswer: selectedAnswer,
      isCorrect: isCorrect,
      timeTaken: timeTaken,
      pointsEarned: pointsEarned,
      answeredAt: DateTime.now(),
    );

    state!.addAnswer(answer);
    state = QuizSession(
      questions: state!.questions,
      language: state!.language,
      difficulty: state!.difficulty,
      startTime: state!.startTime,
      currentQuestionIndex: state!.currentQuestionIndex,
      userAnswers: state!.userAnswers,
      totalScore: state!.totalScore,
      isCompleted: state!.isCompleted,
    );
  }

  void nextQuestion() {
    if (state == null) return;

    if (state!.hasNextQuestion) {
      state!.nextQuestion();
      state = QuizSession(
        questions: state!.questions,
        language: state!.language,
        difficulty: state!.difficulty,
        startTime: state!.startTime,
        currentQuestionIndex: state!.currentQuestionIndex,
        userAnswers: state!.userAnswers,
        totalScore: state!.totalScore,
        isCompleted: state!.isCompleted,
      );
    }
  }

  Future<void> completeQuiz() async {
    if (state == null) return;

    state!.complete();
    final storageService = ref.read(storageServiceProvider);
    await storageService.updateStats(state!);
    await storageService.saveQuizToHistory(state!);
  }

  void resetQuiz() {
    state = null;
  }
}