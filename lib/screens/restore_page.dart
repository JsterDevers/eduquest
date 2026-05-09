import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // REQUIRED for formatters and feedback
import 'dart:math' as math;
import '../services/database_service.dart';
import 'home_page.dart';

class RestorePage extends StatefulWidget {
  const RestorePage({super.key});

  @override
  State<RestorePage> createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  late AnimationController _floatController;
  
  String? _errorMessage;
  bool _isSummonPressed = false; 
  bool _isBackPressed = false;   

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
    _codeController.dispose();
    super.dispose();
  }

  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  Future<void> _handleRestore() async {
    _playInteractionEffect(); 
    
    final inputCode = _codeController.text.trim();

    // 1. Check if the text field is empty
    if (inputCode.isEmpty) {
      setState(() => _errorMessage = "SCROLL EMPTY"); 
      return;
    }

    // 2. Strict Length Validation: Must be exactly 8 characters
    if (inputCode.length != 8) {
      setState(() => _errorMessage = "NEED 8 CHARS"); 
      return;
    }

    try {
      final player = await DatabaseService.getPlayerByCode(inputCode);

      if (player != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } else {
        setState(() => _errorMessage = "HERO NOT FOUND"); 
      }
    } catch (e) {
      debugPrint("Restore Error: $e");
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

          _buildFloatingBook(top: 150, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 200, left: 40, delay: 0.5),

          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _playInteractionEffect();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black45,
                child: const Text("< BACK", 
                  style: TextStyle(
                    fontFamily: 'PressStart2P', 
                    color: Colors.white70, 
                    fontSize: 10
                  )
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                            const SizedBox(height: 15),

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

                            _buildFieldLabel("SCROLL CODE", Icons.vpn_key_outlined),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                "ENTER YOUR 8-CHAR KEY",
                                style: TextStyle(
                                  fontFamily: 'PressStart2P',
                                  color: Color(0xFF432A5E),
                                  fontSize: 7,
                                ),
                              ),
                            ),

                            _buildPixelCodeField(),
                            const SizedBox(height: 28),

                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isSummonPressed = true);
                                _playInteractionEffect();
                              },
                              onTapUp: (_) => setState(() => _isSummonPressed = false),
                              onTapCancel: () => setState(() => _isSummonPressed = false),
                              onTap: _handleRestore,
                              child: AnimatedScale(
                                scale: _isSummonPressed ? 0.96 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706), 
                                    border: Border.all(color: const Color(0xFF78350F), width: 3),
                                    boxShadow: [
                                      if (!_isSummonPressed)
                                        const BoxShadow(color: Colors.black45, offset: Offset(4, 4))
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "SUMMON",
                                      style: TextStyle(
                                        fontFamily: 'PressStart2P',
                                        color: Colors.white,
                                        fontSize: 12,
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
                            "RESTORE",
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

  Widget _buildPixelCodeField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE9CE9E), 
        border: Border.all(color: const Color(0xFF6B431A), width: 3), 
        boxShadow: const [
          BoxShadow(
            color: Colors.greenAccent, 
            blurRadius: 12, 
            spreadRadius: -4,
          )
        ],
      ),
      child: TextField(
        controller: _codeController,
        maxLength: 8,
        textAlign: TextAlign.center,
        onTap: () => HapticFeedback.selectionClick(),
        
        // INTERACTIVE INPUT FORMATTERS REGISTERED HERE:
        inputFormatters: [
          LengthLimitingTextInputFormatter(8), // Hard caps entry at exactly 8 characters
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Block symbols, spaces, & emojis
          TextInputFormatter.withFunction((oldValue, newValue) {
            return newValue.copyWith(text: newValue.text.toUpperCase()); // Auto-capitalize letters instantly
          }),
        ],

        style: const TextStyle(
          fontFamily: 'PressStart2P',
          color: Color(0xFF1B4B30), 
          fontSize: 16, 
          letterSpacing: 4,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: "", 
          hintText: "--------",
          hintStyle: TextStyle(color: Colors.black12, letterSpacing: 4),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
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
          double offset = math.sin((_floatController.value + delay) * math.pi * 2) * 12;
          return Transform.translate(
            offset: Offset(0, offset),
            child: Icon(
              Icons.auto_stories, 
              color: const Color(0xFFB983FF).withOpacity(0.3), 
              size: 40
            ),
          );
        },
      ),
    );
  }
}