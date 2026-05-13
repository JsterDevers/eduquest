import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'dart:math';
import '../services/database_service.dart';
import '../models/player.dart';
import 'home_page.dart';
import 'login_choice_page.dart';
import '../services/music_service.dart'; 

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); 
  
  String? _errorMessage;
  bool _isAlreadyPressed = false;
  bool _isSignupPressed = false;
  bool _isAgreed = false; // Checkbox Agreement State

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // SEAMLESS AUDIO ENGAGEMENT: Ensures the tracking loops smoothly across workflows
    BackgroundMusic.play();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // HELPER: Play interaction feedback
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

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // 1. Basic empty field validation
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = "FIELDS EMPTY!");
      return;
    }

    // 2. Password matching validation
    if (password != confirmPassword) {
      setState(() => _errorMessage = "KEYS DO NOT MATCH!");
      return;
    }

    // 3. SECURE VALIDATION: Ensure checkbox is checked before writing to Isar DB
    if (!_isAgreed) {
      setState(() => _errorMessage = "ACCEPT THE OATH!");
      return;
    }

    setState(() => _errorMessage = null);

    try {
      String code = _generateScrollCode();
      final newPlayer = Player()
        ..username = username
        ..password = password
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
          // BACKGROUND LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/library.png', 
              fit: BoxFit.cover, 
              filterQuality: FilterQuality.none, 
            ),
          ),

          // SCROLLABLE CORE INTERFACE
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50), 

                  // OVERLAPPING HEADER STACK
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // MAIN PARCHMENT CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E2C4), 
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

                            // ERROR CONTAINER
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

                            // USERNAME FIELD
                            _buildFieldLabel("USERNAME", Icons.person),
                            _buildPixelField(
                              controller: _usernameController,
                              hintText: "ENTER USERNAME",
                            ),
                            const SizedBox(height: 16),

                            // PASSWORD FIELD
                            _buildFieldLabel("PASSWORD", Icons.lock),
                            _buildPixelField(
                              controller: _passwordController,
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
                            const SizedBox(height: 16),

                            // CONFIRM PASSWORD FIELD
                            _buildFieldLabel("CONFIRM PASSWORD", Icons.lock_clock_outlined),
                            _buildPixelField(
                              controller: _confirmPasswordController,
                              hintText: "RE-ENTER PASSWORD",
                              obscure: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF432A5E),
                                  size: 16,
                                ),
                                onPressed: () {
                                  _playInteractionEffect();
                                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // CUSTOM PIXELATED CHECKBOX ROW
                            _buildCheckboxRow(),
                            const SizedBox(height: 28),

                            // CUSTOM PIXEL SIGN UP BUTTON
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isSignupPressed = true);
                                _playInteractionEffect();
                              },
                              onTapUp: (_) => setState(() => _isSignupPressed = false),
                              onTapCancel: () => setState(() => _isSignupPressed = false),
                              onTap: _handleSignup,
                              child: AnimatedScale(
                                scale: _isSignupPressed ? 0.96 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF753896), 
                                    border: Border.all(color: const Color(0xFF381B4B), width: 3),
                                    boxShadow: [
                                      if (!_isSignupPressed)
                                        const BoxShadow(color: Colors.black45, offset: Offset(4, 4))
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // OVERLAPPING "SIGN UP" EMBLAZONED BANNER
                      Positioned(
                        top: -24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF753896),
                            border: Border.all(color: const Color(0xFF381B4B), width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, offset: Offset(3, 3)),
                            ],
                          ),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // BOTTOM INTERACTIVE NAVIGATION BAR
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
                      scale: _isAlreadyPressed ? 0.95 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21153B), 
                          border: Border.all(color: const Color(0xFF4C3075), width: 3),
                          boxShadow: [
                            if (!_isAlreadyPressed)
                              const BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "ALREADY REGISTERED? ",
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.white60,
                                fontSize: 8,
                              ),
                            ),
                            Text(
                              "LOGIN >",
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.amber,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

  // Helper Row for Custom Checkbox with Independent Taps
  Widget _buildCheckboxRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // The Interactive Box
        GestureDetector(
          onTap: () {
            _playInteractionEffect();
            setState(() => _isAgreed = !_isAgreed);
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFE9CE9E),
              border: Border.all(color: const Color(0xFF6B431A), width: 3),
            ),
            child: _isAgreed
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF381B4B),
                      size: 14,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        // The Clickable Oath Text
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _playInteractionEffect();
                  setState(() => _isAgreed = !_isAgreed);
                },
                child: const Text(
                  "I ACCEPT THE ",
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF432A5E),
                    fontSize: 7,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _playInteractionEffect();
                  _showTermsDialog(context); // Triggers Policy Dialog
                },
                child: const Text(
                  "OATH OF THE REALM",
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF753896),
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // POPUP DIALOG: Improvised Terms of Service & Privacy Policy
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.amber, width: 4),
        ),
        title: const Text(
          "📜 OATH OF THE REALM",
          style: TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.amber,
            fontSize: 12,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "1. DATA PRIVACY ACT COMPLIANCE\n\n"
                  "IN COMPLIANCE WITH THE DATA PRIVACY ACT, YOUR CHARACTER DATA (LEVEL, XP, AND ENCRYPTED PASSWORDS) IS STORED EXCLUSIVELY WITHIN YOUR DEVICE'S SECURED LOCAL SANDBOX.\n\n"
                  "WE DO NOT COLLECT, TRANSMIT, OR PROCESS ANY USER INFORMATION ON EXTERNAL CLOUD SERVERS, GUARANTEEING COMPLETE DATA SOVEREIGNTY AND A ZERO-KNOWLEDGE ARCHITECTURE.\n\n"
                  "2. DATA PROTECTION (SECURITY)\n\n"
                  "YOUR PASSWORD IS YOUR CRYPTOGRAPHIC KEY. IF LOST, ACCESS CAN ONLY BE RESTORED VIA YOUR UNIQUE 8-CHARACTER RECOVERY SCROLL. WE MAINTAIN ZERO BACKDOORS TO YOUR LOCAL STORE.\n\n"
                  "3. CODE OF CONDUCT (TERMS)\n\n"
                  "YOU AGREE NOT TO MANIPULATE OR MALICIOUSLY INJECT SPELLS INTO THE LOCAL CHRONICLES TO ARTIFICIALLY INFLATE XP OR LEVEL STATS. PLAY HONORABLY.",
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 8,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _playInteractionEffect();
              Navigator.pop(context);
            },
            child: const Text(
              "DISMISS",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.amber,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            fontFamily: 'PressStart2P',
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
                fontFamily: 'PressStart2P',
                color: Colors.white, 
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              code, 
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.greenAccent, 
                fontSize: 18,
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
                fontFamily: 'PressStart2P',
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