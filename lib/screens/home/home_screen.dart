import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../language_selection/language_selection_screen.dart';
import '../statistics/statistics_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header section with fixed spacing
                Column(
                  children: [
                    Icon(
                      Icons.code,
                      size: 80, // Reduced from 100
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 16), // Reduced from 24
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.blue[300]!, Colors.purple[300]!],
                      ).createShader(bounds),
                      child: const Text(
                        'Code Quiz',
                        style: TextStyle(
                          fontSize: 36, // Reduced from 48
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced from 12
                    Text(
                      'Master programming one question at a time',
                      style: TextStyle(
                        fontSize: 16, // Reduced from 18
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40), // Space between header and buttons
                
                // Scrollable buttons section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuButton(
                          context: context,
                          icon: Icons.play_arrow,
                          title: 'Start Quiz',
                          subtitle: 'Test your knowledge',
                          colors: [Colors.blue[600]!, Colors.blue[800]!],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageSelectionScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          context: context,
                          icon: Icons.bar_chart,
                          title: 'Statistics',
                          subtitle: 'Track your progress',
                          colors: [Colors.purple[600]!, Colors.purple[800]!],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StatisticsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          context: context,
                          icon: Icons.emoji_events,
                          title: 'Achievements',
                          subtitle: 'Coming soon',
                          colors: [Colors.amber[600]!, Colors.amber[800]!],
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Achievements coming soon!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Reduced from 24
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white), // Reduced from 48
                const SizedBox(width: 16), // Reduced from 20
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20, // Reduced from 24
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12, // Reduced from 14
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18, // Reduced from 20
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}