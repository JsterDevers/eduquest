import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For feedback
import '../widgets/pixel_button.dart';
import 'restore_page.dart';
import 'login_page.dart';

class LoginChoicePage extends StatelessWidget {
  const LoginChoicePage({super.key});

  // Helper for sound feedback when going back
  void _playBackEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Stack(
        children: [
          // 1. THE LIBRARY BACKGROUND
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
                const Text(
                  "HOW WILL YOU RETURN?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PressStart2P', // PIXELATED
                    color: Colors.white,
                    fontSize: 12, // Reduced for pixel font width
                    letterSpacing: 1,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                PixelButton(
                  text: "USERNAME/PASS", // Shortened for better fit
                  color: Colors.blueAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                ),

                const SizedBox(height: 25),

                PixelButton(
                  text: "RECOVERY SCROLL", // Shortened for better fit
                  color: Colors.deepPurple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RestorePage()),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // RETURN TO PREVIOUS SCREEN
                GestureDetector(
                  onTap: () {
                    _playBackEffect();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0x4d),
                      border: const Border(bottom: BorderSide(color: Colors.white60, width: 2)),
                    ),
                    child: const Text(
                      "GO BACK",
                      style: TextStyle(
                        fontFamily: 'PressStart2P', // PIXELATED
                        color: Colors.white60,
                        fontSize: 8,
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