import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'study_methods.dart';
import 'study_hub.dart';
import 'calender.dart'; 
import 'profile.dart';
import '../widgets/player_stats_display.dart'; 
import '../services/music_service.dart';
import '../widgets/ai_assistant_sheet.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Defaulting to Home Dashboard (Index 2)

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
    BackgroundMusic.stop(); // Safe cut background loop track on landing page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      extendBody: true, 
      body: AIAssistantWrapper(
        child: Stack(
          children: [
            // GLOBAL DIAMOND BACKGROUND LAYER
            Positioned.fill(
              child: Image.asset(
                'assets/bg2_1.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none, 
              ),
            ),
            
            // FULL-SCREEN SUB-PAGE VIEWPORTS CONTAINER
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      
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

// SCROLLABLE DASHBOARD VIEW WITH INTEGRATED STATS BAR AND BANNER
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              // 1. PLAYER STATS WIDGET: Aligned outside padding to mirror the calendar format perfectly
              const PlayerStatsDisplay(),
              
              // 2. MAIN TITLE BANNER: Rolls right underneath the stats display
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/eduquest_banner.png',
                  fit: BoxFit.fitWidth, 
                ),
              ),
              
              // 3. MAIN PADDED UI COMPONENTS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      width: double.infinity,
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
                    const SizedBox(height: 120), 
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

class EduQuestNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const EduQuestNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> _icons = const [
    Icons.emoji_objects_outlined,    
    Icons.backpack_outlined,         
    Icons.home_filled,               
    Icons.calendar_today_outlined,   
    Icons.person_outline,            
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 72, 
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12), 
        decoration: BoxDecoration(
          color: const Color(0xFF150727), 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(
            color: const Color(0xFF4A3A85), 
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45), 
              blurRadius: 10,
              offset: const Offset(0, 6), 
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: isSelected ? 6 : 0,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1A5E3),
                        shape: BoxShape.rectangle, 
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