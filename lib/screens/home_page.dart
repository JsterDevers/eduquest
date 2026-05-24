import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; // RETAINED: Controls 5-minute cold restart rebirth loops
import 'study_methods.dart';
import 'study_hub.dart';
import 'calender.dart'; 
import 'profile.dart';
import '../services/music_service.dart';
import '../widgets/ai_assistant_sheet.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 2; // Default to Home Dashboard (Index 2)
  DateTime? _backgroundTimeMarker; // Tracks background sleep timestamps

  final List<Widget> _pages = [
    const StudyMethodsPage(), 
    const StudyHubPage(),     
    const DashboardView(),    
    const CalendarPage(),     
    const ProfilePage(),      
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Hook app state observer up to native system lines
    BackgroundMusic.stop(); // Safe cut background loop track on landing page
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Dismantle observer linkages safely
    super.dispose();
  }

  // FIXED: Handles non-blocking background lifecycle check calculations
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTimeMarker = DateTime.now();
      debugPrint("LIFECYCLE ENGINE: App suspended at $_backgroundTimeMarker");
    } 

    if (state == AppLifecycleState.resumed) {
      debugPrint("LIFECYCLE ENGINE: Player brought app back to focus.");
      
      // FIXED: Wrap calculations inside a post-frame callback thread loop
      // This forces Android to restore your touch stream FIRST, then calculate time differences right after!
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_backgroundTimeMarker != null) {
          final durationSpent = DateTime.now().difference(_backgroundTimeMarker!);
          
          // 5 Minutes Hard Reset Limit Check (300 seconds)
          if (durationSpent.inSeconds >= 300) {
            debugPrint("LIFECYCLE SECURITY: Game idle for 5+ minutes. Initializing COLD RESTART.");
            if (mounted) {
              Phoenix.rebirth(context); // Triggers absolute system rebirth pass fresh from splash!
            }
          } else {
            debugPrint("LIFECYCLE ENGINE: Welcome back! Quick suspension duration: ${durationSpent.inSeconds}s");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      extendBody: true, // Extends sub-pages smoothly underneath our floating bottom navbar
      body: AIAssistantWrapper(
        child: Stack(
          children: [
            // GLOBAL DIAMOND BACKGROUND
            Positioned.fill(
              child: Image.asset(
                'assets/bg2_1.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none, 
              ),
            ),
            
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),

            // FIXED REFERENCE PLATFORM LAYOUT
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =========================================================================
                    // 🪙 FUTURE METRICS CONTAINER PLATFORM
                    // TODO: Drop your Row widget here later for Level, Coins, and Flame Points!
                    // =========================================================================
                    const SizedBox(height: 38), // Shrunk from 52 to 38 to shift the banner upwards slightly

                    // EDUQUEST MAIN TITLE BANNER LAYER
                    SizedBox(
                      width: double.infinity, // Spans perfectly from left to right edge
                      child: Image.asset(
                        'assets/eduquest_banner.png',
                        fit: BoxFit.fitWidth, // Auto-sizes layout height dynamically
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // REDESIGNED: Sleek, high-fidelity professional RPG navbar widget 
      bottomNavigationBar: EduQuestNavbar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E2C4), 
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

class EduQuestNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const EduQuestNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> _icons = const [
    Icons.emoji_objects_outlined,    // METHODS
    Icons.backpack_outlined,         // HUB
    Icons.home_filled,               // HOME
    Icons.calendar_today_outlined,   // CALENDAR
    Icons.person_outline,            // PROFILE
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 72, // Reduced height for a sleeker profile layout
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12), // Floating container styling
        decoration: BoxDecoration(
          color: const Color(0xFF150727), // Deep midnight premium background
          borderRadius: BorderRadius.circular(16), // Smooth corner radius layout
          border: Border.all(
            color: const Color(0xFF4A3A85), // Neon accent boundary line
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45), // Clean alpha shadow depth
              blurRadius: 10,
              offset: const Offset(0, 6), // Soft dropshadow container accent
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final bool isSelected = currentIndex == index;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  HapticFeedback.lightImpact();
                  onTap(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dynamic scaling icon focus animation pass
                    AnimatedScale(
                      scale: isSelected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        _icons[index],
                        color: isSelected ? const Color(0xFFB1A5E3) : const Color(0xFF6E5D9E),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Active status indicator pip dot
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: isSelected ? 6 : 0,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1A5E3),
                        shape: BoxShape.rectangle, // Keeps the pixel-art block identity
                        boxShadow: [
                          if (isSelected)
                            const BoxShadow(
                              color: Color(0xFFB1A5E3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}