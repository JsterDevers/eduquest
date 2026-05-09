import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'study_methods.dart';
import 'study_hub.dart';
import 'calender.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Default to Home Dashboard (Index 2)

  // Link actual interactive pages directly
  final List<Widget> _pages = [
    const StudyMethodsPage(), // Index 0
    const StudyHubPage(),     // Index 1
    const DashboardView(),    // Index 2
    const CalendarPage(),     // Index 3
    const ProfilePage(),      // Index 4
  ];

  // Helper for sound and touch feedback when tapping navigation items
  void _playNavFeedback() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Stack(
        children: [
          // 1. GLOBAL DIAMOND BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/bg2_1.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none, 
            ),
          ),

          // 2. ACTIVE VIEWPORT
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),

      // 3. RETRO DYNAMIC BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        height: 85, // Perfect height to comfortably fit icons and text labels
        decoration: const BoxDecoration(
          color: Color(0xFFC5BAF0), // Lavender background matching your screenshot
          border: Border(
            top: BorderSide(color: Color(0xFF5A469D), width: 4), // Solid dark purple outline
          ),
        ),
        child: Row(
          children: [
            _buildNavItem(0, "STUDY METHODS", Icons.emoji_objects_outlined),
            _buildDivider(),
            _buildNavItem(1, "STUDY HUB", Icons.backpack_outlined),
            _buildDivider(),
            _buildNavItem(2, "HOME", Icons.home_outlined),
            _buildDivider(),
            _buildNavItem(3, "CALENDAR", Icons.calendar_today_outlined),
            _buildDivider(),
            _buildNavItem(4, "PROFILE", Icons.person_outline),
          ],
        ),
      ),
    );
  }

  // Builder for the thin pixel divider line between tabs
  Widget _buildDivider() {
    return Container(
      width: 2,
      height: double.infinity,
      color: const Color(0xFF5A469D).withOpacity(0.3),
    );
  }

  // Dynamic state rendering matching your reference sheet image!
  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            _playNavFeedback();
            setState(() => _currentIndex = index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          color: isSelected 
              ? const Color(0xFFEBE5FF) // Selected Highlight
              : Colors.transparent,     // Muted Inactive
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon block flanked by left and right arrow indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Text(
                      "◀",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF5A469D),
                        fontSize: 8,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      icon,
                      color: const Color(0xFF5A469D),
                      size: isSelected ? 28 : 24, // Selected icon grows larger
                    ),
                  ),
                  if (isSelected)
                    const Text(
                      "▶",
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF5A469D),
                        fontSize: 8,
                      ),
                    ),
                ],
              ),
              
              // Animated vertical layout spacing and label presentation
              if (isSelected) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Color(0xFF5A469D),
                      fontSize: 5.5, // Tiny pixel size to fit inside tab boundaries
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 4. MAIN DASHBOARD CONTENT
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Keeps the global diamond grid visible
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2C4), // Warm Parchment Cream
            border: Border.all(color: const Color(0xFF381B4B), width: 5),
            boxShadow: const [
              BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.stars, color: Colors.amber, size: 40),
              SizedBox(height: 16),
              Text(
                "DASHBOARD",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Color(0xFF381B4B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "WELCOME BACK, HERO!",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Color(0xFF753896),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}