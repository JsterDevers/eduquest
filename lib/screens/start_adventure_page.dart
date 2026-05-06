import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For sounds and haptics
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

    // 1. Controller for the Title Floating (Up and Down)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 2. Controller for the "PRESS START" Blinking
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
    // Interaction effects
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
          // 1. THE SHARED BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. THE UI OVERLAY
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FLOATING TITLE
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      // Moves up and down by 15 pixels
                      offset: Offset(0, -15 * _floatController.value), 
                      child: child,
                    );
                  },
                  child: const Text(
                    "EDUQUEST",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(4, 4)),
                        Shadow(color: Colors.purple, blurRadius: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                // BLINKING PRESS START
                GestureDetector(
                  onTap: _handleStart,
                  child: FadeTransition(
                    opacity: _blinkController,
                    child: const Text(
                      "PRESS START",
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
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