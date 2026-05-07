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
    
    // 1. Play the startup sound immediately
    _playStartupSound();

    // 2. Dots now complete a full cycle every 5 seconds
    // This makes the animation smoother and less "rushed"
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // 3. Navigation Delay extended to 5 seconds
    // This provides a buffer for the Isar DB to initialize in main.dart
    Future.delayed(const Duration(seconds: 5), () {
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
      // Force volume to 1.0 (Maximum)
      await _audioPlayer.setVolume(1.0);
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
      backgroundColor: Colors.black, 
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

            // ANIMATED DOTS (Synced to 5 seconds)
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