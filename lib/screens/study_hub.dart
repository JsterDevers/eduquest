import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/player_stats_display.dart'; 
import 'study_methods/pomodoro_timer.dart'; 

class StudyHubPage extends StatefulWidget {
  const StudyHubPage({super.key});

  @override
  State<StudyHubPage> createState() => _StudyHubPageState();
}

class _StudyHubPageState extends State<StudyHubPage> {
  bool _showTimerPage = false; // Tracks whether to display the tile grid or the timer in place

  @override
  Widget build(BuildContext context) {
    // FIXED: If toggled via the Practice Test card, render the timer directly inside this viewport context
    if (_showTimerPage) {
      return WillPopScope(
        onWillPop: () async {
          setState(() => _showTimerPage = false);
          return false;
        },
        child: PomodoroTimerPage(
          onBack: () {
            setState(() {
              _showTimerPage = false;
            });
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Inherits global homepage background asset pattern cleanly
      body: SafeArea(
        bottom: false, // Allows content to flow smoothly down behind the navbar margin overlay
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Forces banner elements to span fully edge-to-edge
            children: [
              // 1. PLAYER STATS WIDGET
              const PlayerStatsDisplay(),

              // 2. FULL-WIDTH STUDY HUB HEADER BANNER ASSET
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/study_hub.png', 
                  fit: BoxFit.fitWidth, 
                ),
              ),

              // 3. MAIN PADDED HUB FEATURE TILES CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                child: Column(
                  children: [
                    // ROW 1: FLASHCARDS & PRACTICE TEST
                    Row(
                      children: [
                        const Expanded(
                          child: InteractiveHubButton(
                            title: "FLASHCARDS",
                            icon: Icons.style_rounded,
                            topColor: Color(0xFF5B69E6),
                            bottomColor: Color(0xFF3B46A3),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InteractiveHubButton(
                            title: "PRACTICE TEST",
                            icon: Icons.menu_book_rounded,
                            topColor: const Color(0xFFBD49CC),
                            bottomColor: const Color(0xFF81268C),
                            onTap: () {
                              // FIXED: Triggers the inline tab view toggle state seamlessly!
                              setState(() {
                                _showTimerPage = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 18),

                    // ROW 2: STUDY GUIDES & UPLOAD MATERIALS
                    Row(
                      children: const [
                        Expanded(
                          child: InteractiveHubButton(
                            title: "STUDY GUIDES",
                            icon: Icons.assignment_rounded,
                            topColor: Color(0xFF389BE3),
                            bottomColor: Color(0xFF1F5F91),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InteractiveHubButton(
                            title: "UPLOAD MATERIALS",
                            icon: Icons.cloud_upload_rounded,
                            topColor: Color(0xFF8857F2),
                            bottomColor: Color(0xFF532BB3),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 120), // Bottom spacer padding buffer
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// INTERACTIVE BUTTON WIDGET WITH RETRO PRESS EFFECTS
class InteractiveHubButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final VoidCallback? onTap; 

  const InteractiveHubButton({
    super.key,
    required this.title,
    required this.icon,
    required this.topColor,
    required this.bottomColor,
    this.onTap,
  });

  @override
  State<InteractiveHubButton> createState() => _InteractiveHubButtonState();
}

class _InteractiveHubButtonState extends State<InteractiveHubButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60), 
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressDown() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
    _animationController.forward();
    setState(() => _isPressed = true);
  }

  void _onPressUp() {
    _animationController.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _onPressDown(),
        onTapUp: (_) => _onPressUp(),
        onTapCancel: () => _onPressUp(),
        onTap: () {
          debugPrint("STUDY HUB: Opened panel target -> ${widget.title}");
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          height: 135,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.topColor, widget.bottomColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(
              color: const Color(0xFF150D33), 
              width: 4,
            ),
            boxShadow: [
              if (!_isPressed)
                const BoxShadow(
                  color: Color(0x77000000),
                  blurRadius: 0,
                  offset: Offset(0, 6), 
                ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 38,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 6,
                right: 6,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P', 
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}