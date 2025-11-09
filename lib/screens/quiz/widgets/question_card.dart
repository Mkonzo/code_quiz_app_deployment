import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function(int) onAnswer;
  final bool isAnswered;
  final int? selectedAnswer;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswer,
    required this.isAnswered,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              if (question.codeSnippet != null) ...[
                const SizedBox(height: 16),
                _buildCodeDisplay(question.codeSnippet!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          question.options.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionButton(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeDisplay(String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          code,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            color: Colors.green[300],
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    final isCorrect = index == question.correctAnswer;
    final isSelected = index == selectedAnswer;

    Color backgroundColor;
    Color borderColor;
    IconData? icon;

    if (!isAnswered) {
      backgroundColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white.withOpacity(0.2);
    } else if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.2);
      borderColor = Colors.green;
      icon = Icons.check_circle;
    } else if (isSelected && !isCorrect) {
      backgroundColor = Colors.red.withOpacity(0.2);
      borderColor = Colors.red;
      icon = Icons.cancel;
    } else {
      backgroundColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white.withOpacity(0.1);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => onAnswer(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height:32,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.white.withOpacity(0.1),
border: Border.all(
color: Colors.white.withOpacity(0.3),
),
),
child: Center(
child: Text(
String.fromCharCode(65 + index), // A, B, C, D
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
),
),
const SizedBox(width: 16),
Expanded(
child: Text(
question.options[index],
style: const TextStyle(
fontSize: 16,
color: Colors.white,
height: 1.4,
),
),
),
if (icon != null) ...[
const SizedBox(width: 12),
Icon(
icon,
color: isCorrect ? Colors.green : Colors.red,
size: 24,
),
],
],
),
),
),
),
);
}
}
