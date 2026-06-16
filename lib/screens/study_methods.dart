import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/player_stats_display.dart'; // REQUIRED: Imports the scrolling stats bar widget
import 'study_methods/pomodoro_timer.dart';

class StudyMethodsPage extends StatefulWidget {
  const StudyMethodsPage({super.key});

  @override
  State<StudyMethodsPage> createState() => _StudyMethodsPageState();
}

class _StudyMethodsPageState extends State<StudyMethodsPage> {
  bool _showTimerPage = false; // Tracks whether to display the tile list or the timer widget in place

  @override
  Widget build(BuildContext context) {
    // FIXED: If the player clicks start, load the timer layout directly into this tab viewport!
    if (_showTimerPage) {
      return WillPopScope(
        onWillPop: () async {
          setState(() => _showTimerPage = false);
          return false; // Blocks full app backtrack pop routines
        },
        child: PomodoroTimerPage(
          // FIXED: Connects the back custom callback pointer natively to bypass asset graphic conflicts
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

              // 2. FULL-WIDTH STUDY METHODS HEADER BANNER ASSET
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/study_method.png', 
                  fit: BoxFit.fitWidth, 
                ),
              ),

              // 3. MAIN PADDED LIST CONTENT LAYER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // ITEM 1: SPACED REPETITION CARD
                    InteractiveMethodCard(
                      title: "Spaced Repetition",
                      description: "Review cards at increasing intervals",
                      icon: Icons.calendar_month_rounded,
                      baseColor: const Color(0xFFFFF4EE), // Pastel orange tint background
                      themeColor: const Color(0xFFDD6B2B), // Chunky border orange tone
                    ),
                    
                    const SizedBox(height: 18),

                    // ITEM 2: ACTIVE RECALL CARD
                    InteractiveMethodCard(
                      title: "Active Recall",
                      description: "Test Yourself from memory",
                      icon: Icons.lightbulb_rounded,
                      baseColor: const Color(0xFFFFFCE5), // Mellow yellow tint background
                      themeColor: const Color(0xFFD6A100), // Dark goldenrod border tone
                    ),
                    
                    const SizedBox(height: 18),

                    // ITEM 3: POMODORO TIMER CARD WITH ACTIVE CLICK BUTTON ACTION
                    InteractiveMethodCard(
                      title: "Pomodoro Timer",
                      description: "Start 25 min session",
                      icon: Icons.timer_rounded,
                      baseColor: const Color(0xFFFFEEFE), // Pastel magenta tint background
                      themeColor: const Color(0xFFBD49CC), // Pixel art purple-red tone border
                      hasActionButton: true,
                      onActionTap: () {
                        setState(() {
                          _showTimerPage = true;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 120), // Bottom spacer padding buffer so navbar never overlaps card items
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

// NEW COMPONENT: CUSTOM METHOD TILES EQUIPPED WITH FULL 8-BIT TACTILE FEEDBACK MECHANICS
class InteractiveMethodCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color baseColor;
  final Color themeColor;
  final bool hasActionButton;
  final VoidCallback? onActionTap;

  const InteractiveMethodCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.baseColor,
    required this.themeColor,
    this.hasActionButton = false,
    this.onActionTap,
  });

  @override
  State<InteractiveMethodCard> createState() => _InteractiveMethodCardState();
}

class _InteractiveMethodCardState extends State<InteractiveMethodCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60), // Fast 8-bit snap responses
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressDown() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
    _controller.forward();
    setState(() => _isPressed = true);
  }

  void _onPressUp() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _onPressDown(),
        onTapUp: (_) {
          _onPressUp();
          if (widget.hasActionButton && widget.onActionTap != null) {
            widget.onActionTap!();
          }
        },
        onTapCancel: () => _onPressUp(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: widget.baseColor, 
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(
              color: const Color(0xFF150D35), // Deep framing boundary stroke accent
              width: 4,
            ),
            boxShadow: [
              // Extrudes a flat solid color shadow; disappears smoothly when squished
              if (!_isPressed)
                BoxShadow(
                  color: widget.themeColor.withOpacity(0.4),
                  blurRadius: 0,
                  offset: const Offset(0, 6), 
                ),
            ],
          ),
          child: Row(
            children: [
              // FRONT INDICATOR BADGE
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF150D35),
                    width: 2,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: 26,
                  color: widget.themeColor,
                ),
              ),
              
              const SizedBox(width: 14),

              // TEXT SEGMENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: widget.themeColor, // Highlights label using its specific identity theme color
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(1, 1),
                          )
                        ]
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF4A3A85), // Clean high contrast dark indigo prose text
                        fontSize: 6,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ACTION LAYOUT ROUTER
              if (widget.hasActionButton)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: widget.themeColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF150D35), width: 2),
                    boxShadow: [
                      if (!_isPressed)
                        const BoxShadow(
                          color: Color(0x44000000),
                          offset: Offset(0, 3),
                        )
                    ]
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: widget.themeColor.withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }
}