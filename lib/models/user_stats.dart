class UserStats {
  final int totalQuizzes;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalPoints;
  final int bestScore;
  final Map<String, int> languageQuizzes;
  final Map<String, int> difficultyQuizzes;
  final DateTime? lastQuizDate;

  UserStats({
    this.totalQuizzes = 0,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.totalPoints = 0,
    this.bestScore = 0,
    Map<String, int>? languageQuizzes,
    Map<String, int>? difficultyQuizzes,
    this.lastQuizDate,
  })  : languageQuizzes = languageQuizzes ?? {},
        difficultyQuizzes = difficultyQuizzes ?? {};

  double get accuracyPercentage {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }

  double get averageScore {
    if (totalQuizzes == 0) return 0;
    return totalPoints / totalQuizzes;
  }

  UserStats copyWith({
    int? totalQuizzes,
    int? totalQuestions,
    int? correctAnswers,
    int? incorrectAnswers,
    int? totalPoints,
    int? bestScore,
    Map<String, int>? languageQuizzes,
    Map<String, int>? difficultyQuizzes,
    DateTime? lastQuizDate,
  }) {
    return UserStats(
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      totalPoints: totalPoints ?? this.totalPoints,
      bestScore: bestScore ?? this.bestScore,
      languageQuizzes: languageQuizzes ?? this.languageQuizzes,
      difficultyQuizzes: difficultyQuizzes ?? this.difficultyQuizzes,
      lastQuizDate: lastQuizDate ?? this.lastQuizDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalQuizzes': totalQuizzes,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
    'totalPoints': totalPoints,
    'bestScore': bestScore,
    'languageQuizzes': languageQuizzes,
    'difficultyQuizzes': difficultyQuizzes,
    'lastQuizDate': lastQuizDate?.toIso8601String(),
  };

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalQuizzes: json['totalQuizzes'] as int? ?? 0,
    totalQuestions: json['totalQuestions'] as int? ?? 0,
    correctAnswers: json['correctAnswers'] as int? ?? 0,
    incorrectAnswers: json['incorrectAnswers'] as int? ?? 0,
    totalPoints: json['totalPoints'] as int? ?? 0,
    bestScore: json['bestScore'] as int? ?? 0,
    languageQuizzes: Map<String, int>.from(json['languageQuizzes'] ?? {}),
    difficultyQuizzes: Map<String, int>.from(json['difficultyQuizzes'] ?? {}),
    lastQuizDate: json['lastQuizDate'] != null
        ? DateTime.parse(json['lastQuizDate'])
        : null,
  );
}