import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_stats.dart';
import '../models/quiz_session.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _statsKey = 'user_stats';
  static const String _quizHistoryKey = 'quiz_history';
  static const String _themeKey = 'theme_mode';

  Future<UserStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    
    if (statsJson == null) {
      return UserStats();
    }
    
    return UserStats.fromJson(json.decode(statsJson));
  }

  Future<void> saveStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, json.encode(stats.toJson()));
  }

  Future<void> updateStats(QuizSession session) async {
    final currentStats = await loadStats();
    
    final languageKey = session.language.name;
    final difficultyKey = session.difficulty.name;
    
    final updatedLanguageQuizzes = Map<String, int>.from(currentStats.languageQuizzes);
    updatedLanguageQuizzes[languageKey] = (updatedLanguageQuizzes[languageKey] ?? 0) + 1;
    
    final updatedDifficultyQuizzes = Map<String, int>.from(currentStats.difficultyQuizzes);
    updatedDifficultyQuizzes[difficultyKey] = (updatedDifficultyQuizzes[difficultyKey] ?? 0) + 1;
    
    final newStats = currentStats.copyWith(
      totalQuizzes: currentStats.totalQuizzes + 1,
      totalQuestions: currentStats.totalQuestions + session.totalQuestions,
      correctAnswers: currentStats.correctAnswers + session.correctAnswersCount,
      incorrectAnswers: currentStats.incorrectAnswers + session.incorrectAnswersCount,
      totalPoints: currentStats.totalPoints + session.totalScore,
      bestScore: session.totalScore > currentStats.bestScore 
          ? session.totalScore 
          : currentStats.bestScore,
      languageQuizzes: updatedLanguageQuizzes,
      difficultyQuizzes: updatedDifficultyQuizzes,
      lastQuizDate: DateTime.now(),
    );
    
    await saveStats(newStats);
  }

  Future<List<Map<String, dynamic>>> loadQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_quizHistoryKey);
    
    if (historyJson == null) {
      return [];
    }
    
    final List<dynamic> decoded = json.decode(historyJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveQuizToHistory(QuizSession session) async {
    final history = await loadQuizHistory();
    
    history.add({
      'language': session.language.name,
      'difficulty': session.difficulty.name,
      'score': session.totalScore,
      'correctAnswers': session.correctAnswersCount,
      'totalQuestions': session.totalQuestions,
      'date': DateTime.now().toIso8601String(),
    });
    
    if (history.length > 50) {
      history.removeAt(0);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quizHistoryKey, json.encode(history));
  }

  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}