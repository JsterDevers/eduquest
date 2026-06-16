import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/player_stats_display.dart'; // FIXED: Pointed straight to your active widgets directory layout level

class PomodoroTimerPage extends StatefulWidget {
  final VoidCallback? onBack; // FIXED: Replaced non-nullable null parameter type definition with the clean dynamic callback

  const PomodoroTimerPage({super.key, this.onBack});

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  // Timer State Variables
  Timer? _timer;
  int _secondsRemaining = 1500; // Default to 25 minutes (25 * 60)
  bool _isRunning = false;
  String _currentMode = "FOCUS"; // Modes: FOCUS (25:00), LONG (10:00), SHORT (5:00)

  @override
  void initState() {
    super.initState();
    // Evicts the asset from memory cache on load to guarantee it clears out any black image bugs!
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Color _getBoxColor() {
    switch (_currentMode) {
      case "LONG":
        return const Color(0xFF2B7BB9); // Deep Sky Blue
      case "SHORT":
        return const Color(0xFF2C8C4E); // Forest Green
      case "FOCUS":
      default:
        return const Color(0xFF912B2B); // Crimson Red
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.heavyImpact();
          setState(() => _isRunning = false);
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_currentMode == "FOCUS") _secondsRemaining = 1500;
      if (_currentMode == "LONG") _secondsRemaining = 600;
      if (_currentMode == "SHORT") _secondsRemaining = 300;
    });
  }

  void _switchMode(String mode, int seconds) {
    _timer?.cancel();
    setState(() {
      _currentMode = mode;
      _secondsRemaining = seconds;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Ensures it sits perfectly over home page root layers
      body: Stack(
        children: [
          // 1. BACKGROUND GRID LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. FOREGROUND SYSTEM WRAPPER
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TOP METRICS BAR
                  const PlayerStatsDisplay(),

                  // HEADER BANNER WITH BACK NAVIGATOR
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/pomodoro_timer.png', 
                          key: const ValueKey('pomodoro_banner_asset'), // Forces Flutter to completely rebuild the graphic layer cleanly instead of loading black pixels
                          fit: BoxFit.fitWidth,
                          gaplessPlayback: true, // Prevents flickering or texture drop outs during state resets
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              SystemSound.play(SystemSoundType.click);
                              HapticFeedback.lightImpact();
                              
                              // FIXED: Calls your parent view switcher natively. Never triggers crashing Navigator pops!
                              if (widget.onBack != null) {
                                widget.onBack!();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // MAIN CONTROLLERS INTERACTION WINDOW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      children: [
                        // PROGRESS STREAK FLAME ELEMENT
                        Container(
                          height: 24,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16102E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4A3A85), width: 2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor: _isRunning ? (_secondsRemaining / (_currentMode == "FOCUS" ? 1500 : _currentMode == "LONG" ? 600 : 300)) : 0.75,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // MAIN CHAMELEON TIMER SCREEN COMPONENT
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 44),
                          decoration: BoxDecoration(
                            color: _getBoxColor(), 
                            border: Border.all(color: const Color(0xFF150D35), width: 5),
                            boxShadow: const [
                              BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _formatTime(_secondsRemaining),
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                color: Colors.white,
                                fontSize: 36, 
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black54, offset: Offset(3, 3)),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // BUTTONS ROW 1: BREAK TIME SELECTORS
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedRetroButton(
                                label: "LONG BREAK",
                                color: const Color(0xFFFFF6EA),
                                textColor: const Color(0xFF3E2C78),
                                onTap: () => _switchMode("LONG", 600),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: AnimatedRetroButton(
                                label: "SHORT BREAK",
                                color: const Color(0xFF2C8C4E), 
                                textColor: Colors.white,
                                onTap: () => _switchMode("SHORT", 300),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // BUTTONS ROW 2: CONTROLLERS
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedRetroButton(
                                label: _isRunning ? "PAUSE" : "START",
                                color: const Color(0xFF532E74),
                                textColor: Colors.white,
                                onTap: _toggleTimer,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: AnimatedRetroButton(
                                label: "RESET",
                                color: const Color(0xFFFFF6EA),
                                textColor: const Color(0xFF3E2C78),
                                onTap: _resetTimer,
                              ),
                            ),
                          ],
                        ),

                        // BLOCK DESIGN RETURN TO STUDY MODE 25:00 BOX
                        if (_currentMode != "FOCUS") ...[
                          const SizedBox(height: 24),
                          AnimatedRetroButton(
                            label: "◀ RETURN TO FOCUS MODE (25:00)",
                            color: const Color(0xFF912B2B), 
                            textColor: Colors.white,
                            onTap: () => _switchMode("FOCUS", 1500),
                          ),
                        ],
                        
                        const SizedBox(height: 120), // Bottom clearance buffer
                      ],
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
}

// RETRO ANIMATED SQUISH PRESS BUTTON MOTOR
class AnimatedRetroButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const AnimatedRetroButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<AnimatedRetroButton> createState() => _AnimatedRetroButtonState();
}

class _AnimatedRetroButtonState extends State<AnimatedRetroButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) {
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.lightImpact();
          _controller.forward();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          _controller.reverse();
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () {
          _controller.reverse();
          setState(() => _isPressed = false);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: const Color(0xFF150D35), width: 3),
            boxShadow: [
              if (!_isPressed)
                const BoxShadow(
                  color: Color(0x99000000),
                  offset: Offset(0, 5),
                ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: widget.textColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                shadows: widget.textColor == Colors.white 
                  ? [const Shadow(color: Colors.black54, offset: Offset(1, 1))]
                  : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}