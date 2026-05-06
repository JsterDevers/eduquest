import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'start_adventure_page.dart';

class EduQuestSplashScreen extends StatefulWidget {
  const EduQuestSplashScreen({super.key});

  @override
  State<EduQuestSplashScreen> createState() => _EduQuestSplashScreenState();
}

class _EduQuestSplashScreenState extends State<EduQuestSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    
    // 1. Trigger the 3-second jingle
    _playStartupSound();

    // 2. Set the Dot Animation to exactly 3 seconds to match the audio
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // 3. Set the Navigation Delay to exactly 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartAdventurePage()),
        );
      }
    });
  }

  Future<void> _playStartupSound() async {
    try {
      await _audioPlayer.play(AssetSource('Startupsound.mp3'));
    } catch (e) {
      debugPrint("Startup audio failed: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Professional black background
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none, 
              ),
            ),

            // ANIMATED DOTS (Synced to 3 seconds)
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
    const dotCount = 12;

    for (int i = 0; i < dotCount; i++) {
      final double angle = (i * 2 * math.pi / dotCount) + (progress * 2 * math.pi);
      double opacity = (i / dotCount); 
      
      final paint = Paint()
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