import 'package:code_quiz_app/providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/quiz_provider.dart';
import '../home/home_screen.dart';
import '../difficulty_selection/difficulty_selection_screen.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionProvider);

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('No quiz data available')),
      );
    }

    final correctCount = session.correctAnswersCount;
    final totalQuestions = session.totalQuestions;
    final accuracy = (correctCount / totalQuestions * 100).round();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.amber,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quiz Complete!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildScoreCard(session.totalScore),
                const SizedBox(height: 24),
                _buildStatsGrid(session, correctCount, accuracy),
                const SizedBox(height: 32),
                _buildActionButtons(context, ref, session),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withAlpha(76),
            Colors.purple.withAlpha(76),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withAlpha(128),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Your Score',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'POINTS',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(session, int correctCount, int accuracy) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            label: 'Correct',
            value: '$correctCount',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel,
            label: 'Incorrect',
            value: '${session.incorrectAnswersCount}',
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.percent,
            label: 'Accuracy',
            value: '$accuracy%',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(128),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, session) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(quizSessionProvider.notifier).resetQuiz();
              // Invalidate the stats provider to refresh it
              ref.invalidate(statsProvider);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DifficultySelectionScreen(
                    language: session.language,
                  ),
                ),
                (route) => route.isFirst,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Try Again',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(quizSessionProvider.notifier).resetQuiz();
              // Invalidate the stats provider to refresh it
              ref.invalidate(statsProvider);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.home),
            label: const Text(
              'Back to Home',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}