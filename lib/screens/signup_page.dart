import 'package:flutter/material.dart';
import 'dart:math';
import '../services/database_service.dart';
import '../models/player.dart';
import '../widgets/pixel_button.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  String _generateScrollCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return Iterable.generate(8, (_) => chars[Random().nextInt(chars.length)]).join();
  }

  Future<void> _handleSignup() async {
    // 1. VALIDATION
    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = "FIELDS CANNOT BE EMPTY!");
      return;
    }

    setState(() => _errorMessage = null);

    try {
      String code = _generateScrollCode();
      
      final newPlayer = Player()
        ..username = _usernameController.text
        ..password = _passwordController.text
        ..recoveryCode = code
        ..xp = 0
        ..level = 1;

      // 2. SAVE TO DATABASE
      await DatabaseService.savePlayer(newPlayer);

      if (mounted) {
        _showScrollResult(context, code);
      }
    } catch (e) {
      debugPrint("DATABASE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Stack(
        children: [
          // BACKGROUND LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/library.png', 
              fit: BoxFit.cover, 
              filterQuality: FilterQuality.none,
            ),
          ),

          // FORM CONTENT
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("HERO REGISTRATION", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 40),

                  if (_errorMessage != null) 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),

                  // PIXELATED FORM FIELDS
                  _buildPixelTextField(controller: _usernameController, hintText: "USERNAME"),
                  const SizedBox(height: 15),
                  _buildPixelTextField(controller: _passwordController, hintText: "PASSWORD", obscure: true),
                  const SizedBox(height: 30),

                  // START YOUR QUEST BUTTON (Top of the action area)
                  PixelButton(
                    text: "START YOUR QUEST", 
                    color: Colors.green,
                    onTap: _handleSignup,
                  ),

                  const SizedBox(height: 30),

                  // ALREADY HAVE AN ACCOUNT (Bottom link)
                  GestureDetector(
                    onTap: () {
                      // Logic to navigate to Login/Restore page
                      debugPrint("Navigate to login triggered");
                    },
                    child: const Text("ALREADY HAVE AN ACCOUNT?",
                      style: TextStyle(
                        color: Colors.amber, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
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

  Widget _buildPixelTextField({required TextEditingController controller, required String hintText, bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, letterSpacing: 2),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _showScrollResult(BuildContext context, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.yellow, width: 4)),
        title: const Text("📜 YOUR RECOVERY SCROLL", style: TextStyle(color: Colors.yellow, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("SAVE THIS CODE TO RESTORE YOUR ACCOUNT WHEN ACCIDENTICALLY LOST.", style: TextStyle(color: Colors.white, fontSize: 10)),
            const SizedBox(height: 20),
            SelectableText(code, style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const HomePage()), 
                (route) => false
              );
            },
            child: const Text("I HAVE SAVED IT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}