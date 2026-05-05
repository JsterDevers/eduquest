import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'start_adventure_page.dart'; // Rerouted to Start Adventure

class EduQuestSplashScreen extends StatefulWidget {
  const EduQuestSplashScreen({super.key});

  @override
  State<EduQuestSplashScreen> createState() => _EduQuestSplashScreenState();
}

class _EduQuestSplashScreenState extends State<EduQuestSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // 1. Setup the Dot Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 2. CORRECTED FLOW: Loading -> Start Adventure
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartAdventurePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Fallback to prevent black screen
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // BACKGROUND LAYER
            Positioned.fill(
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none, // Keeps pixel art sharp
              ),
            ),

            // ANIMATED FADING DOTS
            Transform.translate(
              offset: const Offset(0, 145.0), 
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: DotCirclePainter(progress: _controller.value),
                    size: const Size(200, 200),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotCirclePainter extends CustomPainter {
  final double progress;
  DotCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 65.0; 
    const dotCount = 12; // Optimized count for performance

    for (int i = 0; i < dotCount; i++) {
      final double angle = (i * 2 * math.pi / dotCount) + (progress * 2 * math.pi);
      double opacity = (i / dotCount); 
      
      final paint = Paint()
        // Using withOpacity for broader emulator compatibility
        ..color = const Color(0xFFB983FF).withValues(alpha: opacity);

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      double dotSize = 3.0 + (2.0 * opacity); 
      canvas.drawCircle(Offset(x, y), dotSize, paint);
    }
  }

  @override
  bool shouldRepaint(DotCirclePainter oldDelegate) => true;
}