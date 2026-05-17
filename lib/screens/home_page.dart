import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; 
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

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Default to Home Dashboard (Index 2)

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
    BackgroundMusic.stop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPermissionPrimer(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
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
          ],
        ),
      ),
      
      // APPLIED CHANGELOG: Full-width edge-to-edge retro vector navigation
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

  void _showNotificationPermissionPrimer(BuildContext context) {
    bool isAcceptPressed = false;
    bool isDenyPressed = false;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.transparent, 
          contentPadding: EdgeInsets.zero,
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E2C4), 
                  border: Border.all(color: const Color(0xFF381B4B), width: 5),
                  boxShadow: const [
                    BoxShadow(color: Color(0xCC000000), offset: Offset(6, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9CE9E), 
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.add_alert_outlined,
                        color: Color(0xFF753896), 
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "QUEST ALERTS PERMISSION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF381B4B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const Divider(color: Color(0xFF6B431A), thickness: 2, height: 24),
                    const Text(
                      "EDUQUEST REQUESTS PRIVILEGES TO TRANSMIT LOCAL DAILY STUDY REMINDERS AND COMPLETED QUEST NOTIFICATIONS.\n\n"
                      "SECURE CORE LOG: IN ACCORDANCE WITH OUR ZERO-KNOWLEDGE ARCHITECTURE, NO TRACKING DATA IS GATHERED OR SENT EXTERNALLY. PERMISSION CAN BE REVOKED AT ANY TIME IN YOUR DEVICE SETTINGS.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: Color(0xFF432A5E),
                        fontSize: 7,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setDialogState(() => isDenyPressed = true),
                            onTapUp: (_) => setDialogState(() => isDenyPressed = false),
                            onTapCancel: () => setDialogState(() => isDenyPressed = false),
                            onTap: () {
                              SystemSound.play(SystemSoundType.click);
                              Navigator.pop(context); 
                            },
                            child: AnimatedScale(
                              scale: isDenyPressed ? 0.95 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444), 
                                  border: Border.all(color: const Color(0xFF991B1B), width: 2),
                                  boxShadow: [
                                    if (!isDenyPressed)
                                      const BoxShadow(color: Color(0x59000000), offset: Offset(3, 3))
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "DENY",
                                    style: TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setDialogState(() => isAcceptPressed = true),
                            onTapUp: (_) => setDialogState(() => isAcceptPressed = false),
                            onTapCancel: () => setDialogState(() => isAcceptPressed = false),
                            onTap: () async {
                              SystemSound.play(SystemSoundType.click);
                              Navigator.pop(context); 
                              await Permission.notification.request();
                            },
                            child: AnimatedScale(
                              scale: isAcceptPressed ? 0.95 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E), 
                                  border: Border.all(color: const Color(0xFF166534), width: 2),
                                  boxShadow: [
                                    if (!isAcceptPressed)
                                      const BoxShadow(color: Color(0x59000000), offset: Offset(3, 3))
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "ALLOW",
                                    style: TextStyle(
                                      fontFamily: 'PressStart2P',
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF753896), 
                    border: Border.all(color: const Color(0xFF381B4B), width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, offset: Offset(3, 3)),
                    ],
                  ),
                  child: const Text(
                    "SECURITY NOTICE",
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
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

// ====================================================================
// WIDER LAYOUT CONFIGURATION: ENLARGED NATIVE VECTOR RENDERING
// ====================================================================
class EduQuestNavbar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const EduQuestNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<EduQuestNavbar> createState() => _EduQuestNavbarState();
}

class _EduQuestNavbarState extends State<EduQuestNavbar> {
  int? _hoveredIndex;

  final List<Map<String, dynamic>> _navData = [
    {"label": "METHODS", "icon": Icons.emoji_objects_outlined},
    {"label": "HUB", "icon": Icons.backpack_outlined},
    {"label": "HOME", "icon": Icons.home_sharp},
    {"label": "CALENDAR", "icon": Icons.calendar_today_outlined},
    {"label": "PROFILE", "icon": Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96, // Increased height to comfortably support larger icons
      color: const Color(0xFF1A0B2E), // Base framing edge background color
      // FIXED: Removed external padding margins completely so it stretches edge-to-edge (More Wide)
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB1A5E3), // Your exact pastel purple color fill template
          border: Border(
            top: BorderSide(color: Color(0xFF4A3A85), width: 4), // Solid dark top border line
            bottom: BorderSide(color: Color(0xFF4A3A85), width: 2),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: List.generate(5, (index) {
            final bool isSelected = widget.currentIndex == index;
            final bool isHovered = _hoveredIndex == index;
            final item = _navData[index];

            return Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    SystemSound.play(SystemSoundType.click);
                    HapticFeedback.lightImpact();
                    widget.onTap(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    margin: isSelected 
                        ? const EdgeInsets.symmetric(horizontal: 1, vertical: 2) 
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFAFAFA) // Pure active card canvas highlight
                          : isHovered
                              ? const Color(0xFF9E8ED4).withOpacity(0.4)
                              : Colors.transparent,
                      borderRadius: isSelected ? BorderRadius.circular(6) : BorderRadius.zero,
                      border: isSelected
                          ? Border.all(color: const Color(0xFF4A3A85), width: 3)
                          : Border(
                              right: BorderSide(
                                color: index == 4 ? Colors.transparent : const Color(0xFF4A3A85).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected)
                              const Text(
                                "◀ ",
                                style: TextStyle(
                                  fontFamily: 'PressStart2P',
                                  color: Color(0xFF4A3A85),
                                  fontSize: 7,
                                ),
                              ),
                            Icon(
                              item['icon'] as IconData,
                              color: const Color(0xFF4A3A85),
                              // FIXED: Significantly increased size for large, highly scannable assets
                              size: isSelected ? 34 : 30, 
                            ),
                            if (isSelected)
                              const Text(
                                " ▶",
                                style: TextStyle(
                                  fontFamily: 'PressStart2P',
                                  color: Color(0xFF4A3A85),
                                  fontSize: 7,
                                ),
                              ),
                          ],
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: const TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Color(0xFF4A3A85),
                              fontSize: 5.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}