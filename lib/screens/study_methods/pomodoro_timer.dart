import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '/widgets/player_stats_display.dart'; // FIXED: Sits on the same level, use a single '../'

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  // Timer State Variables
  Timer? _timer;
  int _secondsRemaining = 1500; // Default to 25 minutes (25 * 60)
  bool _isRunning = false;
  String _currentMode = "FOCUS"; // Modes: FOCUS (25:00), LONG (10:00), SHORT (5:00)

  // Formatting utility to turn total seconds into a clean MM:SS string
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  // Gets the background tint of the retro display block based on your selection mode
  Color _getBoxColor() {
    switch (_currentMode) {
      case "LONG":
        return const Color(0xFF2B7BB9); // Deep Sky Blue for Long Breaks
      case "SHORT":
        return const Color(0xFF2C8C4E); // Forest Green for Short Breaks
      case "FOCUS":
      default:
        return const Color(0xFF912B2B); // Crimson/Apple Red for Active Study Focus
    }
  }

  // Core Timer Engine loop
  void _toggleTimer() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();

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
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_currentMode == "FOCUS") _secondsRemaining = 1500;
      if (_currentMode == "LONG") _secondsRemaining = 600;
      if (_currentMode == "SHORT") _secondsRemaining = 300;
    });
  }

  void _switchMode(String mode, int seconds) {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
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
      backgroundColor: Colors.transparent, // Inherits deep diamond background seamlessly
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOP STATUS METRICS
              const PlayerStatsDisplay(),

              // 2. EDGE-TO-EDGE HEADER BANNER WITH FUNCTIONAL BACK ARROW
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/pomodoro_timer.png', 
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  // BACK NAVIGATION LAYER
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          SystemSound.play(SystemSoundType.click);
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop(); // Clean stack pop returns to your previews tab view
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

              // 3. MAIN INTERACTION ENGINE CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    // DYNAMIC STREAK PROGRESS FLAME INDICATOR BAR
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

                    const SizedBox(height: 36),

                    // MAIN DYNAMIC CENTRAL COUNTDOWN TIMER BLOCK
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 48),
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

                    const SizedBox(height: 40),

                    // BUTTONS ROW 1: BREAK TIME SELECTORS
                    Row(
                      children: [
                        Expanded(
                          child: _buildRetroButton(
                            label: "LONG BREAK",
                            color: const Color(0xFFFFF6EA),
                            textColor: const Color(0xFF3E2C78),
                            onTap: () => _switchMode("LONG", 600), 
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildRetroButton(
                            label: "SHORT BREAK",
                            color: const Color(0xFF532E74),
                            textColor: Colors.white,
                            onTap: () => _switchMode("SHORT", 300), 
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // BUTTONS ROW 2: ENGINE TIMELINE RUN CONTROLLERS
                    Row(
                      children: [
                        Expanded(
                          child: _buildRetroButton(
                            label: _isRunning ? "PAUSE" : "START",
                            color: const Color(0xFF532E74),
                            textColor: Colors.white,
                            onTap: _toggleTimer,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildRetroButton(
                            label: "RESET",
                            color: const Color(0xFFFFF6EA),
                            textColor: const Color(0xFF3E2C78),
                            onTap: _resetTimer,
                          ),
                        ),
                      ],
                    ),

                    if (_currentMode != "FOCUS") ...[
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => _switchMode("FOCUS", 1500),
                        child: const Text(
                          "◀ Return to Focus Mode (25:00)",
                          style: TextStyle(fontFamily: 'PressStart2P', color: Colors.white70, fontSize: 8),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRetroButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF150D35), width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black45, offset: Offset(3, 3)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}