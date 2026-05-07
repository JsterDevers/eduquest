// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'dart:math';
import '../services/database_service.dart';
import '../models/player.dart';
import '../widgets/pixel_button.dart';
import 'home_page.dart';
import 'login_choice_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isAlreadyPressed = false;

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  String _generateScrollCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return Iterable.generate(8, (_) => chars[Random().nextInt(chars.length)]).join();
  }

  Future<void> _handleSignup() async {
    _playInteractionEffect(); 

    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = "FIELDS EMPTY!"); // Shortened for pixel font width
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
          Positioned.fill(
            child: Image.asset(
              'assets/library.png', 
              fit: BoxFit.cover, 
              filterQuality: FilterQuality.none,
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "HERO REGISTRATION", 
                    style: TextStyle(
                      fontFamily: 'PressStart2P', // APPLIED
                      color: Colors.white, 
                      fontSize: 14, 
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (_errorMessage != null) 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!, 
                        style: const TextStyle(
                          fontFamily: 'PressStart2P', // APPLIED
                          color: Colors.redAccent, 
                          fontSize: 8,
                        ),
                      ),
                    ),

                  _buildPixelTextField(controller: _usernameController, hintText: "USERNAME"),
                  const SizedBox(height: 15),
                  _buildPixelTextField(controller: _passwordController, hintText: "PASSWORD", obscure: true),
                  const SizedBox(height: 30),

                  PixelButton(
                    text: "START QUEST", // Shortened slightly to fit the wide font
                    color: Colors.green,
                    onTap: _handleSignup,
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isAlreadyPressed = true);
                      _playInteractionEffect();
                    },
                    onTapUp: (_) => setState(() => _isAlreadyPressed = false),
                    onTapCancel: () => setState(() => _isAlreadyPressed = false),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginChoicePage()),
                      );
                    },
                    child: AnimatedScale(
                      scale: _isAlreadyPressed ? 0.92 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border: Border.all(color: Colors.amber, width: 3),
                          boxShadow: [
                            if (!_isAlreadyPressed)
                              const BoxShadow(color: Colors.black54, offset: Offset(4, 4))
                          ],
                        ),
                        child: const Text(
                          "ALREADY HAVE AN ACCOUNT?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PressStart2P', // APPLIED
                            color: Colors.amber, 
                            fontSize: 7, // Reduced for multi-line safety
                          ),
                        ),
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
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onTap: () => HapticFeedback.selectionClick(),
        style: const TextStyle(
          fontFamily: 'PressStart2P', // APPLIED TO INPUT
          color: Colors.white, 
          fontSize: 10,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'PressStart2P', // APPLIED TO HINT
            color: Colors.white24, 
            fontSize: 10,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _showScrollResult(BuildContext context, String code) {
    _playInteractionEffect();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.yellow, width: 4)),
        title: const Text(
          "RECOVERY CODE", 
          style: TextStyle(
            fontFamily: 'PressStart2P', // APPLIED
            color: Colors.yellow, 
            fontSize: 12,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "SAVE THIS CODE TO RESTORE ACCESS.", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PressStart2P', // APPLIED
                color: Colors.white, 
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              code, 
              style: const TextStyle(
                fontFamily: 'PressStart2P', // APPLIED
                color: Colors.greenAccent, 
                fontSize: 18, // Reduced to ensure 8 characters fit
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _playInteractionEffect();
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const HomePage()), 
                (route) => false
              );
            },
            child: const Text(
              "I SAVED IT", 
              style: TextStyle(
                fontFamily: 'PressStart2P', // APPLIED
                color: Colors.white, 
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}