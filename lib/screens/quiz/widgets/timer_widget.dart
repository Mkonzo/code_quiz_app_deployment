import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int remainingTime;
  final int totalTime;

  const TimerWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final isLowTime = remainingTime <= 10;
    final percentage = remainingTime / totalTime;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLowTime
            ? Colors.red.withOpacity(0.2)
            : Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLowTime
              ? Colors.red.withOpacity(0.5)
              : Colors.blue.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isLowTime ? Colors.red[300] : Colors.blue[300],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${remainingTime}s',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLowTime ? Colors.red[300] : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}