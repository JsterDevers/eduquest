import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/player_stats_display.dart'; // REQUIRED: Imports the scrolling stats bar widget

class StudyMethodsPage extends StatelessWidget {
  const StudyMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
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

              // 3. MAIN PADDED LIST CONTENT LAYER (Replicates design from image_f2b9ff.png)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // ITEM 1: SPACED REPETITION CARD
                    _buildMethodListTile(
                      title: "Spaced Repetition",
                      description: "Review cards at increasing intervals",
                      icon: Icons.calendar_month_rounded,
                      iconColor: const Color(0xFFDD6B2B), // Smooth orange tone
                    ),
                    
                    const SizedBox(height: 14),

                    // ITEM 2: ACTIVE RECALL CARD
                    _buildMethodListTile(
                      title: "Active Recall",
                      description: "Test Yourself from memory",
                      icon: Icons.lightbulb_rounded,
                      iconColor: const Color(0xFFFFCC00), // Vibrant yellow tone
                    ),
                    
                    const SizedBox(height: 14),

                    // ITEM 3: POMODORO TIMER CARD WITH ACTIVE CLICK BUTTON ACTION
                    _buildMethodListTile(
                      title: "Pomodoro Timer",
                      description: "Start 25 min session",
                      icon: Icons.timer_rounded,
                      iconColor: const Color(0xFFE53E3E), // Apple red tone
                      hasActionButton: true,
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

  // REPLICATED LAYOUT ENGINE COMPONENT FROM YOUR IMAGE REFERENCE
  Widget _buildMethodListTile({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    bool hasActionButton = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white, // Pure clean white background card base
        borderRadius: BorderRadius.circular(20), // Soft circular corners exactly matching your layout frame
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Light elegant profile depth shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // FRONT ICON DISPLAY INDICATOR CONTAINER
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12), // Subtle alpha background framing ring
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
          
          const SizedBox(width: 16),

          // TEXT LABEL CONTENT SEGMENT BLOCK
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P', // Maintains retro 8-bit visual identity
                    color: Color(0xFF5345A3), // Premium brand purple header accent tint
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Color(0xFF8F88C2), // Light muted indigo description tone
                    fontSize: 6,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ACTION COMPONENT ROUTING (Chevron Navigation vs. Pure Purple Action Tap Button)
          if (hasActionButton)
            GestureDetector(
              onTap: () {
                SystemSound.play(SystemSoundType.click);
                HapticFeedback.mediumImpact();
                debugPrint("POMODORO ENGINE: Session initialized!");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B39C6), // Royal purple brand primary color
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF150D35), width: 2), // Dark pixel border line accent
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
              ),
            )
          else
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.black87, // Matches the thin crisp arrow pointers in your image view
            ),
        ],
      ),
    );
  }
}