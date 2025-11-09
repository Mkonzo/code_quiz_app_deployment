import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_session.dart';
import '../result/result_screen.dart';
import 'widgets/question_card.dart';
import 'widgets/timer_widget.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _remainingTime = 30;
  Timer? _timer;
  bool _isAnswered = false;
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final session = ref.read(quizSessionProvider);
    if (session == null) return;

    _remainingTime = session.currentQuestion.timeLimit;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isAnswered) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime == 0 && !_isAnswered) {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      _isAnswered = true;
    });

    final session = ref.read(quizSessionProvider);
    if (session == null) return;

    ref.read(quizSessionProvider.notifier).answerQuestion(
          selectedAnswer: null,
          timeTaken: session.currentQuestion.timeLimit,
        );
  }

  void _handleAnswer(int answerIndex) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = answerIndex;
    });

    _timer?.cancel();

    final session = ref.read(quizSessionProvider);
    if (session == null) return;

    final timeTaken = session.currentQuestion.timeLimit - _remainingTime;

    ref.read(quizSessionProvider.notifier).answerQuestion(
          selectedAnswer: answerIndex,
          timeTaken: timeTaken,
        );
  }

  void _nextQuestion() {
    final session = ref.read(quizSessionProvider);
    if (session == null) return;

    if (session.hasNextQuestion) {
      ref.read(quizSessionProvider.notifier).nextQuestion();
      setState(() {
        _isAnswered = false;
        _selectedAnswer = null;
      });
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    await ref.read(quizSessionProvider.notifier).completeQuiz();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider);

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = session.currentQuestion;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E3A8A),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(session),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuestionCard(
                        question: question,
                        onAnswer: _handleAnswer,
                        isAnswered: _isAnswered,
                        selectedAnswer: _selectedAnswer,
                      ),
                      if (_isAnswered) ...[
                        const SizedBox(height: 24),
                        _buildExplanation(question.explanation),
                        const SizedBox(height: 24),
                        _buildNextButton(session),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(QuizSession session) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${session.currentQuestionIndex + 1}/${session.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              TimerWidget(
                remainingTime: _remainingTime,
                totalTime: session.currentQuestion.timeLimit,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: session.progressPercentage / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Score: ${session.totalScore}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  '${session.currentQuestion.points} pts',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation(String explanation) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.amber[300],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Explanation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            explanation,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(QuizSession session) {
    return ElevatedButton(
      onPressed: _nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            session.hasNextQuestion ? 'Next Question' : 'Finish Quiz',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}