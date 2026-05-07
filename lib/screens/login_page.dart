import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // REQUIRED for sound/haptics
import 'dart:math' as math;
import '../services/database_service.dart';
import '../widgets/pixel_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  late AnimationController _floatController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // HELPER: Professional interaction feedback
  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  Future<void> _handleLogin() async {
    _playInteractionEffect(); // Sound on button click
    
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "NEED KEYS!"); // Shortened for pixel width
      return;
    }

    final player = await DatabaseService.verifyPlayer(username, password);

    if (player != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage()), 
        (route) => false
      );
    } else if (mounted) {
      setState(() => _errorMessage = "WRONG CREDENTIALS!"); // Shortened for pixel width
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Stack(
        children: [
          // 1. BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/library.png', 
              fit: BoxFit.cover, 
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. MAGIC OBJECTS
          _buildFloatingBook(top: 100, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 150, left: 40, delay: 0.5),

          // 3. FORM
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "HERO LOGIN", 
                    style: TextStyle(
                      fontFamily: 'PressStart2P', // APPLIED
                      color: Colors.white, 
                      fontSize: 18, 
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black, offset: Offset(3, 3))],
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        _errorMessage!, 
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P', // APPLIED
                          color: Colors.redAccent, 
                          fontSize: 8,
                        ),
                      ),
                    ),

                  _buildPixelField(_userController, "USERNAME"),
                  const SizedBox(height: 15),
                  _buildPixelField(_passController, "PASSWORD", obscure: true),
                  const SizedBox(height: 30),

                  PixelButton(
                    text: "ENTER WORLD", // Shortened slightly
                    color: Colors.blueAccent,
                    onTap: _handleLogin,
                  ),

                  const SizedBox(height: 30),

                  // BACK NAVIGATION
                  GestureDetector(
                    onTap: () {
                      _playInteractionEffect();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "GO BACK",
                      style: TextStyle(
                        fontFamily: 'PressStart2P', // APPLIED
                        color: Colors.white60, 
                        fontSize: 8, 
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelField(TextEditingController controller, String hint, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onTap: () => HapticFeedback.selectionClick(), // Physical "tick" when tapping field
        style: const TextStyle(
          fontFamily: 'PressStart2P', // APPLIED TO INPUT
          color: Colors.white, 
          fontSize: 10,
        ),
        decoration: InputDecoration(
          hintText: hint, 
          hintStyle: const TextStyle(
            fontFamily: 'PressStart2P', // APPLIED TO HINT
            color: Colors.white24, 
            fontSize: 10,
          ),
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.all(15)
        ),
      ),
    );
  }

  Widget _buildFloatingBook({double? top, double? bottom, double? left, double? right, required double delay}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          double offset = math.sin((_floatController.value + delay) * math.pi * 2) * 15;
          return Transform.translate(
            offset: Offset(0, offset),
            child: const Icon(Icons.auto_stories, color: Color(0x4DB983FF), size: 35),
          );
        },
      ),
    );
  }
}