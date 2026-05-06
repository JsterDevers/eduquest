import 'package:flutter/material.dart';
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
    // Keeps the magical library objects moving
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

  Future<void> _handleLogin() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "CREDENTIALS REQUIRED!");
      return;
    }

    // Call database to verify credentials
    final player = await DatabaseService.verifyPlayer(username, password);

    if (player != null && mounted) {
      // Clear the stack and go to the Home Page
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage()), 
        (route) => false
      );
    } else if (mounted) {
      setState(() => _errorMessage = "HERO NOT FOUND OR WRONG KEY!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Stack(
        children: [
          // 1. THE SHARED LIBRARY BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/library.png', 
              fit: BoxFit.cover, 
              filterQuality: FilterQuality.none, // Keeps pixel art sharp
            ),
          ),

          // 2. FLOATING MAGIC OBJECTS
          _buildFloatingBook(top: 100, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 150, left: 40, delay: 0.5),

          // 3. LOGIN FORM
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("HERO LOGIN", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 3,
                      shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
                    )),
                  const SizedBox(height: 40),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),

                  _buildPixelField(_userController, "USERNAME"),
                  const SizedBox(height: 15),
                  _buildPixelField(_passController, "PASSWORD", obscure: true),
                  const SizedBox(height: 30),

                  // Updated to use your custom PixelButton
                  PixelButton(
                    text: "ENTER CHRONICLES",
                    color: Colors.blueAccent,
                    onTap: _handleLogin,
                  ),

                  const SizedBox(height: 30),

                  // BACK NAVIGATION
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("GO BACK",
                      style: TextStyle(
                        color: Colors.white60, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )),
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
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, letterSpacing: 2),
        decoration: InputDecoration(
          hintText: hint, 
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
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
            child: Icon(Icons.auto_stories, color: const Color(0xFFB983FF).withOpacity(0.3), size: 35),
          );
        },
      ),
    );
  }
}