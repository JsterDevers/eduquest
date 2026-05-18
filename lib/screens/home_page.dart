import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // RETAINED: Native permission channel handlers
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
    // 1. TERMINATE ADVENTURE MUSIC ENGINE IMMEDIATELY UPON LOGGING IN
    BackgroundMusic.stop();

    // 2. ULTIMATE MULTI-PERMISSION BUNDLE: Requests alerts, camera, media, and raw document access paths
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        // Structured registry array containing every single hardware permission anchor
        List<Permission> permissionsToRequest = [
          Permission.notification, // System quest notifications
          Permission.camera,       // Scanning codes or captured profile snaps
          Permission.photos,       // Android 13/14 Media Gallery Images
          Permission.videos,       // Android 13/14 Media Gallery Videos
          Permission.audio,        // Android 13/14 Media Gallery Audio clips
          Permission.storage,      // Legacy/General File Storage access (Crucial for PDFs, Docs, TXT files)
        ];

        // Fires the native system permission dialog loop down the entire list
        Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();
        
        // Diagnostic trace block to log out current security states in the VS Code debug terminal
        statuses.forEach((permission, status) {
          debugPrint("EDUQUEST CORE SECURITY: $permission is verified as -> $status");
        });

        // HARDWARE FALLBACK: If any path is hard-locked by a prior rejection flag,
        // take the player straight to the native settings menu to toggle them manually.
        if (statuses[Permission.notification]!.isPermanentlyDenied ||
            statuses[Permission.camera]!.isPermanentlyDenied ||
            statuses[Permission.photos]!.isPermanentlyDenied ||
            statuses[Permission.videos]!.isPermanentlyDenied ||
            statuses[Permission.audio]!.isPermanentlyDenied ||
            statuses[Permission.storage]!.isPermanentlyDenied) {
          debugPrint("EDUQUEST CORE SECURITY: Permanent block detected. Redirecting to system menu...");
          await openAppSettings();
        }
      }
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
      
      // Full-width edge-to-edge retro vector navigation
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
      height: 96, 
      color: const Color(0xFF1A0B2E), 
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB1A5E3), 
          border: Border(
            top: BorderSide(color: Color(0xFF4A3A85), width: 4), 
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
                          ? const Color(0xFFFAFAFA) 
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