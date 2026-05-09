import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'restore_page.dart';
import 'login_page.dart';

class LoginChoicePage extends StatefulWidget {
  const LoginChoicePage({super.key});

  @override
  State<LoginChoicePage> createState() => _LoginChoicePageState();
}

class _LoginChoicePageState extends State<LoginChoicePage> {
  // Animation states for the interactive elements
  bool _isUserPassPressed = false;
  bool _isRecoveryPressed = false;
  bool _isBackPressed = false;

  // HELPER: Play interaction feedback
  void _playInteractionEffect() {
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // OVERLAPPING CARD STACK
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // MAIN PARCHMENT CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E2C4), // Warm pixel cream/beige
                          border: Border.all(color: const Color(0xFF381B4B), width: 5),
                          borderRadius: BorderRadius.zero, 
                          boxShadow: const [
                            BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            
                            // SUBTITLE INSIDE PARCHMENT
                            const Text(
                              "CHOOSE YOUR ENTRY METHOD",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Color(0xFF432A5E), // Retro dark ink color
                                fontSize: 9,
                                height: 1.5,
                              ),
                            ),
                            
                            const SizedBox(height: 35),

                            // BUTTON 1: USERNAME & PASSWORD
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isUserPassPressed = true);
                                _playInteractionEffect();
                              },
                              onTapUp: (_) => setState(() => _isUserPassPressed = false),
                              onTapCancel: () => setState(() => _isUserPassPressed = false),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: AnimatedScale(
                                scale: _isUserPassPressed ? 0.96 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6), // Premium Blue Accent
                                    border: Border.all(color: const Color(0xFF1E3A8A), width: 3),
                                    boxShadow: [
                                      if (!_isUserPassPressed)
                                        const BoxShadow(color: Colors.black45, offset: Offset(4, 4))
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "USERNAME/PASS",
                                      style: TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Colors.white,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // BUTTON 2: RECOVERY SCROLL
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isRecoveryPressed = true);
                                _playInteractionEffect();
                              },
                              onTapUp: (_) => setState(() => _isRecoveryPressed = false),
                              onTapCancel: () => setState(() => _isRecoveryPressed = false),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RestorePage()),
                                );
                              },
                              child: AnimatedScale(
                                scale: _isRecoveryPressed ? 0.96 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6), // Magic Violet Accent
                                    border: Border.all(color: const Color(0xFF4C1D95), width: 3),
                                    boxShadow: [
                                      if (!_isRecoveryPressed)
                                        const BoxShadow(color: Colors.black45, offset: Offset(4, 4))
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "RECOVERY SCROLL",
                                      style: TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Colors.white,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // OVERLAPPING "RETURN" BANNER
                      Positioned(
                        top: -24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF753896), // Match RPG Purple
                            border: Border.all(color: const Color(0xFF381B4B), width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, offset: Offset(3, 3)),
                            ],
                          ),
                          child: const Text(
                            "RETURN",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // BOTTOM BACK BUTTON BAR (Matches the "Login >" style bar)
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isBackPressed = true);
                      _playInteractionEffect();
                    },
                    onTapUp: (_) => setState(() => _isBackPressed = false),
                    onTapCancel: () => setState(() => _isBackPressed = false),
                    onTap: () => Navigator.pop(context),
                    child: AnimatedScale(
                      scale: _isBackPressed ? 0.95 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21153B), // Navy purple block
                          border: Border.all(color: const Color(0xFF4C3075), width: 3),
                          boxShadow: [
                            if (!_isBackPressed)
                              const BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4))
                          ],
                        ),
                        child: const Center(
                          widthFactor: 1.0,
                          child: Text(
                            "< GO BACK",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.amber,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}