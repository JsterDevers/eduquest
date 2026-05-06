import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_page.dart';

class StartAdventurePage extends StatefulWidget {
  const StartAdventurePage({super.key});

  @override
  State<StartAdventurePage> createState() => _StartAdventurePageState();
}

class _StartAdventurePageState extends State<StartAdventurePage> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  void _handleStart() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // Background Layer
          Positioned.fill(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D PIXELATED FLOATING TITLE
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -10 * _floatController.value),
                      child: child,
                    );
                  },
                  child: Text(
                    "EDUQUEST",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PressStart2P', 
                      color: Colors.white,
                      fontSize: 36, // PERFECTED SIZE: Smaller to fit screen nicely
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2, // Adjusted so letters don't overlap weirdly
                      shadows: [
                        // Sharp Black Outline
                        const Shadow(offset: Offset(-2, -2), color: Colors.black),
                        const Shadow(offset: Offset(2, -2), color: Colors.black),
                        const Shadow(offset: Offset(-2, 2), color: Colors.black),
                        const Shadow(offset: Offset(2, 2), color: Colors.black),
                        
                        // Solid 3D Extrusion (Reduced to 6 layers for better proportion)
                        const Shadow(offset: Offset(1, 1), color: Color(0xFF4A2B11)),
                        const Shadow(offset: Offset(2, 2), color: Color(0xFF4A2B11)),
                        const Shadow(offset: Offset(3, 3), color: Color(0xFF4A2B11)),
                        const Shadow(offset: Offset(4, 4), color: Color(0xFF4A2B11)),
                        const Shadow(offset: Offset(5, 5), color: Color(0xFF4A2B11)),
                        const Shadow(offset: Offset(6, 6), color: Color(0xFF4A2B11)),
                        
                        // Final Deep Background Shadow
                        const Shadow(offset: Offset(10, 10), color: Colors.black54),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // BLINKING PRESS START
                GestureDetector(
                  onTap: _handleStart,
                  child: FadeTransition(
                    opacity: _blinkController,
                    child: const Text(
                      "PRESS START",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Colors.yellowAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}