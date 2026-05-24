import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Local data preferences core
import 'login_choice_page.dart'; // Existing choice path file
import 'signup_page.dart'; // New onboarding registration path file
import 'home_page.dart'; // Home dashboard view file
import '../services/music_service.dart'; 

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

    // SEAMLESS AUDIO ENGAGEMENT: Loops background audio right as the screen builds
    BackgroundMusic.play();

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

  Future<void> _handleStart() async {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();

    // 1. Open the phone's native storage preferences sandbox
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // 2. Query system flags (Wiping storage automatically forces these to fallback values)
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? true;

    if (!mounted) return;

    // 3. PROFESSIONAL ARCHITECTURE ROUTING DECISION:
    if (isLoggedIn) {
      // Scenario A: Authenticated active hero session found
      debugPrint("ADVENTURE CORE: Active player matched. Synchronizing right to Dashboard!");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else if (isFirstTimeUser) {
      // Scenario B: Storage was wiped or new download install. Send to Character Creation!
      debugPrint("ADVENTURE CORE: Sandbox is completely clean. Re-routing straight to Account Sign-Up Gate.");
      
      // APPLIED: Mark flag as false here so they aren't trapped in an onboarding loop if they exit the signup halfway
      await prefs.setBool('isFirstTimeUser', false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()),
        );
      }
    } else {
      // Scenario C: Account exists but logged out. Send to Login Choice Menu.
      debugPrint("ADVENTURE CORE: Registered device detected. Presenting login choice screen scroll.");
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginChoicePage()),
        );
      }
    }
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
                  child: const Text(
                    "EDUQUEST",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PressStart2P', 
                      color: Colors.white,
                      fontSize: 36, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2, 
                      shadows: [
                        // Sharp Black Outline
                        Shadow(offset: Offset(-2, -2), color: Colors.black),
                        Shadow(offset: Offset(2, -2), color: Colors.black),
                        Shadow(offset: Offset(-2, 2), color: Colors.black),
                        Shadow(offset: Offset(2, 2), color: Colors.black),
                        
                        // Solid 3D Extrusion
                        Shadow(offset: Offset(1, 1), color: Color(0xFF4A2B11)),
                        Shadow(offset: Offset(2, 2), color: Color(0xFF4A2B11)),
                        Shadow(offset: Offset(3, 3), color: Color(0xFF4A2B11)),
                        Shadow(offset: Offset(4, 4), color: Color(0xFF4A2B11)),
                        Shadow(offset: Offset(5, 5), color: Color(0xFF4A2B11)),
                        Shadow(offset: Offset(6, 6), color: Color(0xFF4A2B11)),
                        
                        // Final Deep Background Shadow
                        Shadow(offset: Offset(10, 10), color: Colors.black54),
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