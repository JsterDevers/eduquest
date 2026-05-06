import 'package:flutter/material.dart';
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

  Future<void> _handleRestore() async {
    final inputCode = _codeController.text.trim().toUpperCase();

    if (inputCode.isEmpty) {
      setState(() => _errorMessage = "THE SCROLL IS EMPTY!");
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
        setState(() => _errorMessage = "HERO NOT FOUND IN CHRONICLES!");
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
          // 1. THE SHARED LIBRARY BACKGROUND (Matching Login/Signup)
          Positioned.fill(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            ),
          ),

          // 2. ANIMATED FLOATING OBJECTS
          _buildFloatingBook(top: 150, right: 50, delay: 0.0),
          _buildFloatingBook(bottom: 200, left: 40, delay: 0.5),

          // 3. BACK NAVIGATION
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 4. RESTORATION FORM
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("RESTORE FROM SCROLL", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
                    )),
                  const SizedBox(height: 10),
                  const Text("ENTER YOUR 8-CHARACTER CODE", 
                    style: TextStyle(color: Colors.white38, fontSize: 10)),
                  const SizedBox(height: 40),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(_errorMessage!, 
                        style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),

                  _buildPixelCodeField(),

                  const SizedBox(height: 40),

                  PixelButton(
                    text: "SUMMON HERO",
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
      width: 280,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: TextField(
        controller: _codeController,
        maxLength: 8,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.greenAccent, 
          fontSize: 22, 
          fontWeight: FontWeight.bold, 
          letterSpacing: 8
        ),
        decoration: const InputDecoration(
          counterText: "", 
          hintText: "--------",
          hintStyle: TextStyle(color: Colors.white12),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
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
            child: Icon(Icons.auto_stories, color: const Color(0xFFB983FF).withValues(alpha: 0.3), size: 40),
          );
        },
      ),
    );
  }
}