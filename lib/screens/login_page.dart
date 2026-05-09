import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'dart:math' as math;
import '../services/database_service.dart';
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
  bool _obscurePassword = true; // State for password eye toggle
  bool _isLoginPressed = false; // State for button scaling animation
  bool _isBackPressed = false;  // State for back button scaling animation

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
    _playInteractionEffect(); 
    
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "NEED KEYS!"); 
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
      setState(() => _errorMessage = "HERO NOT FOUND!"); 
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

          // 2. MAGIC FLOATING OBJECTS
          _buildFloatingBook(top: 100, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 150, left: 40, delay: 0.5),

          // 3. SECURE PARCHMENT FORM
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
                      // MAIN PARCHMENT CONTAINER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E2C4), // Warm pixel cream/beige
                          border: Border.all(color: const Color(0xFF381B4B), width: 5),
                          borderRadius: BorderRadius.zero, 
                          boxShadow: const [
                            BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),

                            // ERROR BOX
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Colors.redAccent,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),

                            // USERNAME INPUT FIELD
                            _buildFieldLabel("USERNAME", Icons.person),
                            _buildPixelField(
                              controller: _userController,
                              hintText: "ENTER USERNAME",
                            ),
                            const SizedBox(height: 16),

                            // PASSWORD INPUT FIELD WITH TOGGLE EYE
                            _buildFieldLabel("PASSWORD", Icons.lock),
                            _buildPixelField(
                              controller: _passController,
                              hintText: "ENTER PASSWORD",
                              obscure: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF432A5E),
                                  size: 16,
                                ),
                                onPressed: () {
                                  _playInteractionEffect();
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            const SizedBox(height: 28),

                            // INTERACTIVE BLUE ACTION BUTTON
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isLoginPressed = true);
                                _playInteractionEffect();
                              },
                              onTapUp: (_) => setState(() => _isLoginPressed = false),
                              onTapCancel: () => setState(() => _isLoginPressed = false),
                              onTap: _handleSignupCheck,
                              child: AnimatedScale(
                                scale: _isLoginPressed ? 0.96 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6), // Premium Blue (Matches return choice flavor)
                                    border: Border.all(color: const Color(0xFF1E3A8A), width: 3),
                                    boxShadow: [
                                      if (!_isLoginPressed)
                                        const BoxShadow(color: Colors.black45, offset: Offset(4, 4))
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "ENTER WORLD",
                                      style: TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Colors.white,
                                        fontSize: 11,
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

                      // OVERLAPPING RPG "LOGIN" BANNER
                      Positioned(
                        top: -24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF753896), // Bold RPG Purple
                            border: Border.all(color: const Color(0xFF381B4B), width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, offset: Offset(3, 3)),
                            ],
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // BOTTOM INTERACTIVE NAV BAR
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
                          color: const Color(0xFF21153B), 
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

  // Wrapper for validation checks
  void _handleSignupCheck() {
    _handleLogin();
  }

  // Label Builder (Mini pixel icon + title)
  Widget _buildFieldLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF432A5E), size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              color: Color(0xFF432A5E), 
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Custom Parchment Input Box
  Widget _buildPixelField({
    required TextEditingController controller,
    required String hintText,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9CE9E), 
        border: Border.all(color: const Color(0xFF6B431A), width: 3), 
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onTap: () => HapticFeedback.selectionClick(),
        style: const TextStyle(
          fontFamily: 'PressStart2P',
          color: Color(0xFF381B4B),
          fontSize: 9,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.black26,
            fontSize: 8,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: InputBorder.none,
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