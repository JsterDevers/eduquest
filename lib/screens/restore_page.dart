import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // REQUIRED for sound and haptics
import 'dart:math' as math;
import '../services/database_service.dart';
import '../widgets/pixel_button.dart';
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

  // HELPER: Professional interaction feedback
  void _playInteractionEffect() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  Future<void> _handleRestore() async {
    _playInteractionEffect(); // Sound on button click
    
    final inputCode = _codeController.text.trim().toUpperCase();

    if (inputCode.isEmpty) {
      setState(() => _errorMessage = "SCROLL IS EMPTY"); // Shortened
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
        setState(() => _errorMessage = "HERO NOT FOUND"); // Shortened
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
          // 1. BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. MAGIC OBJECTS
          _buildFloatingBook(top: 150, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 200, left: 40, delay: 0.5),

          // 3. BACK BUTTON
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

          // 4. RESTORATION FORM
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "RESTORE HERO", 
                    style: TextStyle(
                      fontFamily: 'PressStart2P', // APPLIED
                      color: Colors.white, 
                      fontSize: 14, 
                      letterSpacing: 1,
                      shadows: [Shadow(color: Colors.black, offset: Offset(3, 3))],
                    )
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "ENTER 8-CHAR CODE", 
                    style: TextStyle(
                      fontFamily: 'PressStart2P', // APPLIED
                      color: Colors.white38, 
                      fontSize: 7
                    )
                  ),
                  const SizedBox(height: 40),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        _errorMessage!, 
                        style: const TextStyle(
                          fontFamily: 'PressStart2P', // APPLIED
                          color: Colors.redAccent, 
                          fontSize: 8,
                        )
                      ),
                    ),

                  _buildPixelCodeField(),

                  const SizedBox(height: 40),

                  PixelButton(
                    text: "SUMMON", // Shortened to fit the wider font
                    color: Colors.amber,
                    onTap: _handleRestore,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelCodeField() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.greenAccent, blurRadius: 10, spreadRadius: -5)
        ],
      ),
      child: TextField(
        controller: _codeController,
        maxLength: 8,
        textAlign: TextAlign.center,
        onTap: () => HapticFeedback.selectionClick(),
        style: const TextStyle(
          fontFamily: 'PressStart2P', // APPLIED TO INPUT
          color: Colors.greenAccent, 
          fontSize: 16, // Balanced for 8 characters width
          letterSpacing: 4
        ),
        decoration: const InputDecoration(
          counterText: "", 
          hintText: "--------",
          hintStyle: TextStyle(color: Colors.white12),
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
              color: Color(0xFFB983FF).withValues(alpha: 0.3), 
              size: 40
            ),
          );
        },
      ),
    );
  }
}