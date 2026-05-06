import 'package:flutter/material.dart';
import '../widgets/pixel_button.dart';
import 'restore_page.dart';
import 'login_page.dart';

class LoginChoicePage extends StatelessWidget {
  const LoginChoicePage({super.key});

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
              filterQuality: FilterQuality.none, // Keeps the 8-bit art sharp
            ),
          ),

          // 2. THE UI OVERLAY
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "HOW WILL YOU RETURN?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                PixelButton(
                  text: "USE USERNAME/PASS",
                  color: Colors.blueAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                ),

                const SizedBox(height: 25),

                PixelButton(
                  text: "USE RECOVERY SCROLL",
                  color: Colors.deepPurple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RestorePage()),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // RETURN TO PREVIOUS SCREEN
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "GO BACK",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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