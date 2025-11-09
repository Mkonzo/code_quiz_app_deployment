import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../difficulty_selection/difficulty_selection_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      LanguageOption(
        language: ProgrammingLanguage.python,
        name: 'Python',
        icon: '🐍',
        color: Colors.blue,
      ),
      LanguageOption(
        language: ProgrammingLanguage.javascript,
        name: 'JavaScript',
        icon: '⚡',
        color: Colors.yellow[700]!,
      ),
      LanguageOption(
        language: ProgrammingLanguage.java,
        name: 'Java',
        icon: '☕',
        color: Colors.red,
      ),
      LanguageOption(
        language: ProgrammingLanguage.cpp,
        name: 'C++',
        icon: '⚙️',
        color: Colors.purple,
      ),
      LanguageOption(
        language: ProgrammingLanguage.dart,
        name: 'Dart',
        icon: '🎯',
        color: Colors.teal,
      ),
    ];

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      return _buildLanguageCard(context, lang);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LanguageOption lang) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lang.color, lang.color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: lang.color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DifficultySelectionScreen(
                  language: lang.language,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lang.icon,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 12),
              Text(
                lang.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageOption {
  final ProgrammingLanguage language;
  final String name;
  final String icon;
  final Color color;

  LanguageOption({
    required this.language,
    required this.name,
    required this.icon,
    required this.color,
  });
}