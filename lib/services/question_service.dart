import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  final Map<String, List<Question>> _questionsCache = {};

  Future<List<Question>> loadQuestions({
    required ProgrammingLanguage language,
    required Difficulty difficulty,
  }) async {
    final cacheKey = '${language.name}_${difficulty.name}';
    
    if (_questionsCache.containsKey(cacheKey)) {
      return List.from(_questionsCache[cacheKey]!);
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/questions/${language.name}_${difficulty.name}.json',
      );
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonData['questions'];
      
      final questions = questionsJson
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();

      _questionsCache[cacheKey] = questions;
      
      return questions;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  List<Question> shuffleQuestions(List<Question> questions) {
    final shuffled = List<Question>.from(questions);
    shuffled.shuffle();
    return shuffled;
  }

  List<Question> getQuestionsByType(
    List<Question> questions,
    QuestionType type,
  ) {
    return questions.where((q) => q.type == type).toList();
  }

  void clearCache() {
    _questionsCache.clear();
  }
}