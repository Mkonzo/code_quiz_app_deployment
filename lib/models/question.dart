enum QuestionType {
  syntax,
  debug,
  output,
  complexity,
}

enum ProgrammingLanguage {
  python,
  javascript,
  java,
  cpp,
  dart,
}

enum Difficulty {
  easy,
  medium,
  hard,
}

class Question {
  final String id;
  final String question;
  final String? codeSnippet;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final QuestionType type;
  final ProgrammingLanguage language;
  final Difficulty difficulty;
  final int points;
  final int timeLimit;
  final String category;

  Question({
    required this.id,
    required this.question,
    this.codeSnippet,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.type,
    required this.language,
    required this.difficulty,
    required this.points,
    required this.timeLimit,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      codeSnippet: json['codeSnippet'] as String?,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correctAnswer'] as int,
      explanation: json['explanation'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      language: ProgrammingLanguage.values.firstWhere(
        (e) => e.name == json['language'],
      ),
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      points: json['points'] as int,
      timeLimit: json['timeLimit'] as int,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'codeSnippet': codeSnippet,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'type': type.name,
      'language': language.name,
      'difficulty': difficulty.name,
      'points': points,
      'timeLimit': timeLimit,
      'category': category,
    };
  }
}