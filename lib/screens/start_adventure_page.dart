import 'package:flutter/material.dart';
import '../widgets/pixel_button.dart';
import 'signup_page.dart';

class StartAdventurePage extends StatelessWidget {
  const StartAdventurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep the background color to prevent black flickering during D: drive lag
      backgroundColor: const Color(0xFF1A1A2E), 
      body: Stack(
        children: [
          // 1. THE SHARED BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none, // Keeps the 8-bit art sharp
            ),
          ),

          // 2. THE UI OVERLAY
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // RETAINED: MAIN START BUTTON
                PixelButton(
                  text: "Start Your Adventure",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}